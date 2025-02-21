import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'config.dart';

class ApiClient {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> get(String endpoint) async {
    String? token = await _authService.getStoredToken();
    if (token == null) {
      token = await _authService.getAccessToken();
    }

    final response = await http.get(
      Uri.parse('${Config.sandboxBaseUrl}$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error en la petición: ${response.body}");
      return null;
    }
  }
}
