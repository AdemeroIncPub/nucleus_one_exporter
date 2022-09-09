import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';

import '../../application/settings.dart';
import '../cli.dart';

class ApiKeyRemoveCommand extends Command<void> {
  ApiKeyRemoveCommand({Settings? settings, Logger? logger})
      : _settings = settings ?? GetIt.I<Settings>(),
        _logger = logger ?? GetIt.I<Logger>();

  final Settings _settings;
  final Logger _logger;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'remove';

  @override
  String get description => 'Remove your API key from this device.';

  @override
  Future<void> run() async {
    await _settings.setApiKey('');
    _logger.stdout('API key removed.');
  }
}
