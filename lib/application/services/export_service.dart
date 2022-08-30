import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:path/path.dart' as path_;
import 'package:rxdart/rxdart.dart';

import '../../runtime_helper.dart';
import '../../util/extensions.dart';
import '../nucleus_one_sdk_service.dart';
import '../path_validator.dart';

enum ExportFailure {
  orgIdInvalid,
  projectIdInvalid,
  destinationInvalid,
  destinationNotEmpty,
  maxConcurrentDownloadsInvalid,
  unknownError,
}

enum _DownloadFailureType {
  unknownError,
}

class _DownloadFailure {
  _DownloadFailure(this.failure, this.results);

  final _DownloadFailureType failure;
  final ExportResults results;
}

class ExportResults {
  ExportResults._(this.started);

  final DateTime started;
  DateTime? _finished;
  int _totalExported = 0;
  int _savedAsCopy = 0;
  int _skippedAlreadyExists = 0;
  int _skippedFailed = 0;

  int get totalExported => _totalExported;
  int get savedAsCopy => _savedAsCopy;
  int get skippedAlreadyExists => _skippedAlreadyExists;
  int get skippedFailed => _skippedFailed;
  DateTime? get finished => _finished;
  Duration? get elapsed => _finished?.difference(started).abs();

  void _incrementTotalExported() => _totalExported += 1;
  void _incrementSavedAsCopy() => _savedAsCopy += 1;
  void _incrementSkippedAlreadyExists() => _skippedAlreadyExists += 1;
  void _incrementSkippedFailed() => _skippedFailed += 1;
  void _setFinished() => _finished = DateTime.now();
}

class ExportService {
  ExportService({NucleusOneSdkService? n1Sdk, PathValidator? pathValidator})
      : _n1Sdk = n1Sdk ?? GetIt.I<NucleusOneSdkService>(),
        _pathValidator = pathValidator ?? GetIt.I<PathValidator>();

  final NucleusOneSdkService _n1Sdk;
  final PathValidator _pathValidator;
  final http.Client _httpClient = http.Client();

  Future<Either<List<ExportFailure>, ExportResults>> exportDocuments({
    required String orgId,
    required String projectId,
    required String destination,
    int maxConcurrentDownloads = 4,
    bool copyIfExists = false,
    bool allowNonEmptyDestination = false,
  }) async {
    final results = ExportResults._(DateTime.now());

    final validated = _Validated.validate(
        orgId: orgId,
        projectId: projectId,
        destination: destination,
        maxConcurrentDownloads: maxConcurrentDownloads,
        copyIfExists: copyIfExists,
        allowNonEmptyDestination: allowNonEmptyDestination,
        pathValidator: _pathValidator);

    return validated
        .toTaskEither()
        .flatMap((v) => _checkNonEmptyDest(v)
            .flatMap((v) => _exportDocuments(v, results))
            .mapLeft((l) => [l]))
        .map(_setFinished)
        .run()
        .whenComplete(() => _httpClient.close());
  }

  TaskEither<ExportFailure, ExportResults> _exportDocuments(
      _Validated validated, final ExportResults results) {
    return TaskEither.tryCatch(() async {
      var innerResults = results;
      final docStream = _getDocumentsStream(validated);
      final exportResults =
          _exportDocumentsFromStream(docStream, validated, innerResults)
              .fold<Either<_DownloadFailure, ExportResults>>(
                  right(results), (acc, result) => acc.flatMap((_) => result));
      await exportResults.map((r) => innerResults = r);
      return innerResults;
    }, (error, stackTrace) => tryCast(error, ExportFailure.unknownError));
  }

  Stream<Either<_DownloadFailure, ExportResults>> _exportDocumentsFromStream(
      Stream<n1.Document> docStream,
      _Validated validated,
      final ExportResults results) {
    return docStream.flatMap(maxConcurrent: validated.maxConcurrentDownloads,
        (doc) async* {
      yield (await _exportDocument(doc, validated, results).run());
    });
  }

  Stream<n1.Document> _getDocumentsStream(_Validated validated) async* {
    final v = validated;
    var didReturnItems = false;
    String? cursor;
    do {
      final qrDocs = await _n1Sdk.getDocuments(
          orgId: v.orgId, projectId: v.projectId, cursor: cursor);
      cursor = qrDocs.cursor;
      didReturnItems = qrDocs.results.items.isNotEmpty;
      yield* Stream.fromIterable(qrDocs.results.items);
    } while (didReturnItems);
  }

