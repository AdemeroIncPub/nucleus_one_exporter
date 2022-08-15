import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/commands/api_key_set.dart';
import '../../application/settings.dart';
import '../cli.dart';

class ApiKeySetCommand extends Command<void> {
  ApiKeySetCommand({Settings? settings})
      : _settings = settings ?? GetIt.I<Settings>();

  final Settings _settings;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

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
    if (argResults?.rest.length != 1) {
      usageException(
          'The $name command takes a single argument, your API key.');
    }

    final newApiKey = (argResults?.rest[0])!;
    await setApiKey(_settings, newApiKey: newApiKey);
    print('API key set: $newApiKey');
  }
}
