import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:events_app/models/event.dart';

class FavoriteService {
  static const _key = 'favorites';

  /// Adiciona um evento aos favoritos
  Future<void> addFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    // Verifica se já existe antes de adicionar
    final encoded = jsonEncode(event.toJson());
    if (!favorites.contains(encoded)) {
      favorites.add(encoded);
      await prefs.setStringList(_key, favorites);
    }
  }

  /// Remove um evento dos favoritos
  Future<void> removeFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    favorites.removeWhere((e) {
      final decoded = jsonDecode(e);
      return decoded['id'] == event.id;
    });

    await prefs.setStringList(_key, favorites);
  }

  /// Retorna todos os favoritos
  Future<List<Event>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.map((e) => Event.fromJson(jsonDecode(e))).toList();
  }

  /// Verifica se um evento já é favorito
  Future<bool> isFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.any((e) {
      final decoded = jsonDecode(e);
      return decoded['name'] == event.name; // use um ID se tiver
    });
  }
}
