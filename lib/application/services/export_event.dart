import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'export_results.dart';
import 'export_service.dart';

part 'export_event.freezed.dart';

@freezed
class ExportEvent with _$ExportEvent {
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

  const factory ExportEvent.exportFinished({
    required Either<List<ExportFailure>, ExportResults> results,
  }) = ExportFinished;
}
