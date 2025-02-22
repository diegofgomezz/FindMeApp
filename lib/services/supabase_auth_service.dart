import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final _supabase = Supabase.instance.client;

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(email: email, password: password);
      return response.user?.id; // Retorna el ID del usuario si el login es exitoso
    } catch (error) {
      print("Error al iniciar sesión: $error");
      return null;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);
      return response.user?.id;
    } catch (error) {
      print("Error al registrar usuario: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  bool isUserLoggedIn() {
    return _supabase.auth.currentUser != null;
  }
}
