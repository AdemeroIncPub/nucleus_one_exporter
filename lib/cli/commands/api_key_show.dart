import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../settings.dart';

class ApiKeyShowCommand extends Command<void> {
  @override
  String get name => 'show';
  @override
  String get description => 'Show stored api key.';

  @override
  Future<void> run() async {
    final apiKey = GetIt.instance<Settings>().apiKey;
    print('API key: $apiKey');
  }
}
