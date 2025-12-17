import 'dart:convert';
import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:app_gui_mascotas/Modelos/raza.dart';
import 'package:app_gui_mascotas/Servicios/api_service.dart';
import 'package:http/http.dart' as http;

class RazaService extends ApiService {

  Future<List<Raza>> obtenerRazas() async {
    final headers = await authHeaders();
    final baseUrl = await AppConfig.getBaseUrl();
    final response = await http.get(
      Uri.parse("${baseUrl}/razas"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Raza.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar razas");
    }
  }

  Future<void> crearRaza(Raza raza) async {
    final headers = await authHeaders();
    final baseUrl = await AppConfig.getBaseUrl();
    final response = await http.post(
      Uri.parse("${baseUrl}/razas"),
      headers: headers,
      body: jsonEncode({
        "nombre": raza.nombre,
        "descripcion": raza.descripcion,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear raza");
    }
  }
}
