import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';

import '../../application/settings.dart';
import '../cli.dart';

class ApiKeyShowCommand extends Command<void> {
  ApiKeyShowCommand({Settings? settings, Logger? logger})
      : _settings = settings ?? GetIt.I<Settings>(),
        _logger = logger ?? GetIt.I<Logger>();

  final Settings _settings;
  final Logger _logger;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'show';

  @override
  String get description => 'Show stored api key.';

  @override
  Future<void> run() async {
    final apiKey = _settings.apiKey;
    _logger.stdout('API key: $apiKey');
  }
}
