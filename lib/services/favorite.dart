import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:events_app/models/event.dart';

class FavoriteService {
  static const _key = 'favorites';

  Future<void> addFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    final encoded = jsonEncode(event.toJson());

    favorites.add(encoded);
    await prefs.setStringList(_key, favorites);
  }

  Future<void> removeFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    favorites.removeWhere((e) {
      final decoded = jsonDecode(e);
      return decoded['id'] == event.id;
    });

    await prefs.setStringList(_key, favorites);
  }

  Future<List<Event>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];

    return favorites.map((e) => Event.fromJson(jsonDecode(e))).toList();
  }
}
