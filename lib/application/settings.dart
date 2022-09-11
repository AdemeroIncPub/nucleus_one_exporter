// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storagebox/storagebox.dart';

import '../util/runtime_helper.dart';
import 'constants.dart';

class Settings extends ChangeNotifier {
  Settings({StorageBoxWrapper? storageBoxWrapper})
      : _sbw = storageBoxWrapper ?? GetIt.I<StorageBoxWrapper>();

  @visibleForTesting
  static const String key_apiKey = 'apiKey';

  final StorageBoxWrapper _sbw;

  String get apiKey {
    return _sbw[key_apiKey];
  }

  void setApiKey(String newApiKey) {
    final oldApiKey = apiKey;

    // If api key changed, save new key and recreate NucleusOneApp.
    if (newApiKey != oldApiKey) {
      _sbw[key_apiKey] = newApiKey;
      notifyListeners();
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
