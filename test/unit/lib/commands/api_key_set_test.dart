import 'package:get_it/get_it.dart';
import 'package:glados/glados.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;
import 'package:nucleus_one_exporter/application/commands/api_key_set.dart';

import '../../../_internal/fakes.dart';
import '../../../_internal/generators.dart';
import '../../../_internal/mocks.dart';

final _gi = GetIt.I;

void main() {
  setUp(() {
    _gi.registerLazySingletonAsync<n1.NucleusOneApp>(
        () => Future.value(MockNucleusOneApp()));
    return _gi.isReady<n1.NucleusOneApp>();
  });

  tearDown(() {
    _gi.reset();
  });

  Glados(any.printableAscii).test(
    "setApiKey does nothing if key doesn't change",
    (newApiKey) async {
      final settings = FakeSettings();
      settings.apiKey = newApiKey;
      final initialN1App = _gi<n1.NucleusOneApp>();
      expect(settings.apiKey, newApiKey);
      expect(initialN1App, same(_gi<n1.NucleusOneApp>()));

      await setApiKey(settings, newApiKey: newApiKey);

      expect(settings.apiKey, newApiKey);
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

          final settings = FakeSettings();
          final initialN1App = _gi<n1.NucleusOneApp>();
          expect(settings.apiKey, '');
          expect(initialN1App, same(_gi<n1.NucleusOneApp>()));

          await setApiKey(settings, newApiKey: newApiKey);

          expect(settings.apiKey, newApiKey);
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
      var settings = FakeSettings();
      var oldKey = '';

      setUp(() {
        settings = FakeSettings();
      });

      Glados(any.printableAscii).test(
        'setApiKey sets any key and resets NucleusOneApp _if_ key changed',
        (newApiKey) async {
          if (newApiKey == oldKey) {
            // This test is for changing the key.
            return;
          }

          final initialN1App = _gi<n1.NucleusOneApp>();
          expect(settings.apiKey, oldKey);
          expect(initialN1App, same(_gi<n1.NucleusOneApp>()));

          await setApiKey(settings, newApiKey: newApiKey);

          expect(settings.apiKey, newApiKey);
          final newN1App = _gi<n1.NucleusOneApp>();
          expect(newN1App, isNot(same(initialN1App)));
          expect(newN1App, same(_gi<n1.NucleusOneApp>()));
          oldKey = newApiKey;
        },
      );
    },
  );
}
