import 'dart:async';
import 'package:app_gui_mascotas/Temas/app_text_styles.dart';
import 'package:app_gui_mascotas/Ventanas/citas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:app_gui_mascotas/Modelos/mascota.dart';
import 'package:app_gui_mascotas/Servicios/mascota_service.dart';
import 'package:app_gui_mascotas/Ventanas/LoginScreen.dart';
import 'package:app_gui_mascotas/Ventanas/mascota_form_page.dart';



class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final storage = FlutterSecureStorage();
  final MascotaService _mascotaService = MascotaService();

  Timer? _timer;
  int _remainingSeconds = 0;

  List<Mascota> _mascotas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initTokenTimer();
    _cargarMascotas();
  }


  Future<void> _initTokenTimer() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      _logout();
      return;
    }

    final decoded = Jwt.parseJwt(token);
    final exp = decoded['exp'];

    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    _remainingSeconds =
        expirationDate.difference(DateTime.now()).inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _logout();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String _formatTime(int s) =>
      "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";

 

  Future<void> _cargarMascotas() async {
    try {
      final data = await _mascotaService.obtenerMisMascotas();
      setState(() {
        _mascotas = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }


  void _logout() async {
    _timer?.cancel();
    await storage.delete(key: "token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (_) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: _logout,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Registrar mascota",
        child: const Icon(Icons.pets),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MascotaFormPage()),
          );

          if (result == true) {
            _cargarMascotas();
          }
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ⏱ TOKEN
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: 8),
                Text(
                  "Token expira en ${_formatTime(_remainingSeconds)}",
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),

        
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _mascotas.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _mascotas.length,
                        itemBuilder: (_, i) {
                          final m = _mascotas[i];
                          return _mascotaCard(m);
                        },
                      ),
          ),
        ],
      ),
    );
  }



  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.pets_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No tienes mascotas registradas",
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }

  Widget _mascotaCard(Mascota m) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.pets)),
      title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Raza: ${m.raza.nombre}"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CitasPage(mascota: m),
          ),
        );
      },
    ),
  );
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