  TaskEither<_DownloadFailure, ExportResults> _exportDocument(
      n1.Document doc, _Validated validated, ExportResults results) {
    return TaskEither.tryCatch(() async {
      // Make path
      var outFilepath = _makeSafeFilepath(doc, validated.destination);
      var renamed = false;
      if (File(outFilepath).existsSync()) {
        if (validated.copyIfExists) {
          outFilepath = _makeAlternativeFilepathIfExists(outFilepath);
          renamed = true;
        } else {
          results._incrementSkippedAlreadyExists();
          return results;
        }
      }

      // Download document
      final dcp = await _n1Sdk.getDocumentContentPackage(doc);
      await _downloadDoc(url: dcp.url, destinationFilepath: outFilepath);

      if (renamed) {
        results._incrementSavedAsCopy();
      }
      results._incrementTotalExported();
      return results;
    }, (error, stackTrace) {
      results._incrementSkippedFailed();
      return _DownloadFailure(_DownloadFailureType.unknownError, results);
    });
  }

  Future<void> _downloadDoc(
      {required String url, required String destinationFilepath}) async {
    return Future.sync(() async {
      final file = File(destinationFilepath);
      await file.parent.create(recursive: true);
      final request = http.Request('get', Uri.parse(url));
      final response = await _httpClient.send(request);
      await for (final b in response.stream) {
        await file.writeAsBytes(b, mode: FileMode.writeOnlyAppend);
      }
    });
  }

  TaskEither<ExportFailure, _Validated> _checkNonEmptyDest(
      _Validated validated) {
    return TaskEither.tryCatch(() async {
      if (!validated.allowNonEmptyDestination &&
          validated.destination.existsSync() &&
          (!(await validated.destination.list().isEmpty))) {
        throw Exception();
      }
      return validated;
    }, (error, stackTrace) => ExportFailure.destinationNotEmpty);
  }

  String _makeSafeFilepath(n1.Document doc, Directory destination) {
    String docPath = doc.documentFolderPath;
    if (docPath.startsWith(RegExp(r'[/\\]'))) {
      docPath = docPath.substring(1);
    }

    final folders = path_.split(docPath);
    final safeFolders = folders.map(_pathValidator.makeSafeFoldername);
    final safeFilename = _pathValidator.makeSafeFilename(doc.name);
    return path_.joinAll([destination.path, ...safeFolders, safeFilename]);
  }

  String _makeAlternativeFilepathIfExists(String filepath) {
    var f = File(filepath);
    var i = 0;
    while (f.existsSync()) {
      i++;
      String suffix;
      if (i == 1) {
        suffix = ' - Copy';
      } else {
        suffix = ' - Copy ($i)';
      }
      final pwoe = path_.withoutExtension(filepath);
      final ext = path_.extension(filepath);
      f = File('$pwoe$suffix$ext');
    }
    return f.path;
  }

  ExportResults _setFinished(ExportResults results) {
    results._setFinished();
    return results;
  }
}

class _Validated {
  _Validated._({
    required this.orgId,
    required this.projectId,
    required this.destination,
    required this.maxConcurrentDownloads,
    required this.copyIfExists,
    required this.allowNonEmptyDestination,
    required this.pathValidator,
  });

  static Either<List<ExportFailure>, _Validated> validate({
    required String orgId,
    required String projectId,
    required String destination,
    required int maxConcurrentDownloads,
    required bool copyIfExists,
    required bool allowNonEmptyDestination,
    required PathValidator pathValidator,
  }) {
    final failures = <ExportFailure>[];
    if (orgId.isEmpty) {
      failures.add(ExportFailure.orgIdInvalid);
    }
    if (projectId.isEmpty) {
      failures.add(ExportFailure.projectIdInvalid);
    }
    if (destination.isEmpty) {
      failures.add(ExportFailure.destinationInvalid);
    }
    if (maxConcurrentDownloads < 1) {
      failures.add(ExportFailure.maxConcurrentDownloadsInvalid);
    }

    // ignore: parameter_assignments
    destination = path_.canonicalize(destination);
    if (!pathValidator.isValid(destination, PathType.absoluteFolderpath)) {
      failures.add(ExportFailure.destinationInvalid);
    }

    if (failures.isNotEmpty) {
      return left(failures);
    } else {
      return right(_Validated._(
          orgId: orgId,
          projectId: projectId,
          destination: Directory(destination),
          maxConcurrentDownloads: maxConcurrentDownloads,
          copyIfExists: copyIfExists,
          allowNonEmptyDestination: allowNonEmptyDestination,
          pathValidator: pathValidator));
    }
  }

  final String orgId;
  final String projectId;
  final Directory destination;
  final int maxConcurrentDownloads;
  final bool copyIfExists;
  final bool allowNonEmptyDestination;
  final PathValidator pathValidator;
}
