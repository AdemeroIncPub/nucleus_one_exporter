import 'package:glados/glados.dart';
import 'package:nucleus_one_exporter/commands/api_key_remove.dart';

import '../../../_internal/fakes.dart';
import '../../../_internal/generators.dart';

void main() {
  Glados(any.printableAscii).test(
    'removeApiKey removes any key',
    (apiKey) {
      final settings = FakeSettings();
      settings.apiKey = apiKey;
      expect(apiKey, settings.apiKey);

      removeApiKey(settings);

      expect('', settings.apiKey);
    },
  );
}
