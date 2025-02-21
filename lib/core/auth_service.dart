import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse(Config.authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'client_id': Config.clientId,
        'client_secret': Config.clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      await _storage.write(key: 'access_token', value: token);
      return token;
    } else {
      print("Error obteniendo token: ${response.body}");
      return null;
    }
  }

  Future<String?> getStoredToken() async {
    return await _storage.read(key: 'access_token');
  }
}
