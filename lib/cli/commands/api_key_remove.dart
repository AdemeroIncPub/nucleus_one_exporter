import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/commands/api_key_remove.dart';
import '../../application/settings.dart';
import '../cli.dart';

class ApiKeyRemoveCommand extends Command<void> {
  ApiKeyRemoveCommand({Settings? settings})
      : _settings = settings ?? GetIt.I<Settings>();

  final Settings _settings;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'remove';

  @override
  String get description => 'Remove your API key from this device.';

  @override
  void run() {
    removeApiKey(_settings);
    print('API key removed.');
  }
}
