// ignore_for_file: non_constant_identifier_names

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../../application/exceptions.dart';
import '../cli.dart';

class ExportCommand extends Command<void> {
  ExportCommand() {
    argParser
      ..addOption(
        _option_destination,
        help: 'Relative or absolute path to create documents. (required)',
        abbr: 'd',
        valueHelp: 'local path',
      )
      ..addOption(
        _option_orgId,
        help: 'Organization ID (required)',
        abbr: 'o',
        valueHelp: 'id',
      )
      ..addOption(
        _option_projectId,
        help: 'Project ID (required)',
        abbr: 'p',
        valueHelp: 'id',
      )
      ..addFlag(
        _flag_overwrite,
        help: 'Overwrite existing documents.',
      )
      ..addFlag(
        _flag_allowNonemptyDestination,
        help: 'If the specified path contains files or folder, export anyway.',
      );
  }

  static final _option_destination = 'destination';
  static final _option_orgId = 'organization-id';
  static final _option_projectId = 'project-id';
  static final _flag_overwrite = 'overwrite';
  static final _flag_allowNonemptyDestination = 'allow-nonempty-destination';

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
    try {
      final results = argResults!;
      _validate(results);
    } on ValidationException catch (e) {
      usageException(e.message);
    }
  }

  void _validate(ArgResults results) {
    final issues = <String>[];
    if (!results.wasParsed(_option_destination)) {
      issues.add('The $_option_destination option is required.');
    }
    if (!results.wasParsed(_option_orgId)) {
      issues.add('The $_option_orgId option is required.');
    }
    if (!results.wasParsed(_option_projectId)) {
      issues.add('The $_option_projectId option is required.');
    }

    if (issues.isNotEmpty) {
      throw ValidationException(issues.join('\n'));
    }
  }
}
