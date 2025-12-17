import 'dart:convert';
import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:http/http.dart';
import '../Modelos/cita.dart';
import 'api_service.dart';

class CitaService extends ApiService {

  Future<List<Cita>> obtenerCitasPorMascota(int mascotaId) async {
    final url = "${await AppConfig.getBaseUrl()}/citas/mascota/$mascotaId";

    final response = await get(
      Uri.parse(url),
      headers: await authHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> citasJson = jsonDecode(response.body);

      print("📅 Citas JSON directas: $citasJson");

      return citasJson.map((e) {
        return Cita.fromJson({
          ...e,
          "mascota": {"id": mascotaId}
        });
      }).toList();
    } else {
      throw Exception("Error al cargar citas");
    }
  }



  Future<void> crearCita(Cita cita) async {
    final url = "${await AppConfig.getBaseUrl()}/citas";

    final response = await post(
      Uri.parse(url),
      headers: await authHeaders(),
      body: jsonEncode(cita.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al crear cita");
    }
  }
}
