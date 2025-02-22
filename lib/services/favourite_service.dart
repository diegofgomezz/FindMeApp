import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteService {
  final supabase = Supabase.instance.client;

  Future<void> toggleFavorite(String itemId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Verifica si ya está en favoritos
    final existing = await supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('item_id', itemId)
        .maybeSingle();

    if (existing != null) {
      // Elimina si ya está en favoritos
      await supabase
          .from('favorites')
          .delete()
          .eq('id', existing['id']);
    } else {
      // Agrega si no está en favoritos
      await supabase.from('favorites').insert({
        'user_id': userId,
        'item_id': itemId,
      });
    }
  }

  Future<List<String>> getFavorites() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('favorites')
        .select('item_id')
        .eq('user_id', userId);

    return response.map((fav) => fav['item_id'] as String).toList();
  }
}
