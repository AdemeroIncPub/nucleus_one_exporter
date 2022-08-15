import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/commands/api_key_show.dart';
import '../../application/settings.dart';
import '../cli.dart';

class ApiKeyShowCommand extends Command<void> {
  ApiKeyShowCommand({Settings? settings})
      : _settings = settings ?? GetIt.I<Settings>();

  final Settings _settings;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'show';

  @override
  String get description => 'Show stored api key.';

  @override
  Future<void> run() async {
    final apiKey = showApiKey(_settings);
    print('API key: $apiKey');
  }
}
