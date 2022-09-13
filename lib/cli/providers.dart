import 'dart:io' as io;

import 'package:cli_util/cli_logging.dart';
import 'package:riverpod/riverpod.dart';

final cliArgsProvider = StateProvider<List<String>>((ref) {
  return <String>[];
});

final loggerProvider = Provider<Logger>((ref) {
  final args = ref.watch(cliArgsProvider);
  var verbose = false;
  if (args.contains('-v') || args.contains('--verbose')) {
    verbose = true;
  }
  final Ansi ansi = Ansi(io.stdout.supportsAnsiEscapes);
  return verbose ? Logger.verbose(ansi: ansi) : Logger.standard(ansi: ansi);
});
