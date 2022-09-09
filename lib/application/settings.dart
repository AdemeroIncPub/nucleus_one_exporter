// ignore_for_file: constant_identifier_names

import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:storagebox/storagebox.dart';

import '../util/runtime_helper.dart';
import 'constants.dart';

class Settings {
  Settings({StorageBoxWrapper? storageBoxWrapper})
      : _sbw = storageBoxWrapper ?? GetIt.I<StorageBoxWrapper>();

  @visibleForTesting
  static const String key_apiKey = 'apiKey';

  final StorageBoxWrapper _sbw;

  String get apiKey {
    return _sbw[key_apiKey];
  }

  Future<void> setApiKey(String newApiKey) async {
    final oldApiKey = apiKey;

    // If api key changed, save new key and recreate NucleusOneApp.
    if (newApiKey != oldApiKey) {
      _sbw[key_apiKey] = newApiKey;
      await GetIt.I.resetLazySingleton<n1.NucleusOneApp>();
      await GetIt.I.isReady<n1.NucleusOneApp>();
    }
  }
}

class StorageBoxWrapper {
  StorageBoxWrapper() : _sb = _initStorageBox();

  final StorageBox _sb;

  String operator [](String key) {
    return tryCast(_sb[key], '');
  }

  void operator []=(String key, String value) {
    _sb[key] = value;
  }

  static StorageBox _initStorageBox() =>
      StorageBox('settings', configPathPrefix: productId);
}
