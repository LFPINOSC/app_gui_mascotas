enum EstadoCita {
  SOLICITADA,
  AUTORIZADA,
  RECHAZADA,
  ATENDIDA,
  SUSPENDIDA,
  NO_ASISTE
}

class Cita {
  final int? id;
  final DateTime fecha;
  final String descripcion;
  final EstadoCita estado;
  final int mascotaId;

  Cita({
    this.id,
    required this.fecha,
    required this.descripcion,
    required this.estado,
    required this.mascotaId,
  });

  /// ⬇️ DESDE API
  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      descripcion: json['descripcion'],
      estado: EstadoCita.values
          .firstWhere((e) => e.name == json['estado']),
      fecha: DateTime.parse(json['fecha']),
      mascotaId: json['mascota']['id'],
    );
  }

  /// ⬆️ HACIA API
  Map<String, dynamic> toJson() {
    return {
      "fecha": fecha.toIso8601String(),
      "descripcion": descripcion,
      "estado": estado.name,
      "mascota": {
        "id": mascotaId,
      }
    };
  }
}
