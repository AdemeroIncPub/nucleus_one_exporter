// ignore_for_file: non_constant_identifier_names

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/export_service.dart';
import '../../runtime_helper.dart';
import '../../util/extensions.dart';
import '../cli.dart';

class ExportCommand extends Command<void> {
  ExportCommand({ExportService? exportService})
      : _exportService = exportService ?? GetIt.I<ExportService>() {
    argParser.addOption(
      _option_orgId,
      help: 'Organization ID (required)',
      abbr: 'o',
      valueHelp: 'id',
    );
    argParser.addOption(
      _option_projectId,
      help: 'Project ID (required)',
      abbr: 'p',
      valueHelp: 'id',
    );
    argParser.addOption(
      _option_destination,
      help: 'Relative or absolute path to create documents. (required)',
      abbr: 'd',
      valueHelp: 'local path',
    );
    argParser.addFlag(
      _flag_overwrite,
      help: 'Overwrite existing documents.',
    );
    argParser.addFlag(
      _flag_allowNonemptyDestination,
      help: 'If the specified path contains files or folder, export anyway.',
    );
  }

  static final _option_orgId = 'organization-id';
  static final _option_projectId = 'project-id';
  static final _option_destination = 'destination';
  static final _flag_overwrite = 'overwrite';
  static final _flag_allowNonemptyDestination = 'allow-nonempty-destination';

  final ExportService _exportService;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'export';

  @override
  String get description =>
      'Export your Nucleus One documents to a local path.';

  @override
  Future<void> run() async {
    final args = argResults!;

    await _validate(args)
        .flatMapFuture((_) => _exportDocuments(args))
        .bimap(
          (err) => usageException(err.join('\n')),
          (r) => print('Total Exported: ${r.totalExported}\n'
              'savedAsCopy: ${r.savedAsCopy}\n'
              'skippedAlreadyExists: ${r.skippedAlreadyExists}\n'
              'skippedFailed: ${r.skippedFailed}\n'
              'elapsed: ${r.elapsed.toString()}'),
        )
        .run();
  }

  Either<List<String>, Unit> _validate(ArgResults results) {
    final issues = <String>[];
    if (!results.wasParsed(_option_orgId)) {
      issues.add('The $_option_orgId option is required.');
    }
    if (!results.wasParsed(_option_projectId)) {
      issues.add('The $_option_projectId option is required.');
    }
    if (!results.wasParsed(_option_destination)) {
      issues.add('The $_option_destination option is required.');
    }

    if (issues.isNotEmpty) {
      return left(issues);
    }
    return right(unit);
  }

  Future<Either<List<String>, ExportResults>> _exportDocuments(
      ArgResults args) async {
    return _exportService
        .exportDocuments(
          orgId: tryCast(args[_option_orgId], ''),
          projectId: tryCast(args[_option_projectId], ''),
          destination: tryCast(args[_option_destination], ''),
          overwrite: args[_flag_overwrite] as bool,
          allowNonEmptyDestination:
              args[_flag_allowNonemptyDestination] as bool,
        )
        .mapLeft(_mapExportFailures2Messages);
  }

  List<String> _mapExportFailures2Messages(List<ExportFailure> err) {
    return err.map((e) {
      switch (e) {
        case ExportFailure.orgIdInvalid:
          return 'The $_option_orgId path is invalid.';
        case ExportFailure.projectIdInvalid:
          return 'The $_option_projectId path is invalid.';
        case ExportFailure.destinationInvalid:
          return 'The $_option_destination path is invalid.';
        case ExportFailure.destinationNotEmpty:
          return 'The destination folder already exists and is not empty.'
              ' Use flag $_flag_allowNonemptyDestination to export anyway.';
        case ExportFailure.unknownError:
          return 'An unknown error has ocurred.';
      }
    }).toList();
  }
}
