class Raza {
  final int id;
  final String nombre;
  final String descripcion;

  Raza({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
