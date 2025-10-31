import 'package:events_app/components/event_card.dart';
import 'package:events_app/components/header_location.dart';
import 'package:events_app/components/navbar.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/event.dart';
import 'package:flutter/material.dart';

class EventSection extends StatefulWidget {
  final String title;
  final Future<List<Event>> future;

  const EventSection({required this.title, required this.future, super.key});

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  final ScrollController _scrollController = ScrollController();
  final List<Event> _events = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      _fetchEvents();
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final movieService = EventService();
      final newMovies = await movieService.getEvents(page: _currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _events.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _hasMore = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32, bottom: 8),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: _events.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _events.isEmpty
              ? const Center(child: Text("Nenhum evento encontrado"))
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _hasMore ? _events.length + 1 : _events.length,
                  padding: const EdgeInsets.only(right: 24),
                  itemBuilder: (context, index) {
                    if (index == _events.length) {
                      return const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final event = _events[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [EventCard(event: event)],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
  late final Future<List<Event>> eventsFuture;

  @override
  void initState() {
    super.initState();
    final eventsService = EventService();
    eventsFuture = eventsService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderLocation(),
          SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EventSection(title: 'Próximos eventos', future: eventsFuture),
                  EventSection(title: 'TEste', future: eventsFuture),
                  EventSection(title: 'Teste', future: eventsFuture),
                ],
              ),
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
