import 'dart:convert';
import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:http/http.dart';
class ServicioLogin {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final baseUrl = await AppConfig.getBaseUrl();

    final response = await post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'correo': username,
        'clave': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

}