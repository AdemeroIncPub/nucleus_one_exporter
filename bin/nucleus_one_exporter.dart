import 'package:args/command_runner.dart';
import 'package:nucleus_one_exporter/nucleus_one_exporter.dart'
    as nucleus_one_exporter;

void main(List<String> args) {
  CommandRunner('nucleus_one_exporter', 'Nucleus One export tool.')
    ..addCommand(LoginCommand())
    ..run(args);
}

class LoginCommand extends Command {
  @override
  String get name => 'login';
  @override
  String get description => 'Login to Nucleus One.';
}
