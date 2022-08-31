import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/api_key_service.dart';
import '../cli.dart';

class ApiKeyRemoveCommand extends Command<void> {
  ApiKeyRemoveCommand({ApiKeyService? apiKeyService, Logger? logger})
      : _apiKeyService = apiKeyService ?? GetIt.I<ApiKeyService>(),
        _logger = logger ?? GetIt.I<Logger>();

  final ApiKeyService _apiKeyService;
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
    _apiKeyService.removeApiKey();
    _logger.stdout('API key removed.');
  }
}
