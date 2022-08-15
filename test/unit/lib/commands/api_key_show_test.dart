import 'package:glados/glados.dart';
import 'package:nucleus_one_exporter/application/commands/api_key_show.dart';

import '../../../_internal/fakes.dart';
import '../../../_internal/generators.dart';

void main() {
  Glados(any.printableAscii).test(
    'showApiKey returns any key',
    (apiKey) {
      final settings = FakeSettings();
      expect('', showApiKey(settings));

      settings.apiKey = apiKey;

      expect(apiKey, showApiKey(settings));
    },
  );
}
