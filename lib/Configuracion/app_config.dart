import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  static const _storage = FlutterSecureStorage();
  static const _keyBaseUrl = 'base_url';

  static const String defaultBaseUrl =
      "http://172.18.74.180:8080/api";

  static Future<String> getBaseUrl() async {
    return await _storage.read(key: _keyBaseUrl) ?? defaultBaseUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    await _storage.write(key: _keyBaseUrl, value: url);
  }
}
