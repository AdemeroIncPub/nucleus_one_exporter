import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/path_validator.dart';
import 'package:nucleus_one_exporter/application/settings.dart';
import 'package:nucleus_one_exporter/cli/cli.dart';
import 'package:nucleus_one_exporter/cli/providers.dart';
import 'package:riverpod/riverpod.dart';

Future<void> main(List<String> args) async {
  await _initializeDependencies(args);
  final logger = GetIt.I.get<ProviderContainer>().read(loggerProvider);
  final ansi = logger.ansi;

  final rootCommand = createRootCommand();
  return rootCommand.run(args).onError<n1.HttpException>((error, stackTrace) {
    logger.stderr('${ansi.red}'
        'Error communicating with Nucleus One API. '
        '${["Status Code: ${error.status}", error.message].join(". ")}'
        '${ansi.none}');
  }).onError<UsageException>((error, stackTrace) => logger.stderr('$error'));
}

Future<void> _initializeDependencies(List<String> args) async {
  final container = ProviderContainer();
  container.read(cliArgsProvider.notifier).state = args;

  final gi = GetIt.I;
  gi.registerSingleton<ProviderContainer>(container);
  gi.registerSingleton<StorageBoxWrapper>(StorageBoxWrapper());
}
