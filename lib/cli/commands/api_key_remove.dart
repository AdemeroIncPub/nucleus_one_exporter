import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';

import '../../settings.dart';

class ApiKeyRemoveCommand extends Command<void> {
  @override
  String get name => 'remove';
  @override
  String get description => 'Remove your API key from this device.';

  @override
  void run() {
    GetIt.instance<Settings>().apiKey = '';
    print('API key removed.');
  }
}
