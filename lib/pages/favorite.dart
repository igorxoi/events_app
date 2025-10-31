import 'package:events_app/components/explore_card.dart';
import 'package:events_app/components/header.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/favorite.dart';
import 'package:events_app/services/favorite_handler.dart';
import 'package:flutter/material.dart';
import 'package:events_app/components/navbar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  List<Event> events = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    final favoriteEvents = await FavoriteService().getFavorites();
    FavoriteHandlerService().applyFavoritesToEvents(favoriteEvents);

    setState(() {
      events = favoriteEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            title: 'Estes são seus eventos favoritos!',
            subtitle: 'Recorde memórias e organize seus momentos de lazer.',
            showFilters: false,
          ),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('Nenhum evento encontrado'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ExploreCard(
                        event: event,
                        onFavoriteToggled: () {
                          setState(() {
                            event.isFavorite = !event.isFavorite;
                            _loadEvents();
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
