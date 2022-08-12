import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

import '../settings.dart';

Future<void> setApiKey(Settings settings, {required String newApiKey}) async {
  final oldApiKey = settings.apiKey;

  // If api key changed, save new key and recreate NucleusOneApp.
  if (newApiKey != oldApiKey) {
    settings.apiKey = newApiKey;
    await GetIt.I.resetLazySingleton<n1.NucleusOneApp>();
    await GetIt.I.isReady<n1.NucleusOneApp>();
  }
}
