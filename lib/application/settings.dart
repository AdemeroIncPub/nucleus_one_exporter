// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';
import 'package:storagebox/storagebox.dart';

import '../util/runtime_helper.dart';
import 'constants.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({required String apiKey}) = _Settings;
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier({StorageBoxWrapper? storageBoxWrapper})
      : _sbw = storageBoxWrapper ?? GetIt.I<StorageBoxWrapper>(),
        super(Settings(apiKey: storageBoxWrapper?[key_apiKey] ?? ''));

  final StorageBoxWrapper _sbw;

  @visibleForTesting
  static const String key_apiKey = 'apiKey';

  void setApiKey(String newApiKey) {
    final oldApiKey = state.apiKey;

    if (newApiKey != oldApiKey) {
      _sbw[key_apiKey] = newApiKey;
      state = state.copyWith(apiKey: newApiKey);
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
