import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/nucleus_one_sdk_service.dart';
import 'package:nucleus_one_exporter/application/providers.dart';
import 'package:nucleus_one_exporter/application/settings.dart';

import '../../../_internal/fakes.dart';
import '../../../_internal/generators.dart';

final _gi = GetIt.I;

void main() {
  group('SettingsNotifier tests', () {
    group('modify apiKey tests', () {
      setUp(() {
        // _gi.registerSingleton<StorageBoxWrapper>(FakeStorageBoxWrapper());
      });

      tearDown(() async {
        // This is needed since the GetIt.reset() that follows also clears
        // the sdk's registrations, but leaving the sdk still initialized. Perhaps
        // the sdk should be using it's own GetIt.asNewInstance()?
        // await n1.NucleusOne.resetSdk();
        // await _gi.reset();
      });

      Glados(any.printableAscii).test(
        // tags: 'only',
        'setApiKey does nothing if key does not change',
        (newApiKey) async {
          _gi.registerSingleton<StorageBoxWrapper>(FakeStorageBoxWrapper());
          final sbw = _gi.get<StorageBoxWrapper>();
          sbw[SettingsNotifier.key_apiKey] = newApiKey;
          final container = ProviderContainer();
          Future<NucleusOneSdkService> getN1SdkSvc() =>
              container.read(nucleusOneSdkServiceProvider.future);

          final initialN1SdkSvc = await getN1SdkSvc();
          expect(initialN1SdkSvc, same(await getN1SdkSvc()));
          expect(sbw[SettingsNotifier.key_apiKey], newApiKey);

          final SettingsNotifier sut =
              container.read(settingsProvider.notifier);
          sut.setApiKey(newApiKey);

          expect(sbw[SettingsNotifier.key_apiKey], newApiKey);
          final newN1SdkSvc = await getN1SdkSvc();
          expect(newN1SdkSvc, same(initialN1SdkSvc));

          container.dispose();
          await n1.NucleusOne.resetSdk();
          await _gi.unregister<StorageBoxWrapper>();
          await _gi.reset();
        },
      );

      group("setApiKey starts with default of '' (blank)", () {
        Glados(any.printableAscii).test(
          // tags: 'only',
          'setApiKey sets any key and resets NucleusOneApp _if_ key changed',
          (newApiKey) async {
            if (newApiKey == '') {
              // This test is for changing the key - it starts as '' already.
              return;
            }

            _gi.registerSingleton<StorageBoxWrapper>(FakeStorageBoxWrapper());
            final sbw = _gi.get<StorageBoxWrapper>();
            final container = ProviderContainer();
            Future<NucleusOneSdkService> getN1SdkSvc() =>
                container.read(nucleusOneSdkServiceProvider.future);

            final initialN1SdkSvc = await getN1SdkSvc();
            expect(sbw[SettingsNotifier.key_apiKey], '');
            expect(initialN1SdkSvc, same(await getN1SdkSvc()));

            final SettingsNotifier sut =
                container.read(settingsProvider.notifier);
            sut.setApiKey(newApiKey);

            expect(sbw[SettingsNotifier.key_apiKey], newApiKey);
            final newN1SdkSvc = await getN1SdkSvc();
            expect(newN1SdkSvc, isNot(same(initialN1SdkSvc)));
            expect(newN1SdkSvc, same(await getN1SdkSvc()));

            container.dispose();
            await n1.NucleusOne.resetSdk();
            await _gi.unregister<StorageBoxWrapper>();
            await _gi.reset();
          },
        );
      });

      group('setApiKey starts with the previous key set', () {
        var oldKey = '';

        setUp(() {
          _gi.registerSingleton<StorageBoxWrapper>(FakeStorageBoxWrapper());
        });

        Glados(any.printableAscii).test(
          // tags: 'only',
          'setApiKey sets any key and resets NucleusOneApp _if_ key changed',
          (newApiKey) async {
            if (newApiKey == oldKey) {
              // This test is for changing the key.
              return;
            }

            final sbw = _gi.get<StorageBoxWrapper>();
            final container = ProviderContainer();
            Future<NucleusOneSdkService> getN1SdkSvc() =>
                container.read(nucleusOneSdkServiceProvider.future);

            final initialN1SdkSvc = await getN1SdkSvc();
            expect(sbw[SettingsNotifier.key_apiKey], oldKey);
            expect(initialN1SdkSvc, same(await getN1SdkSvc()));

            final SettingsNotifier sut =
                container.read(settingsProvider.notifier);
            sut.setApiKey(newApiKey);

            expect(sbw[SettingsNotifier.key_apiKey], newApiKey);
            final newN1SdkSvc = await getN1SdkSvc();
            expect(newN1SdkSvc, isNot(same(initialN1SdkSvc)));
            expect(newN1SdkSvc, same(await getN1SdkSvc()));
            oldKey = newApiKey;

            container.dispose();
            await n1.NucleusOne.resetSdk();
          },
        );
      });

      group("setApiKey to '' tests", () {
        Glados(any.printableAscii).test(
          'removeApiKey removes any key',
          (apiKey) {
            // Arrange
            final sbw = FakeStorageBoxWrapper();
            sbw[SettingsNotifier.key_apiKey] = apiKey;
            final sut = SettingsNotifier(storageBoxWrapper: sbw);
            expect(sbw[SettingsNotifier.key_apiKey], apiKey);

            sut.setApiKey('');

            expect(sbw[SettingsNotifier.key_apiKey], '');
          },
        );
      });
    });
  });
}
