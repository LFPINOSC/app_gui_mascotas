import 'package:flutter/material.dart';
import '../Modelos/cita.dart';
import '../Modelos/mascota.dart';
import '../Servicios/cita_service.dart';

class CitaFormPage extends StatefulWidget {
  final Mascota mascota;

  const CitaFormPage({super.key, required this.mascota});

  @override
  State<CitaFormPage> createState() => _CitaFormPageState();
}

class _CitaFormPageState extends State<CitaFormPage> {
  final _descripcionCtrl = TextEditingController();
  DateTime _fecha = DateTime.now();
  final CitaService _service = CitaService();
  bool _saving = false;

  Future<void> _guardar() async {
    if (_descripcionCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese una descripción")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final cita = Cita(
        fecha: _fecha,
        descripcion: _descripcionCtrl.text,
        estado: EstadoCita.SOLICITADA,
        mascotaId: widget.mascota.id!, // ✅ AQUÍ ESTÁ LA CLAVE
      );

      await _service.crearCita(cita);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar la cita")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Cita")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descripcionCtrl,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Fecha de la cita"),
              subtitle: Text(
                _fecha.toLocal().toString().substring(0, 16),
              ),
              onTap: _seleccionarFecha,
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text("Guardar Cita"),
              onPressed: _saving ? null : _guardar,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (fecha == null) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fecha),
    );

    if (hora == null) return;

    setState(() {
      _fecha = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
    });
  }
}
