import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path_;

import '../nucleus_one_sdk_service.dart';
import '../path_validator.dart';

enum ExportFailure {
  orgIdInvalid,
  projectIdInvalid,
  destinationInvalid,
  destinationNotEmpty,
}

class ExportService {
  ExportService({NucleusOneSdkService? n1Sdk, PathValidator? pathValidator})
      : _n1Sdk = n1Sdk ?? GetIt.I<NucleusOneSdkService>(),
        _pathValidator = pathValidator ?? GetIt.I<PathValidator>();

  final NucleusOneSdkService _n1Sdk;
  final PathValidator _pathValidator;

  Either<List<ExportFailure>, Unit> exportDocuments({
    required String orgId,
    required String projectId,
    required String destination,
    bool overwrite = false,
    bool allowNonEmptyDestination = false,
  }) {
    final validated = _Validated.validate(
        orgId: orgId,
        projectId: projectId,
        destination: destination,
        overwrite: overwrite,
        allowNonEmptyDestination: allowNonEmptyDestination,
        pathValidator: _pathValidator);

    final destDir = Directory(destination);

    return validated.flatMap((v) =>
        _checkNonEmptyDest(destDir, v.allowNonEmptyDestination)
            .leftMap((l) => [l]));
  }

  Either<ExportFailure, Unit> _checkNonEmptyDest(
      Directory destination, bool allowNonEmptyDestination) {
    if (!allowNonEmptyDestination &&
        destination.existsSync() &&
        destination.listSync().isNotEmpty) {
      return Left(ExportFailure.destinationNotEmpty);
    }
    return Right(unit);
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
      return Left(failures);
    } else {
      return Right(_Validated._(
          orgId: orgId,
          projectId: projectId,
          destination: destination,
          overwrite: overwrite,
          allowNonEmptyDestination: allowNonEmptyDestination,
          pathValidator: pathValidator));
    }
  }

  final String orgId;
  final String projectId;
  final String destination;
  final bool overwrite;
  final bool allowNonEmptyDestination;
  final PathValidator pathValidator;
}
