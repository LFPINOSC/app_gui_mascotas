import 'raza.dart';

class Mascota {
  final int? id;
  final String nombre;
  final Raza raza;

  Mascota({
    this.id,
    required this.nombre,
    required this.raza,
  });

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      id: json['id'],
      nombre: json['nombre'],
      raza: Raza.fromJson(json['raza']),
    );
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      "nombre": nombre,
      "raza": {
        "id": raza.id
      }
    };
  }
}
