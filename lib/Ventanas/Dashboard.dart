import 'package:app_gui_mascotas/Ventanas/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class DashboartPage extends StatefulWidget {

  @override
  State<DashboartPage> createState() => _DashboartPageState();
}

class _DashboartPageState extends State<DashboartPage> {
  final storage=FlutterSecureStorage();
  String? token;
  Future<void> validarToken() async {
    String? saveToken = await storage.read(key: 'token');
    if(saveToken==null){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }else{
      setState(()=> 
        this.token=saveToken
      );
    }
  }
  @override
  void initState() {
    super.initState();
    validarToken();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}