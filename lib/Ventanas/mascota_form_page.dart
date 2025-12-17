import 'package:app_gui_mascotas/Temas/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:app_gui_mascotas/Modelos/mascota.dart';
import 'package:app_gui_mascotas/Modelos/raza.dart';
import 'package:app_gui_mascotas/Servicios/mascota_service.dart';
import 'package:app_gui_mascotas/Servicios/raza_service.dart';

class MascotaFormPage extends StatefulWidget {
  @override
  State<MascotaFormPage> createState() => _MascotaFormPageState();
}

class _MascotaFormPageState extends State<MascotaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  final RazaService _razaService = RazaService();
  final MascotaService _mascotaService = MascotaService();

  List<Raza> _razas = [];
  Raza? _razaSeleccionada;
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarRazas();
  }


  Future<void> _cargarRazas() async {
    try {
      final data = await _razaService.obtenerRazas();
      setState(() {
        _razas = data;
        _cargando = false;
      });
    } catch (_) {
      setState(() => _cargando = false);
      _mensaje("Error al cargar razas");
    }
  }


  Future<void> _guardarMascota() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final mascota = Mascota(
      nombre: _nombreController.text.trim(),
      raza: _razaSeleccionada!,
    );

    try {
      await _mascotaService.crearMascota(mascota);

      _mensaje("Mascota registrada correctamente");
      Navigator.pop(context, true);
    } catch (_) {
      _mensaje("Error al guardar mascota");
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Mascota"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        child: Icon(
                          Icons.pets,
                          size: 40,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Información de la mascota",
                      style: AppTextStyles.title,
                    ),

                    const SizedBox(height: 20),

                 
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: "Nombre de la mascota",
                        prefixIcon: Icon(Icons.edit),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Ingrese el nombre"
                              : null,
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<Raza>(
                      decoration: const InputDecoration(
                        labelText: "Raza",
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _razaSeleccionada,
                      items: _razas.map((r) {
                        return DropdownMenuItem<Raza>(
                          value: r,
                          child: Text(r.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _razaSeleccionada = value);
                      },
                      validator: (value) =>
                          value == null ? "Seleccione una raza" : null,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: _guardando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _guardando
                              ? "Guardando..."
                              : "Guardar Mascota",
                        ),
                        onPressed: _guardando ? null : _guardarMascota,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }


  void _mensaje(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}
