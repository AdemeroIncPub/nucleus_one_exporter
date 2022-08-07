import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';

import '../constants.dart';
import 'commands/api_key.dart';

CommandRunner<void> createRootCommand() {
  return CommandRunner(productId, productName,
      usageLineLength: min(stdout.terminalColumns, 100))
    ..addCommand(ApiKeyCommand());
}
