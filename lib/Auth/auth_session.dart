class AuthSession {
  static String? token;
  static String? rol;

  static bool get esAdmin => rol == "ADMIN";
  static bool get esCliente => rol == "CLIENTE";
}