import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'config.dart';

class ApiClient {
  final AuthService _authService = AuthService();

  Future<dynamic> get(String endpoint) async {
    String? token = await _authService.getStoredIdToken(); // ✅ Primero intentamos con `id_token`

    if (token == null) {
      token = await _authService.getStoredAccessToken(); // ✅ Si `id_token` no funciona, usamos `access_token`
    }

    if (token == null) {
      print("❌ No se pudo obtener un token válido.");
      return null;
    }

    print("🔑 Usando token: $token");  // 🔥 Verifica qué token se está enviando

    final String url = "${Config.sandboxBaseUrl}$endpoint";
    print("📌 Enviando petición a: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("📌 Respuesta de la API (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      print("🔄 Token inválido. Eliminando y solicitando uno nuevo...");
      await _authService.clearTokens();
      await _authService.fetchAndStoreTokens();
      return get(endpoint); // 🔄 Reintentar con un nuevo token
    } else {
      print("❌ Error en la petición: ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}
