import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

import '../../settings.dart';

class ApiKeySetCommand extends Command<void> {
  @override
  String get name => 'set';
  @override
  String get description =>
      'Store your API key on this device (key is stored in plain text).\n'
      'You can generate an API key in your user profile in the Nucleus One web app.';
  @override
  String get invocation =>
      '${runner!.executableName} ${parent!.name} $name <your API key> [arguments]';

  @override
  Future<void> run() async {
    // Validate command.
    if (argResults?.rest.length != 1) {
      usageException(
          'The $name command takes a single argument, your API key.');
    }

    final gi = GetIt.instance;
    final settings = gi<Settings>();
    final oldApiKey = settings.apiKey;
    final newApiKey = (argResults?.rest[0])!;

    // If api key changed, save new key and recreate NucleusOneApp.
    if (newApiKey != oldApiKey) {
      settings.apiKey = newApiKey;
      gi.resetLazySingleton<n1.NucleusOneApp>();
      await gi.isReady<n1.NucleusOneApp>();
    }

    print('API key set: $newApiKey');
  }
}
