import 'package:flutter/material.dart';
import '../services/favourite_service.dart';
import '../favouriteButton.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoriteService = FavoriteService();
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favorites = await _favoriteService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Favoritos")),
      body: _favorites.isEmpty
          ? const Center(child: Text("No tienes favoritos guardados"))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Elemento ${_favorites[index]}"),
                  trailing: FavoriteButton(itemId: _favorites[index]),
                );
              },
            ),
    );
  }
}
