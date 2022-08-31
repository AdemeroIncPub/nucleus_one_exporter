import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:path/path.dart' as path_;
import 'package:rxdart/rxdart.dart';

import '../../util/runtime_helper.dart';
import '../nucleus_one_sdk_service.dart';
import '../path_validator.dart';
import 'export_event.dart';
import 'export_results.dart';

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

@immutable
class _DownloadFailure {
  const _DownloadFailure(this.failure, this.doc, this.results);

  final _DownloadFailureType failure;
  final n1.Document doc;
  final ExportResults results;
}

class ExportService {
  ExportService({NucleusOneSdkService? n1Sdk, PathValidator? pathValidator})
      : _n1Sdk = n1Sdk ?? GetIt.I<NucleusOneSdkService>(),
        _pathValidator = pathValidator ?? GetIt.I<PathValidator>(),
        _exportEventStreamController = StreamController<ExportEvent>();

  final NucleusOneSdkService _n1Sdk;
  final PathValidator _pathValidator;
  final StreamController<ExportEvent> _exportEventStreamController;
  final http.Client _httpClient = http.Client();

  Stream<ExportEvent> get exportEventStream =>
      _exportEventStreamController.stream;

  Future<Either<List<ExportFailure>, ExportResults>> exportDocuments({
    required String orgId,
    required String projectId,
    required String destination,
    int maxConcurrentDownloads = 4,
    bool copyIfExists = false,
    bool allowNonEmptyDestination = false,
  }) async {
    final results = ExportResults(DateTime.now());

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
        .map((r) => r.setFinished())
        .run()
        .whenComplete(() => _httpClient.close());
  }

  TaskEither<ExportFailure, ExportResults> _exportDocuments(
      _Validated validated, final ExportResults results) {
    final v = validated;
    return TaskEither.tryCatch(() async {
      // Send BeginExport event.
      final org = await _n1Sdk.getUserOrganization(organizationId: v.orgId);
      final project = await _n1Sdk.getProject(
          organizationId: v.orgId, projectId: v.projectId);
      final docCount = await _n1Sdk.getDocumentCount(
          organizationId: v.orgId,
          projectId: v.projectId,
          ignoreInbox: true,
          ignoreRecycleBin: true);
      _addExportEvent(ExportEvent.beginExport(
          orgId: v.orgId,
          orgName: org.organizationName,
          projectId: v.projectId,
          projectName: project.name,
          docCount: docCount,
          localPath: v.destination.path));

      // Get document stream and do the export.
      final docStream = _getDocumentsStream(validated);
      final exportResults =
          await _exportDocumentsFromStream(docStream, validated)
              .fold<Either<_DownloadFailure, ExportResults>>(
        right(results),
        // Ignore individual export failures for now until we handle
        // retries and timeouts and such.
        (acc, docResult) => acc.map(
          (accResults) => docResult.fold(
            (drL) {
              _addExportEvent(ExportEvent.docSkippedUnknownFailure(
                docId: drL.doc.documentID,
                n1Path: _getNormalizedN1Path(drL.doc),
              ));
              return accResults.add(drL.results);
            },
            (drR) => accResults.add(drR),
          ),
        ),
      );
      return exportResults.fold((l) => l.results, id);
    }, (error, stackTrace) => tryCast(error, ExportFailure.unknownError));
  }

  Stream<Either<_DownloadFailure, ExportResults>> _exportDocumentsFromStream(
      Stream<n1.Document> docStream, _Validated validated) {
    return docStream.flatMap(maxConcurrent: validated.maxConcurrentDownloads,
        (doc) async* {
      _addExportEvent(ExportEvent.docExportAttempt(
        docId: doc.documentID,
        n1Path: _getNormalizedN1Path(doc),
      ));
      yield (await _exportDocument(doc, validated).run());
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
      n1.Document doc, _Validated validated) {
    final results = ExportResults(DateTime.now());
    File? outFile;
    return TaskEither.tryCatch(() async {
      // Make path.
      var outFilepath = _makeSafeFilepath(doc, validated.destination);
      var renamed = false;
      if (File(outFilepath).existsSync()) {
        if (validated.copyIfExists) {
          outFilepath = _makeAlternativeFilepathIfExists(outFilepath);
          renamed = true;
        } else {
          _addExportEvent(ExportEvent.docSkippedAlreadyExists(
            docId: doc.documentID,
            n1Path: _getNormalizedN1Path(doc),
            localPath:
                path_.relative(outFilepath, from: validated.destination.path),
          ));
          return results.docSkippedAlreadyExists();
        }
      }

      // Before any async calls, reserve filename by creating it.
      outFile = File(outFilepath);
      outFile!.createSync(recursive: true);

      // Download document.
      final dcp = await _n1Sdk.getDocumentContentPackage(doc);
      await _downloadDoc(url: dcp.url, destinationFile: outFile!);

      // Build export results and export event.
      ExportResults exportResults;
      if (renamed) {
        exportResults = results.docExportedAsCopy();
      } else {
        exportResults = results.docExported();
      }
      _addExportEvent(ExportEvent.docExported(
        docId: doc.documentID,
        n1Path: _getNormalizedN1Path(doc),
        localPath:
            path_.relative(outFile!.path, from: validated.destination.path),
        exportedAsCopy: renamed,
      ));
      return exportResults;
    }, (error, stackTrace) {
      // If download failed then delete the reserved file. This should be only
      // files we created, but check for zero length in case of bug. (This also
      // means incomplete download failures will not be deleted).
      if (outFile != null && outFile!.statSync().size == 0) {
        try {
          outFile!.deleteSync();
        } catch (ex) {/* well, we tried... */}
      }
      return _DownloadFailure(_DownloadFailureType.unknownError, doc,
          results.docSkippedUnknownFailure());
    });
  }

  Future<void> _downloadDoc(
      {required String url, required File destinationFile}) async {
    return Future.sync(() async {
      final request = http.Request('get', Uri.parse(url));
      final response = await _httpClient.send(request);
      await for (final b in response.stream) {
        await destinationFile.writeAsBytes(b, mode: FileMode.writeOnlyAppend);
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

  String _getNormalizedN1Path(n1.Document doc) =>
      path_.normalize(path_.join(doc.documentFolderPath, doc.name));

  void _addExportEvent(ExportEvent event) {
    final sc = _exportEventStreamController;
    if (!sc.isClosed && !sc.isPaused && sc.hasListener) {
      _exportEventStreamController.add(event);
    }
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
