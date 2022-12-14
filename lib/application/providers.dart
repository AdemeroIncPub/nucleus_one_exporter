import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:riverpod/riverpod.dart';

import 'nucleus_one_sdk_service.dart';
import 'path_validator.dart';
import 'services/export_service.dart';
import 'services/user_orgs_summary_service.dart';
import 'settings.dart';

final storageBoxWrapperProvider =
    Provider<StorageBoxWrapper>((ref) => GetIt.I<StorageBoxWrapper>());

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  final sbw = ref.watch(storageBoxWrapperProvider);
  return SettingsNotifier(storageBoxWrapper: sbw);
});

final pathValidatorProvider = Provider<PathValidator>((ref) => PathValidator());

final nucleusOneSdkServiceProvider =
    FutureProvider<NucleusOneSdkService>((ref) async {
  final apiKey =
      ref.watch(settingsProvider.select((settings) => settings.apiKey));
  final apiKeyCompleter = Completer<NucleusOneSdkService>();
  if (apiKey != '') {
    // Calling NucleusOne.resetSdk() in case it has already been initialized
    // (it's a no op if not initialized).
    await n1.NucleusOne.resetSdk();
    await n1.NucleusOne.intializeSdk();

    final n1App =
        n1.NucleusOneApp(options: n1.NucleusOneOptions(apiKey: apiKey));
    apiKeyCompleter.complete(NucleusOneSdkService(n1App: n1App));
  }
  return apiKeyCompleter.future;
});

final userOrgsSummaryServiceProvider =
    FutureProvider<UserOrgsSummaryService>((ref) async {
  final n1SdkService = ref.watch(nucleusOneSdkServiceProvider.future);
  return UserOrgsSummaryService(n1Sdk: n1SdkService);
});

final userOrgsSummaryProvider = FutureProvider<UserOrgsSummary>((ref) async {
  final userOrgsSummaryService =
      await ref.watch(userOrgsSummaryServiceProvider.future);
  return userOrgsSummaryService.getSummary();
});

final exportServiceProvider = FutureProvider<ExportService>((ref) async {
  final pathValidator = ref.watch(pathValidatorProvider);
  final n1SdkSvc = ref.watch(nucleusOneSdkServiceProvider.future);
  return ExportService(n1SdkSvc: n1SdkSvc, pathValidator: pathValidator);
});
