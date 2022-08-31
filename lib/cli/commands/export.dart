// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/export_event.dart';
import '../../application/services/export_results.dart';
import '../../application/services/export_service.dart';
import '../../runtime_helper.dart';
import '../../util/extensions.dart';
import '../cli.dart';

class ExportCommand extends Command<void> {
  ExportCommand({ExportService? exportService})
      : _exportService = exportService ?? GetIt.I<ExportService>() {
    argParser.addOption(
      _option_orgId,
      help: 'Organization ID. (required)',
      abbr: 'o',
      valueHelp: 'id',
    );
    argParser.addOption(
      _option_projectId,
      help: 'Project ID. (required)',
      abbr: 'p',
      valueHelp: 'id',
    );
    argParser.addOption(
      _option_destination,
      help: 'Relative or absolute path to create documents. (required)',
      abbr: 'd',
      valueHelp: 'local path',
    );
    argParser.addOption(
      _option_maxConcurrentDownloads,
      help: 'Maximum number of documents to download simultaneously.',
      abbr: 'c',
      valueHelp: 'max',
      defaultsTo: '4',
    );
    argParser.addFlag(
      _flag_copyIfExists,
      help: 'Create a copy if the file already exists.',
    );
    argParser.addFlag(
      _flag_allowNonemptyDestination,
      help: 'If the specified path contains files or folders, export anyway.',
    );
    argParser.addFlag(
      _flag_verbose,
      help: 'Enabled detailed output.',
      abbr: 'v',
      negatable: false,
    );
  }

  static const _option_orgId = 'organization-id';
  static const _option_projectId = 'project-id';
  static const _option_destination = 'destination';
  static const _flag_copyIfExists = 'copy-if-exists';
  static const _flag_allowNonemptyDestination = 'allow-nonempty-destination';
  static const _option_maxConcurrentDownloads = 'max-concurrent-downloads';
  static const _flag_verbose = 'verbose';

  static const _maxConcurrentDownloadsInvalidMessage =
      'The $_option_maxConcurrentDownloads option must be a number greater than zero.';

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
  String get usageFooter => '\nDuring export, any characters that are not '
      'allowed in file and folder names will be replaced with an underscore. '
      "Due to this renaming, it's possible that the export will save a file "
      'with the same name as another file not yet exported. Without the flag '
      'copy-if-exists, the second file will be skipped since the file already '
      'exists. A warning will be issued. This mostly affects Windows.';

  @override
  Future<void> run() async {
    final args = argResults!;
    final verbose = tryCast(args[_flag_verbose], false);
    final Ansi ansi = Ansi(io.stdout.supportsAnsiEscapes);
    final logger =
        verbose ? Logger.verbose(ansi: ansi) : Logger.standard(ansi: ansi);

    final listenToExportEventStream = _listenToExportEventStream(logger);

    await _validate(args)
        .flatMapFuture((_) => _exportDocuments(args))
        .bimap(
          (err) => usageException(err.join('\n')),
          (r) => _logSummary(logger, r, args[_flag_copyIfExists] as bool),
        )
        .run();

    await listenToExportEventStream.cancel();
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
    if (_getMaxDownloads(results) == null) {
      issues.add(_maxConcurrentDownloadsInvalidMessage);
    }

    if (issues.isNotEmpty) {
      return left(issues);
    }
    return right(unit);
  }

  int? _getMaxDownloads(ArgResults argResults) {
    return int.tryParse(
        tryCast(argResults[_option_maxConcurrentDownloads], ''));
  }

  Future<Either<List<String>, ExportResults>> _exportDocuments(
      ArgResults args) async {
    return _exportService
        .exportDocuments(
          orgId: tryCast(args[_option_orgId], ''),
          projectId: tryCast(args[_option_projectId], ''),
          destination: tryCast(args[_option_destination], ''),
          maxConcurrentDownloads: _getMaxDownloads(args)!,
          copyIfExists: args[_flag_copyIfExists] as bool,
          allowNonEmptyDestination:
              args[_flag_allowNonemptyDestination] as bool,
        )
        // todo(apn): this should not show usage
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
        case ExportFailure.maxConcurrentDownloadsInvalid:
          return _maxConcurrentDownloadsInvalidMessage;
        case ExportFailure.unknownError:
          return 'An unknown error has ocurred.';
      }
    }).toList();
  }

  void _logSummary(Logger logger, ExportResults results, bool copyIfExists) {
    const prefixExported_ = 'Total Documents Exported : ';
    const prefixAttempted = 'Total Documents Attempted: ';
    const prefixAsCopy___ = 'Exported as a Copy       : ';
    const prefixExists___ = 'Skipped (Already Exists) : ';
    const prefixFailure__ = 'Skipped (Unknown Failure): ';
    const prefixElapsed__ = 'Total Export Time        : ';

    String msg = '\n'
        '$prefixExported_${results.totalExported}\n'
        '$prefixAttempted${results.totalAttempted}\n';

    if (copyIfExists) {
      msg += '$prefixAsCopy___${results.exportedAsCopy}\n';
    } else {
      msg += '$prefixExists___${results.skippedAlreadyExists}\n';
    }

    msg += '$prefixFailure__${results.skippedUnknownFailure}\n'
        '$prefixElapsed__${results.elapsed.toString()}';

    return logger.stdout(msg);
  }

  StreamSubscription<ExportEvent> _listenToExportEventStream(Logger logger) {
    final Ansi ansi = logger.ansi;

    const prefixExported = '[Exported] ';
    const prefixAsCopy = '[Exported As Copy] ';
    const prefixExists = '[Skipped (Already Exists)] ';
    const prefixFailure = '[Skipped (Unknown Failure)] ';

    return _exportService.exportEventStream.listen((event) {
      event.when(
        docExportAttempt: (docId, n1Path) {/* use this to show progress */},
        docExported: (docId, n1Path, localPath, exportedAsCopy) {
          final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
              'Local Path: "$localPath"';
          if (exportedAsCopy) {
            logger.stdout('${ansi.yellow}$prefixAsCopy$msg${ansi.none}');
          } else {
            logger.trace('$prefixExported$msg');
          }
        },
        docSkippedAlreadyExists: (docId, n1Path, localPath) {
          final msg = 'Document ID: "$docId", N1 Path: "$n1Path", '
              'Local Path: "$localPath"';
          logger.stdout('${ansi.yellow}$prefixExists$msg${ansi.none}');
        },
        docSkippedUnknownFailure: (docId, n1Path) {
          final msg = 'Document ID: "$docId", N1 Path: "$n1Path"';
          logger.stderr('$prefixFailure$msg');
        },
      );
    });
  }
}
