import 'dart:convert';
import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:app_gui_mascotas/Modelos/mascota.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class MascotaService extends ApiService {


  Future<List<Mascota>> obtenerMisMascotas() async {
    final baseUrl = await AppConfig.getBaseUrl();
    final headers = await authHeaders();

    final response = await http.get(
      Uri.parse("${baseUrl}/mascotas"),
      headers: headers,
    );
    print("🔵 STATUS CODE: ${response.statusCode}");
    print("🔵 RESPONSE BODY: ${response.body}");
    print("🔵 RESPONSE HEADERS: ${response.headers}");
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Mascota.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar mascotas");
    }
  }

  Future<void> crearMascota(Mascota mascota) async {
    final headers = await authHeaders();
    final baseUrl = await AppConfig.getBaseUrl();

    final response = await http.post(
      Uri.parse("${baseUrl}/mascotas"),
      headers: headers,
      body: jsonEncode(mascota.toJsonCreate()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear mascota");
    }
  }
}
