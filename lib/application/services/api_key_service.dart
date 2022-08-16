import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

import '../settings.dart';

class ApiKeyService {
  ApiKeyService({Settings? settings})
      : _settings = settings ?? GetIt.I<Settings>();

  final Settings _settings;

  Future<void> setApiKey(String newApiKey) async {
    final oldApiKey = _settings.apiKey;

    // If api key changed, save new key and recreate NucleusOneApp.
    if (newApiKey != oldApiKey) {
      _settings.apiKey = newApiKey;
      await GetIt.I.resetLazySingleton<n1.NucleusOneApp>();
      await GetIt.I.isReady<n1.NucleusOneApp>();
    }
  }

  void removeApiKey() {
    _settings.apiKey = '';
  }

  String showApiKey() {
    return _settings.apiKey;
  }
}
