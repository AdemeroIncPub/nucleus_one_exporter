import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart'
    show NucleusOne, NucleusOneApp, NucleusOneOptions;
import 'package:nucleus_one_exporter/cli/cli.dart';
import 'package:nucleus_one_exporter/settings.dart';

Future<void> main(List<String> args) async {
  await _initializeDependencies();

  final rootCommand = createRootCommand();
  return rootCommand
      .run(args)
      .onError<UsageException>((error, stackTrace) => print(error.toString()));
}

Future<void> _initializeDependencies() async {
  final gi = GetIt.instance;
  gi.registerSingleton<Settings>(Settings());

  gi.registerLazySingletonAsync<NucleusOneApp>(() async {
    // GetIt.resetLazySingleton<NucleusOneApp>() is called when modifying the
    // API key, which will cause this singleton to be (re)created next time
    // NucleusOneApp is requested. Call NucleusOne.resetSdk() in case it has
    // already been initialized (it's a no op if not initialized).
    await NucleusOne.resetSdk();
    await NucleusOne.intializeSdk();
    final apiKey = gi<Settings>().apiKey;
    final n1App = NucleusOneApp(options: NucleusOneOptions(apiKey: apiKey));
    return n1App;
  });

  await gi.isReady<NucleusOneApp>();
}
