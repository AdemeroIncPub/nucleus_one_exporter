import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:path/path.dart' as path_;

import '../../util/extensions.dart';
import '../nucleus_one_sdk_service.dart';
import '../path_validator.dart';

enum ExportFailure {
  orgIdInvalid,
  projectIdInvalid,
  destinationInvalid,
  destinationNotEmpty,
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
    bool overwrite = false,
    bool allowNonEmptyDestination = false,
  }) async {
    final validated = _Validated.validate(
        orgId: orgId,
        projectId: projectId,
        destination: destination,
        overwrite: overwrite,
        allowNonEmptyDestination: allowNonEmptyDestination,
        pathValidator: _pathValidator);

    final results = ExportResults._(DateTime.now());

    return validated
        .flatMapFuture((v) => _exportDocuments(v, results).leftMap((l) => [l]))
        .whenComplete(() => _httpClient.close());
  }

  Future<Either<ExportFailure, ExportResults>> _exportDocuments(
      _Validated validated, final ExportResults results) {
    Future<Either<ExportFailure, ExportResults>>
        exportDocumentsByPaging() async {
      final v = validated;
      var innerResults = results;
      var didReturnItems = false;
      String? cursor;
      do {
        final qrDocs = await _n1Sdk.getDocuments(
            orgId: v.orgId, projectId: v.projectId, cursor: cursor);
        cursor = qrDocs.cursor;
        didReturnItems = qrDocs.results.items.isNotEmpty;
        final exportResults = await qrDocs.results.items
            .fold<Future<Either<ExportFailure, ExportResults>>>(
          Future.value(right(innerResults)),
          (previous, doc) => previous.flatMapFuture((r) {
            return _exportDocument(doc, v, r).catchError((err) {
              innerResults._incrementSkippedFailed();
              return right<ExportFailure, ExportResults>(innerResults);
            });
          }),
        );
        exportResults.map((r) => innerResults = r);
      } while (didReturnItems);

      return right(innerResults);
    }

    return _checkNonEmptyDest(validated)
        .flatMapFuture((_) => exportDocumentsByPaging())
        .map((r) {
      r._setFinished();
      return r;
    });
  }

  Future<Either<ExportFailure, ExportResults>> _exportDocument(
      n1.Document doc, _Validated validated, ExportResults results) async {
    // Make path
    var outFilepath = _makeSafeFilepath(doc, validated.destination);
    var renamed = false;
    if (File(outFilepath).existsSync()) {
      if (validated.overwrite) {
        outFilepath = _makeAlternativeFilepathIfExists(outFilepath);
        renamed = true;
      } else {
        results._incrementSkippedAlreadyExists();
        return right(results);
      }
    }

    // Download document
    final dcp = await _n1Sdk.getDocumentContentPackage(doc);
    await _downloadDoc(url: dcp.url, destinationFilepath: outFilepath);

    if (renamed) {
      results._incrementSavedAsCopy();
    }
    results._incrementTotalExported();
    return right(results);
  }

  Future<void> _downloadDoc(
      {required String url, required String destinationFilepath}) async {
    return Future.sync(() async {
      IOSink? sink;
      try {
        final file = File(destinationFilepath);
        await file.parent.create(recursive: true);
        sink = file.openWrite(mode: FileMode.writeOnly);
        final request = http.Request('get', Uri.parse(url));
        final response = await _httpClient.send(request);
        await response.stream.pipe(sink);
        await sink.flush();
      } finally {
        await sink?.close();
      }
    });
  }

  Future<Either<ExportFailure, _Validated>> _checkNonEmptyDest(
      _Validated validated) async {
    if (!validated.allowNonEmptyDestination &&
        validated.destination.existsSync() &&
        // validated.destination.listSync().isNotEmpty) {
        (!(await validated.destination.list().isEmpty))) {
      return left(ExportFailure.destinationNotEmpty);
    }
    return right(validated);
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
}

class _Validated {
  _Validated._({
    required this.orgId,
    required this.projectId,
    required this.destination,
    required this.overwrite,
    required this.allowNonEmptyDestination,
    required this.pathValidator,
  });

  static Either<List<ExportFailure>, _Validated> validate({
    required String orgId,
    required String projectId,
    required String destination,
    required bool overwrite,
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
          overwrite: overwrite,
          allowNonEmptyDestination: allowNonEmptyDestination,
          pathValidator: pathValidator));
    }
  }

  final String orgId;
  final String projectId;
  final Directory destination;
  final bool overwrite;
  final bool allowNonEmptyDestination;
  final PathValidator pathValidator;
}
