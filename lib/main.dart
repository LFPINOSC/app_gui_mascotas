import 'package:app_gui_mascotas/Temas/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Ventanas/Dashboard.dart';
import 'Ventanas/LoginScreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  final String? token = await storage.read(key: "token");

  runApp(MyApp(startOnHome: token != null));
}

class MyApp extends StatelessWidget {
  final bool startOnHome;

  const MyApp({super.key, required this.startOnHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: startOnHome ? DashboardPage() : LoginPage(),
    );
  }
}

