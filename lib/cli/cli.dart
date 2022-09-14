import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';

import '../application/constants.dart';
import 'commands/api_key.dart';
import 'commands/export.dart';
import 'commands/info.dart';

CommandRunner<void> createRootCommand() {
  return CommandRunner(
    productId,
    '$productName\n'
    'Export your Nucleus One documents to a local path.\n'
    'For more information about Nucleus One, visit $marketingUrl.',
    usageLineLength: usageLineLength,
  )
    ..addCommand(ApiKeyCommand())
    ..addCommand(InfoCommand())
    ..addCommand(ExportCommand())
    ..argParser.addFlag(
      'verbose',
      help: 'Enabled detailed output.',
      abbr: 'v',
      negatable: false,
    );
}

int get usageLineLength => min(stdout.terminalColumns, 90);
