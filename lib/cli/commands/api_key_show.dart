import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../application/services/api_key_service.dart';
import '../cli.dart';

class ApiKeyShowCommand extends Command<void> {
  ApiKeyShowCommand({ApiKeyService? apiKeyService})
      : _apiKeyService = apiKeyService ?? GetIt.I<ApiKeyService>();

  final ApiKeyService _apiKeyService;

  @override
  ArgParser get argParser => _argParser;
  final _argParser = ArgParser(usageLineLength: usageLineLength);

  @override
  String get name => 'show';

  @override
  String get description => 'Show stored api key.';

  @override
  Future<void> run() async {
    final apiKey = _apiKeyService.showApiKey();
    print('API key: $apiKey');
  }
}
