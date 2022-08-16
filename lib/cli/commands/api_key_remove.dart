import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/api_key_service.dart';
import '../cli.dart';

class ApiKeyRemoveCommand extends Command<void> {
  ApiKeyRemoveCommand({ApiKeyService? apiKeyService})
      : _apiKeyService = apiKeyService ?? GetIt.I<ApiKeyService>();

  final ApiKeyService _apiKeyService;

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
    print('API key removed.');
  }
}
