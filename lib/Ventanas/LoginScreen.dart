import 'package:app_gui_mascotas/Servicios/ServicioLogin.dart';
import 'package:app_gui_mascotas/Ventanas/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage=FlutterSecureStorage();
  final service=ServicioLogin();
  bool _isLoading=false;

  Future<void> iniciarSesion() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await service.Login(
        _usernameController.text,
        _passwordController.text,
      );
      if (token != null && token.isNotEmpty) {
        await storage.write(key: 'token', value: token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage()),
        );
      } else {
        _mostrarError("Usuario o contraseña incorrectos");
      }
      await storage.write(key: 'token', value: token);
    } catch (e) {
      print('Error al iniciar sesión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Inicio de sesion')
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: iniciarSesion,
                    child: Text('Iniciar Sesión'),
                  ),
          ],
        ),
      )
    );
  }
}