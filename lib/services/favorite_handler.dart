import 'package:flutter/material.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/favorite.dart';

class FavoriteHandlerService {
  Future<void> toggleFavorite({
    required BuildContext context,
    required Event event,
    VoidCallback? onFavoriteToggled,
  }) async {
    try {
      if (event.isFavorite) {
        await FavoriteService().removeFavorite(event);
      } else {
        await FavoriteService().addFavorite(event);
      }

      onFavoriteToggled?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            event.isFavorite
                ? "O evento ${event.name} foi adicionado aos favoritos!"
                : "O evento ${event.name} foi removido dos favoritos!",
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocorreu um erro ao atualizar favoritos."),
        ),
      );
    }
  }

  Future<void> applyFavoritesToEvents(List<Event> events) async {
    final favorites = await FavoriteService().getFavorites();
    final favoriteIds = favorites.map((e) => e.id).toSet();

    for (var event in events) {
      event.isFavorite = favoriteIds.contains(event.id);
    }
  }
}
