import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:path/path.dart' as path_;
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../util/runtime_helper.dart';
import '../nucleus_one_sdk_service.dart';
import '../path_validator.dart';
import '../providers.dart';
import 'export_documents_args.dart';
import 'export_event.dart';
import 'export_results.dart';

enum ExportFailure {
  orgIdInvalid,
  projectIdInvalid,
  destinationInvalid,
  destinationNotEmpty,
  maxConcurrentDownloadsInvalid,
  unknownFailure,
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
  ExportService(
      {Future<NucleusOneSdkService>? n1SdkSvc, PathValidator? pathValidator})
      : _n1SdkSvc = n1SdkSvc ??
            GetIt.I<ProviderContainer>()
                .read(nucleusOneSdkServiceProvider.future),
        _pathValidator = pathValidator ??
            GetIt.I<ProviderContainer>().read(pathValidatorProvider);

  final Future<NucleusOneSdkService> _n1SdkSvc;
  final PathValidator _pathValidator;

  http.Client? _httpClient;
  var _cancelExportRequested = false;
  var _canceledBeforeComplete = false;

  Stream<ExportEvent> exportDocuments(
    ValidatedExportDocumentsArgs validArgs,
  ) {
    final results = ExportResults(DateTime.now());
    final exportEventStreamController = StreamController<ExportEvent>();
    final streamSink = exportEventStreamController.sink;
    _httpClient = http.Client();
    _cancelExportRequested = false;
    _canceledBeforeComplete = false;

    unawaited(_exportDocuments(validArgs, streamSink, results)
        .mapLeft((l) => [l])
        .map((r) => r.setFinished())
        .bimap(
          (l) {
            streamSink.add(ExportEvent.exportFinished(
              results: left(l),
              canceledBeforeComplete: _canceledBeforeComplete,
            ));
          },
          (r) {
            streamSink.add(ExportEvent.exportFinished(
              results: right(r),
              canceledBeforeComplete: _canceledBeforeComplete,
            ));
          },
        )
        .run()
        .whenComplete(() async {
          _httpClient?.close();
          await exportEventStreamController.close();
        }));

    return exportEventStreamController.stream;
  }

  /// The export may finish before cancel completes.
  void cancelExport() {
    _cancelExportRequested = true;
  }

  TaskEither<ExportFailure, ExportResults> _exportDocuments(
    ValidatedExportDocumentsArgs validArgs,
    StreamSink<ExportEvent> streamSink,
    final ExportResults results,
  ) {
    final v = validArgs;
    return TaskEither.tryCatch(() async {
      // Send BeginExport event.
      final n1SdkSvc = await _n1SdkSvc;
      final org = await n1SdkSvc.getUserOrganization(organizationId: v.orgId);
      // final project = await n1SdkSvc.getUserProject(
      //     organizationId: v.orgId, projectId: v.projectId);
      final project = await n1SdkSvc.getOrganizationProject(
          organizationId: v.orgId, projectId: v.projectId);
      final docCount = await n1SdkSvc.getDocumentCount(
          organizationId: v.orgId,
          projectId: v.projectId,
          ignoreInbox: true,
          ignoreRecycleBin: true);
      streamSink.add(ExportEvent.beginExport(
          orgId: v.orgId,
          orgName: org.organizationName,
          projectId: v.projectId,
          projectName: project.name,
          docCount: docCount,
          localPath: v.destination.path));

      // Get document stream and do the export.
      final docStream = _getDocumentsStream(validArgs);
      final exportResults =
          await _exportDocumentsFromStream(docStream, validArgs, streamSink)
              .fold<Either<_DownloadFailure, ExportResults>>(
        right(results),
        // Ignore individual export failures for now until we handle
        // retries and timeouts and such.
        (acc, docResult) => acc.map(
          (accResults) => docResult.fold(
            (drL) {
              streamSink.add(ExportEvent.docSkippedUnknownFailure(
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
    }, (error, stackTrace) => tryCast(error, ExportFailure.unknownFailure));
  }

  Stream<Either<_DownloadFailure, ExportResults>> _exportDocumentsFromStream(
    Stream<n1.Document> docStream,
    ValidatedExportDocumentsArgs validArgs,
    StreamSink<ExportEvent> streamSink,
  ) {
    return docStream.flatMap(
      maxConcurrent: validArgs.maxConcurrentDownloads,
      (doc) async* {
        if (_cancelExportRequested) {
          _canceledBeforeComplete = true;
          return;
        }
        streamSink.add(ExportEvent.docExportAttempt(
          docId: doc.documentID,
          n1Path: _getNormalizedN1Path(doc),
        ));
        yield (await _exportDocument(doc, validArgs, streamSink).run());
      },
    );
  }

  Stream<n1.Document> _getDocumentsStream(
      ValidatedExportDocumentsArgs validArgs) async* {
    final v = validArgs;
    var didReturnItems = false;
    String? cursor;
    do {
      if (_cancelExportRequested) {
        _canceledBeforeComplete = true;
        return;
      }
      final n1SdkSvc = await _n1SdkSvc;
      final qrDocs = await n1SdkSvc.getDocuments(
          orgId: v.orgId, projectId: v.projectId, cursor: cursor);
      cursor = qrDocs.cursor;
      didReturnItems = qrDocs.results.items.isNotEmpty;
      yield* Stream.fromIterable(qrDocs.results.items);
    } while (didReturnItems);
  }

  TaskEither<_DownloadFailure, ExportResults> _exportDocument(
    n1.Document doc,
    ValidatedExportDocumentsArgs validArgs,
    StreamSink<ExportEvent> streamSink,
  ) {
    final results = ExportResults(DateTime.now());
    File? outFile;
    return TaskEither.tryCatch(() async {
      // Make path.
      var outFilepath = _makeSafeFilepath(doc, validArgs.destination);
      var renamed = false;
      if (File(outFilepath).existsSync()) {
        if (validArgs.copyIfExists) {
          outFilepath = _makeAlternativeFilepathIfExists(outFilepath);
          renamed = true;
        } else {
          streamSink.add(ExportEvent.docSkippedAlreadyExists(
            docId: doc.documentID,
            n1Path: _getNormalizedN1Path(doc),
            localPath:
                path_.relative(outFilepath, from: validArgs.destination.path),
          ));
          return results.docSkippedAlreadyExists();
        }
      }

      // Before any async calls, reserve filename by creating it.
      outFile = File(outFilepath);
      outFile!.createSync(recursive: true);

      // Download document.
      final n1SdkSvc = await _n1SdkSvc;
      final dcp = await n1SdkSvc.getDocumentContentPackage(doc);
      await _downloadDoc(url: dcp.url, destinationFile: outFile!);

      // Build export results and export event.
      ExportResults exportResults;
      if (renamed) {
        exportResults = results.docExportedAsCopy();
      } else {
        exportResults = results.docExported();
      }
      streamSink.add(ExportEvent.docExported(
        docId: doc.documentID,
        n1Path: _getNormalizedN1Path(doc),
        localPath:
            path_.relative(outFile!.path, from: validArgs.destination.path),
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
        } on Exception {/* well, we tried... */}
      }
      return _DownloadFailure(_DownloadFailureType.unknownError, doc,
          results.docSkippedUnknownFailure());
    });
  }

  Future<void> _downloadDoc(
      {required String url, required File destinationFile}) async {
    return Future.sync(() async {
      final request = http.Request('get', Uri.parse(url));
      final response = await _httpClient!.send(request);
      await for (final b in response.stream) {
        await destinationFile.writeAsBytes(b, mode: FileMode.writeOnlyAppend);
      }
    });
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
}
