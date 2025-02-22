import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FavoriteButton extends StatefulWidget {
  final String itemId;  // ✅ Asegúrate de que itemId sea String

  const FavoriteButton({super.key, required this.itemId});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final supabase = Supabase.instance.client;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('item_id', widget.itemId)  // ✅ Asegúrate de que itemId sea String
        .maybeSingle();

    setState(() {
      _isFavorite = response != null;
    });
  }

  Future<void> _toggleFavorite() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    if (_isFavorite) {
      // ✅ Elimina el favorito
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('item_id', widget.itemId);
    } else {
      const uuid = Uuid();

      await supabase.from('favorites').insert({
        'user_id': userId,
        'item_id': widget.itemId.isNotEmpty ? widget.itemId : uuid.v4(),  // ✅ Genera un UUID si el ID es inválido
      });
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
