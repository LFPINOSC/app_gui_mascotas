import 'package:app_gui_mascotas/Auth/auth_session.dart';
import 'package:app_gui_mascotas/Configuracion/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Servicios/ServicioLogin.dart';

import 'Dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ServicioLogin service = ServicioLogin();

  bool _isLoading = false;
  Future<void> iniciarSesion() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _mostrarError("Complete todos los campos");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await service.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      final token = response['token'];
      final rol = response['rol'];

      // Guardar en memoria
      AuthSession.token = token;
      AuthSession.rol = rol;

      // Guardar persistente
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'rol', value: rol);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    } catch (_) {
      _mostrarError("Credenciales incorrectas");
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _configurarServidor() async {
    final controller = TextEditingController();
    controller.text = await AppConfig.getBaseUrl();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Configurar servidor API"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "URL del servidor",
            hintText: "http://IP:PUERTO/api",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Guardar"),
            onPressed: () async {
              final url = controller.text.trim();

              if (!url.startsWith("http")) {

                _mostrarError("URL inválida");
                return;
              }

              await AppConfig.setBaseUrl(url);

              if (mounted) Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Servidor configurado correctamente"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio de sesión"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Configurar servidor",
            onPressed: _configurarServidor,
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pets, size: 72),
                  const SizedBox(height: 20),

                  Text(
                    "Bienvenido",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Usuario",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: iniciarSesion,
                            child: const Text("Iniciar sesión"),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
