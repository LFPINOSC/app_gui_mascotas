import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<String> get baseUrl async {
    return await AppConfig.getBaseUrl();
  }


  Future<Map<String, String>> authHeaders() async {
    final token = await storage.read(key: 'token');

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}

