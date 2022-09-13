import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

import '../../application/providers.dart';
import '../../application/settings.dart';
import '../cli.dart';
import '../providers.dart';

class ApiKeyRemoveCommand extends Command<void> {
  ApiKeyRemoveCommand({SettingsNotifier? settingsNotifier, Logger? logger})
      : _settingsNotifier = settingsNotifier ??
            GetIt.I<ProviderContainer>().read(settingsProvider.notifier),
        _logger =
            logger ?? GetIt.I.get<ProviderContainer>().read(loggerProvider);

  final SettingsNotifier _settingsNotifier;
  final Logger _logger;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'remove';

  @override
  String get description => 'Remove your API key from this device.';

  @override
  void run() {
    _settingsNotifier.setApiKey('');
    _logger.stdout('API key removed.');
  }
}
