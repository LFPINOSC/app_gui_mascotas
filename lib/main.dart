import 'package:app_gui_mascotas/Ventanas/Dashboard.dart';
import 'package:app_gui_mascotas/Ventanas/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  runApp(MyApp(startOnHome: token != null));
}

class MyApp extends StatelessWidget {
  final bool startOnHome;
  const MyApp({required this.startOnHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: startOnHome ? DashboardPage() : LoginPage(),
    );
  }
}

