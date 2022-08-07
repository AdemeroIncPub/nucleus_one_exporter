// ignore_for_file: constant_identifier_names

import 'package:storagebox/storagebox.dart';

import 'constants.dart';
import 'runtime_helper.dart';

class Settings {
  Settings() : _sb = _initStorageBox();

  static const String _key_apiKey = 'apiKey';

  final StorageBox _sb;

  String get apiKey {
    final value = _sb[_key_apiKey];
    return tryCast(value, '');
  }

  set apiKey(String value) {
    _sb[_key_apiKey] = value;
  }

  static StorageBox _initStorageBox() =>
      StorageBox('settings', configPathPrefix: productId);
}
