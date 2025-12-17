import 'package:flutter/material.dart';
import '../Modelos/mascota.dart';
import '../Modelos/cita.dart';
import '../Servicios/cita_service.dart';
import 'cita_form_page.dart';

class CitasPage extends StatefulWidget {
  final Mascota mascota;

  const CitasPage({super.key, required this.mascota});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final CitaService _service = CitaService();

  List<Cita> _citas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  Future<void> _cargarCitas() async {
    try {
      final data =
          await _service.obtenerCitasPorMascota(widget.mascota.id!);

      setState(() {
        _citas = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Citas de ${widget.mascota.nombre}"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CitaFormPage(mascota: widget.mascota),
            ),
          );
          if (result == true) _cargarCitas();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _citas.isEmpty
              ? const Center(child: Text("No hay citas registradas"))
              : ListView.builder(
                  itemCount: _citas.length,
                  itemBuilder: (_, i) {
                    final c = _citas[i];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(c.descripcion),
                        subtitle: Text(
                          "${_formatoFecha(c.fecha)} • ${c.estado.name}",
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatoFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }
}
