import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/nucleus_one_sdk_service.dart';
import 'package:nucleus_one_exporter/application/path_validator.dart';
import 'package:nucleus_one_exporter/application/services/api_key_service.dart';
import 'package:nucleus_one_exporter/application/services/export_service.dart';
import 'package:nucleus_one_exporter/application/services/user_orgs_summary_service.dart';
import 'package:nucleus_one_exporter/application/settings.dart';
import 'package:nucleus_one_exporter/cli/cli.dart';

Future<void> main(List<String> args) async {
  await _initializeDependencies();

  final rootCommand = createRootCommand();
  return rootCommand
      .run(args)
      .onError<n1.HttpException>((error, stackTrace) =>
          print('Error communicating with Nucleus One API. '
              '${["Status Code: ${error.status}", error.message].join(". ")}'))
      .onError<UsageException>((error, stackTrace) => print(error.toString()));
}

Future<void> _initializeDependencies() async {
  final gi = GetIt.I;
  gi.registerSingleton<Settings>(Settings());
  gi.registerSingleton<ApiKeyService>(ApiKeyService());
  gi.registerSingleton<PathValidator>(PathValidator());
  gi.registerSingleton<NucleusOneSdkService>(NucleusOneSdkService());
  gi.registerSingleton<ExportService>(ExportService());
  gi.registerSingleton<UserOrgsSummaryService>(UserOrgsSummaryService());

  gi.registerLazySingletonAsync<n1.NucleusOneApp>(() async {
    // GetIt.resetLazySingleton<NucleusOneApp>() is called when modifying the
    // API key, which will cause this singleton to be (re)created next time
    // NucleusOneApp is requested. Call NucleusOne.resetSdk() in case it has
    // already been initialized (it's a no op if not initialized).
    await n1.NucleusOne.resetSdk();
    await n1.NucleusOne.intializeSdk();
    final apiKey = gi<Settings>().apiKey;
    final n1App =
        n1.NucleusOneApp(options: n1.NucleusOneOptions(apiKey: apiKey));
    return n1App;
  });

  await gi.isReady<n1.NucleusOneApp>();
}
