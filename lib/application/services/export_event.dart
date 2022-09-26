import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'export_results.dart';
import 'export_service.dart';

part 'export_event.freezed.dart';

@freezed
class ExportEvent with _$ExportEvent {
  const ExportEvent._();

  const factory ExportEvent.beginExport({
    required String orgId,
    required String orgName,
    required String projectId,
    required String projectName,
    required String localPath,
    required int docCount,
  }) = BeginExport;

  const factory ExportEvent.docExportAttempt({
    required String docId,
    required String n1Path,
  }) = DocExportAttempt;

  const factory ExportEvent.docExported({
    required String docId,
    required String n1Path,
    required String localPath,
    required bool exportedAsCopy,
  }) = DocExported;

  const factory ExportEvent.docSkippedAlreadyExists({
    required String docId,
    required String n1Path,
    required String localPath,
  }) = DocSkippedAlreadyExists;

  const factory ExportEvent.docSkippedUnknownFailure({
    required String docId,
    required String n1Path,
  }) = DocSkippedUnknownFailure;

  const factory ExportEvent.cancelExportRequested() = CancelExportRequested;

  const factory ExportEvent.exportFinished({
    required Either<List<ExportFailure>, ExportResults> results,
    required bool canceledBeforeComplete,
  }) = ExportFinished;

  String getLogMessage() {
    const prefixExported = '[Exported] ';
    const prefixAsCopy = '[Exported As Copy] ';
    const prefixExists = '[Skipped (Already Exists)] ';
    const prefixFailure = '[Skipped (Unknown Failure)] ';

    return maybeWhen(
      orElse: () {
        assert(false, 'This event is not reported.');
        return '';
      },
      docExported: (docId, n1Path, localPath, exportedAsCopy) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
            'Local Path: "$localPath"';
        if (exportedAsCopy) {
          return '$prefixAsCopy$msg';
        } else {
          return '$prefixExported$msg';
        }
      },
      docSkippedAlreadyExists: (docId, n1Path, localPath) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
            'Local Path: "$localPath"';
        return '$prefixExists$msg';
      },
      docSkippedUnknownFailure: (docId, n1Path) {
        final msg = 'Document ID: "$docId", N1 Path: "$n1Path"';
        return '$prefixFailure$msg';
      },
    );
  }
}
