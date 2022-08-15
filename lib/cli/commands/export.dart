import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../cli.dart';

class ExportCommand extends Command<void> {
  ExportCommand() {
    argParser
      ..addOption('destination',
          help: 'Relative or absolute path to create documents. (required)',
          abbr: 'd',
          valueHelp: 'local path')
      ..addFlag('overwrite', help: 'Overwrite existing documents.')
      ..addFlag('allow-nonempty-destination',
          help:
              'If the specified path contains files or folder, export anyway.');
  }

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'export';

  @override
  String get description =>
      'Export your Nucleus One documents to a local path.';

  @override
  Future<void> run() async {}
}
