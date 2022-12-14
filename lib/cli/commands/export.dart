// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

import '../../application/path_validator.dart';
import '../../application/providers.dart';
import '../../application/services/export_documents_args.dart';
import '../../application/services/export_event.dart';
import '../../application/services/export_results.dart';
import '../../application/services/export_service.dart';
import '../../util/runtime_helper.dart';
import '../cli.dart';
import '../providers.dart';

class ExportCommand extends Command<void> {
  ExportCommand({
    Future<ExportService>? exportService,
    PathValidator? pathValidator,
    Logger? logger,
  })  : _exportService = exportService ??
            GetIt.I<ProviderContainer>().read(exportServiceProvider.future),
        _pathValidator = pathValidator ??
            GetIt.I<ProviderContainer>().read(pathValidatorProvider),
        _logger = logger ?? GetIt.I<ProviderContainer>().read(loggerProvider) {
    argParser.addOption(
      _option_orgId,
      help: 'Organization ID to export from. (required)',
      abbr: 'o',
      valueHelp: 'id',
    );
    argParser.addOption(
      _option_projectId,
      help: 'Project ID to export from. (required)',
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
      _flag_allowNonemptyDestination,
      help:
          'If set, allow export even if destination contains files or folders.',
    );
    argParser.addFlag(
      _flag_copyIfExists,
      help: 'Create a copy if the file already exists. If not set, existing '
          'files will be skipped.',
    );
    argParser.addOption(
      _option_maxConcurrentDownloads,
      help: 'Maximum number of documents to download simultaneously.',
      abbr: 'c',
      valueHelp: 'max',
      defaultsTo: '4',
    );
    argParser.addOption(
      _option_logFile,
      help: 'Relative or absolute path to log file. An existing file will be '
          'overwritten.',
      abbr: 'l',
      valueHelp: 'log file path',
    );
  }

  static const _option_orgId = 'organization-id';
  static const _option_projectId = 'project-id';
  static const _option_destination = 'destination';
  static const _option_logFile = 'log';
  static const _flag_allowNonemptyDestination = 'allow-nonempty-destination';
  static const _flag_copyIfExists = 'copy-if-exists';
  static const _option_maxConcurrentDownloads = 'max-concurrent-downloads';

  static const _maxConcurrentDownloadsInvalidMessage =
      'The $_option_maxConcurrentDownloads option must be a number greater than zero.';

  final Future<ExportService> _exportService;
  final PathValidator _pathValidator;
  final Logger _logger;

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
    final copyIfExists = args[_flag_copyIfExists] as bool;

    final exportArgs = ExportDocumentsArgs(
      orgId: tryCast(args[_option_orgId], ''),
      projectId: tryCast(args[_option_projectId], ''),
      destination: tryCast(args[_option_destination], ''),
      allowNonEmptyDestination: args[_flag_allowNonemptyDestination] as bool,
      copyIfExists: copyIfExists,
      maxConcurrentDownloads:
          tryCast(args[_option_maxConcurrentDownloads], '0'),
      logFile: tryCast(args[_option_logFile], null),
    );
    final validArgs = exportArgs.validate(_pathValidator);

    final exportService = await _exportService;
    await validArgs
        .mapLeft(_mapValidationFailures2ExportFailures)
        .mapLeft(_mapExportFailures2Messages)
        .map((validArgs) => _exportDocuments(exportService, validArgs))
        .map((r) async {
          return (await r).results.mapLeft(_mapExportFailures2Messages);
        })
        .flatMap((r) => TaskEither.tryCatch(
              () => r,
              (error, stackTrace) =>
                  _mapExportFailures2Messages([ExportFailure.unknownFailure]),
            ))
        .bimap(
          (validationErrors) => usageException(validationErrors.join('\n')),
          (r) => r.fold(
            (l) => _logger.stderr(l.join('\n')),
            (r) => _logSummary(_logger, r, copyIfExists),
          ),
        )
        .run();
  }

  Future<ExportFinished> _exportDocuments(
    ExportService exportService,
    ValidatedExportDocumentsArgs validArgs,
  ) {
    final eventStream = exportService.exportDocuments(validArgs);
    return _listenToExportEventStream(eventStream, _logger);
  }

  List<ExportFailure> _mapValidationFailures2ExportFailures(
      List<ExportDocumentsArgsValidationFailure> err) {
    return err.map((e) {
      switch (e) {
        case ExportDocumentsArgsValidationFailure.orgIdMissing:
          return ExportFailure.orgIdInvalid;
        case ExportDocumentsArgsValidationFailure.projectIdMissing:
          return ExportFailure.projectIdInvalid;
        case ExportDocumentsArgsValidationFailure.destinationMissing:
          return ExportFailure.destinationInvalid;
        case ExportDocumentsArgsValidationFailure.destinationInvalid:
          return ExportFailure.destinationInvalid;
        case ExportDocumentsArgsValidationFailure.destinationNotEmpty:
          return ExportFailure.destinationNotEmpty;
        case ExportDocumentsArgsValidationFailure.maxDownloadsInvalid:
          return ExportFailure.maxConcurrentDownloadsInvalid;
        case ExportDocumentsArgsValidationFailure.logFileInvalid:
          return ExportFailure.logFileInvalid;
        case ExportDocumentsArgsValidationFailure.unknownFailure:
          return ExportFailure.unknownFailure;
      }
    }).toList();
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
        case ExportFailure.logFileInvalid:
          return 'The $_option_logFile is invalid.';
        case ExportFailure.unknownFailure:
          return 'An unknown failure has ocurred.';
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
        'Export finished.\n'
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

  Future<ExportFinished> _listenToExportEventStream(
    Stream<ExportEvent> eventStream,
    Logger logger,
  ) async {
    final Ansi ansi = logger.ansi;

    var totalDocs = 0;
    var docsProcessed = 0;
    final sw = Stopwatch()..start();
    final streamCompleter = Completer<ExportFinished>();
    final sub = eventStream.listen((event) {
      void incrementDocsProcessed() {
        docsProcessed += 1;
        if (sw.elapsed > const Duration(seconds: 5)) {
          sw.reset();
          logger.stdout(
              '* Export ${(docsProcessed * 100.0 / totalDocs).floor()}% complete...');
        }
      }

      event.maybeMap(
        orElse: () {},
        beginExport: (e) {
          totalDocs = e.docCount;
          logger.stdout('* Export 0% complete...');
        },
        docExported: (e) {
          incrementDocsProcessed();
          if (e.exportedAsCopy) {
            logger.stdout('${ansi.yellow}${e.getLogMessage()}${ansi.none}');
          } else {
            logger.trace(e.getLogMessage());
          }
        },
        docSkippedAlreadyExists: (e) {
          incrementDocsProcessed();
          logger.stdout('${ansi.yellow}${e.getLogMessage()}${ansi.none}');
        },
        docSkippedUnknownFailure: (e) {
          incrementDocsProcessed();
          logger.stderr('${ansi.red}${e.getLogMessage()}${ansi.none}');
        },
        exportFinished: (e) {
          streamCompleter.complete(
            ExportFinished(
                results: e.results,
                canceledBeforeComplete: e.canceledBeforeComplete),
          );
        },
      );
    });
    return streamCompleter.future.whenComplete(() => sub.cancel());
  }
}
