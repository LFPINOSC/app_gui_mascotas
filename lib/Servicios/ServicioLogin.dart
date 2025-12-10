import 'dart:convert';
import 'package:http/http.dart';
class ServicioLogin {
  final apiUrl='http://172.18.74.40:8080/api/auth/login';

  Future<String> Login(String username, String password) async {
    final response = await post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['token'];
    } else {
      throw Exception('Failed to login');
    }
  }
}