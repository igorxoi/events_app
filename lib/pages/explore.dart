import 'package:events_app/components/explore_card.dart';
import 'package:events_app/components/header.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/event.dart';
import 'package:flutter/material.dart';
import 'package:events_app/components/navbar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  late Future<List<Event>> eventsByCategoryFuture;

  List<Event> allEvents = [];
  List<Event> filteredEvents = [];

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadEvents(category: 1);
  }

  void _loadEvents({required int category}) async {
    final events = await EventService().getEventsByCategory(category: category);
    setState(() {
      allEvents = events ?? [];
      filteredEvents = events ?? [];
    });
  }

  void _filterEvents(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredEvents = allEvents
          .where((event) => event.name.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            onCategorySelected: (selectedCategory) {
              _loadEvents(category: selectedCategory);
            },
            onSearchTextChanged: _filterEvents,
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(child: Text('Nenhum evento encontrado'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return ExploreCard(
                        event: event,
                        onFavoriteToggled: () {
                          setState(() {
                            event.isFavorite = !event.isFavorite;
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
