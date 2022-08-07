import 'package:args/command_runner.dart';

import 'api_key_remove.dart';
import 'api_key_set.dart';
import 'api_key_show.dart';

class ApiKeyCommand extends Command<void> {
  ApiKeyCommand() {
    addSubcommand(ApiKeySetCommand());
    addSubcommand(ApiKeyRemoveCommand());
    addSubcommand(ApiKeyShowCommand());
  }

  @override
  String get name => 'api-key';
  @override
  String get description => 'API key commands.\n'
      'An API key is required to access your Nucleus One account.';
}
