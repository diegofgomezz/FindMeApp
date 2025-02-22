import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  /// ✅ Obtener un nuevo `id_token` y `access_token`
  Future<void> fetchAndStoreTokens() async {
    final url = Uri.parse(Config.authUrl);
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('${Config.clientId}:${Config.clientSecret}'));

    final headers = {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'grant_type': 'client_credentials',
      'scope': 'technology.catalog.read openid', // 🔥 Asegurar que `openid` está incluido
    };

    print("📌 Enviando petición de token a: $url");

    final response = await http.post(url, headers: headers, body: body);

    print("📌 Respuesta del servidor (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('id_token')) {
        await _storage.write(key: 'id_token', value: data['id_token']);
        print("🔑 `id_token` almacenado correctamente.");
      } else {
        print("⚠️ Advertencia: No se recibió `id_token`.");
      }

      if (data.containsKey('access_token')) {
        await _storage.write(key: 'access_token', value: data['access_token']);
        print("🔑 `access_token` almacenado correctamente.");
      } else {
        print("⚠️ Advertencia: No se recibió `access_token`.");
      }
    } else {
      print("❌ Error obteniendo token: ${response.statusCode} - ${response.body}");
    }
  }

  /// ✅ Recuperar el `id_token` almacenado
  Future<String?> getStoredIdToken() async {
    return await _storage.read(key: 'id_token');
  }

  /// ✅ Recuperar el `access_token` almacenado
  Future<String?> getStoredAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// ✅ Borrar tokens para obtener uno nuevo
  Future<void> clearTokens() async {
    await _storage.delete(key: 'id_token');
    await _storage.delete(key: 'access_token');
    print("🧹 Tokens eliminados.");
  }
}
