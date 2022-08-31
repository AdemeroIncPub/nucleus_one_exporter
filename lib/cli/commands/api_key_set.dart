import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/api_key_service.dart';
import '../cli.dart';

class ApiKeySetCommand extends Command<void> {
  ApiKeySetCommand({ApiKeyService? apiKeyService, Logger? logger})
      : _apiKeyService = apiKeyService ?? GetIt.I<ApiKeyService>(),
        _logger = logger ?? GetIt.I<Logger>();

  final ApiKeyService _apiKeyService;
  final Logger _logger;

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
    await _apiKeyService.setApiKey(newApiKey);
    _logger.stdout('API key set: $newApiKey');
  }
}
