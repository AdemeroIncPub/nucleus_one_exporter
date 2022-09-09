import 'package:nucleus_one_exporter/application/settings.dart';

class FakeStorageBoxWrapper implements StorageBoxWrapper {
  final _data = <String, String>{};

  @override
  String operator [](String key) {
    return _data[key] ?? '';
  }

  @override
  void operator []=(String key, String value) {
    _data[key] = value;
  }
}
