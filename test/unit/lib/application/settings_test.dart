import 'package:get_it/get_it.dart';
import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/settings.dart';

import '../../../_internal/fakes.dart';
import '../../../_internal/generators.dart';
import '../../../_internal/mocks.dart';

final _gi = GetIt.I;

void main() {
  group('modify apiKey tests', () {
    setUp(() async {
      _gi.registerLazySingletonAsync<n1.NucleusOneApp>(
          () => Future.value(MockNucleusOneApp()));
      return _gi.isReady<n1.NucleusOneApp>();
    });

    tearDown(() async {
      return _gi.reset();
    });

    Glados(any.printableAscii).test(
      "setApiKey does nothing if key doesn't change",
      (newApiKey) async {
        final initialN1App = _gi<n1.NucleusOneApp>();
        final sbw = FakeStorageBoxWrapper();
        sbw[Settings.key_apiKey] = newApiKey;
        final sut = Settings(storageBoxWrapper: sbw);
        expect(initialN1App, same(_gi<n1.NucleusOneApp>()));
        expect(sbw[Settings.key_apiKey], newApiKey);

        await sut.setApiKey(newApiKey);

        expect(sbw[Settings.key_apiKey], newApiKey);
        final newN1App = _gi<n1.NucleusOneApp>();
        expect(newN1App, same(initialN1App));
      },
    );

    group(
      "setApiKey starts with default of '' (blank)",
      () {
        Glados(any.printableAscii).test(
          'setApiKey sets any key and resets NucleusOneApp _if_ key changed',
          (newApiKey) async {
            if (newApiKey == '') {
              // This test is for changing the key - it starts as '' already.
              return;
            }

            final initialN1App = _gi<n1.NucleusOneApp>();
            final sbw = FakeStorageBoxWrapper();
            final sut = Settings(storageBoxWrapper: sbw);
            expect(sbw[Settings.key_apiKey], '');
            expect(initialN1App, same(_gi<n1.NucleusOneApp>()));

            await sut.setApiKey(newApiKey);

            expect(sbw[Settings.key_apiKey], newApiKey);
            final newN1App = _gi<n1.NucleusOneApp>();
            expect(newN1App, isNot(same(initialN1App)));
            expect(newN1App, same(_gi<n1.NucleusOneApp>()));
          },
        );
      },
    );

    group(
      'setApiKey starts with the previous key set',
      () {
        var sbw = FakeStorageBoxWrapper();
        var oldKey = '';

        setUp(() {
          sbw = FakeStorageBoxWrapper();
        });

        Glados(any.printableAscii).test(
          'setApiKey sets any key and resets NucleusOneApp _if_ key changed',
          (newApiKey) async {
            if (newApiKey == oldKey) {
              // This test is for changing the key.
              return;
            }

            final initialN1App = _gi<n1.NucleusOneApp>();
            final sut = Settings(storageBoxWrapper: sbw);
            expect(sbw[Settings.key_apiKey], oldKey);
            expect(initialN1App, same(_gi<n1.NucleusOneApp>()));

            await sut.setApiKey(newApiKey);

            expect(sbw[Settings.key_apiKey], newApiKey);
            final newN1App = _gi<n1.NucleusOneApp>();
            expect(newN1App, isNot(same(initialN1App)));
            expect(newN1App, same(_gi<n1.NucleusOneApp>()));
            oldKey = newApiKey;
          },
        );
      },
    );

    group("setApiKey to '' tests", () {
      Glados(any.printableAscii).test(
        'removeApiKey removes any key',
        (apiKey) async {
          // Arrange
          final sbw = FakeStorageBoxWrapper();
          sbw[Settings.key_apiKey] = apiKey;
          final sut = Settings(storageBoxWrapper: sbw);

          await sut.setApiKey('');

          expect('', sbw[Settings.key_apiKey]);
        },
      );
    });
  });

  group('getApiKey tests', () {
    Glados(any.printableAscii).test(
      'getApiKey returns any key',
      (apiKey) {
        // Arrange
        final sbw = FakeStorageBoxWrapper();
        final sut = Settings(storageBoxWrapper: sbw);
        expect('', sut.apiKey);

        sbw[Settings.key_apiKey] = apiKey;

        expect(apiKey, sut.apiKey);
      },
    );
  });
}
