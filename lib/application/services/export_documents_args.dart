import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as path_;

import '../exceptions.dart';
import '../path_validator.dart';
part 'export_documents_args.freezed.dart';

enum ExportDocumentsArgsValidationFailure {
  orgIdMissing,
  projectIdMissing,
  destinationMissing,
  destinationInvalid,
  destinationNotEmpty,
  maxDownloadsInvalid,
  unknownFailure,
}

@freezed
class ExportDocumentsArgs with _$ExportDocumentsArgs {
  factory ExportDocumentsArgs({
    required String orgId,
    required String projectId,
    required String destination,
    required bool allowNonEmptyDestination,
    required bool copyIfExists,
    required String maxConcurrentDownloads,
  }) = _ExportDocumentsArgs;

  const ExportDocumentsArgs._();

  TaskEither<List<ExportDocumentsArgsValidationFailure>,
      ValidatedExportDocumentsArgs> validate(
    PathValidator pathValidator,
  ) {
    return TaskEither.tryCatch(() async {
      final failures = <ExportDocumentsArgsValidationFailure>[];
      if (orgId.isEmpty) {
        failures.add(ExportDocumentsArgsValidationFailure.orgIdMissing);
      }
      if (projectId.isEmpty) {
        failures.add(ExportDocumentsArgsValidationFailure.projectIdMissing);
      }
      if (destination.isEmpty) {
        failures.add(ExportDocumentsArgsValidationFailure.destinationMissing);
      }
      final maxDownloads = int.tryParse(maxConcurrentDownloads) ?? 0;
      if (maxDownloads < 1) {
        failures.add(ExportDocumentsArgsValidationFailure.maxDownloadsInvalid);
      }

      Directory? destDir;
      if (destination.isNotEmpty) {
        final destCanonical = path_.canonicalize(destination);
        if (!pathValidator.isValid(
            destCanonical, PathType.absoluteFolderpath)) {
          failures.add(ExportDocumentsArgsValidationFailure.destinationInvalid);
        } else {
          destDir = Directory(destCanonical);
          if (!allowNonEmptyDestination &&
              destDir.existsSync() &&
              (!(await destDir.list().isEmpty))) {
            failures
                .add(ExportDocumentsArgsValidationFailure.destinationNotEmpty);
          }
        }
      }

      if (failures.isNotEmpty) {
        throw LeftException(failures);
      }
      return ValidatedExportDocumentsArgs._internal(
        orgId: orgId,
        projectId: projectId,
        destination: destDir!,
        allowNonEmptyDestination: allowNonEmptyDestination,
        copyIfExists: copyIfExists,
        maxConcurrentDownloads: maxDownloads,
        originalArgs: this,
      );
    }, (error, stackTrace) {
      if (error is LeftException<List<ExportDocumentsArgsValidationFailure>>) {
        return error.failure;
      }
      return [ExportDocumentsArgsValidationFailure.unknownFailure];
    });
  }
}

@freezed
class ValidatedExportDocumentsArgs with _$ValidatedExportDocumentsArgs {
  factory ValidatedExportDocumentsArgs._internal({
    required String orgId,
    required String projectId,
    required Directory destination,
    required bool allowNonEmptyDestination,
    required bool copyIfExists,
    required int maxConcurrentDownloads,
    required ExportDocumentsArgs originalArgs,
  }) = _ValidatedExportDocumentsArgs;
}
