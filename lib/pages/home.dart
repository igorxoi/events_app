import 'package:events_app/components/event_card.dart';
import 'package:events_app/components/header_location.dart';
import 'package:events_app/components/navbar.dart';
import 'package:events_app/models/event.dart';
import 'package:events_app/services/event.dart';
import 'package:events_app/services/favorite_handler.dart';
import 'package:events_app/themes/colors.dart';
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
    // first try to load the provided future (useful for mocked data)
    _loadInitialFromFuture();
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
      final eventService = EventService();
      final newEvents = await eventService.getEvents(
        page: _currentPage,
        limit: 10,
      );

      FavoriteHandlerService().applyFavoritesToEvents(newEvents);

      setState(() {
        if (newEvents.isEmpty) {
          _hasMore = false;
        } else {
          _events.addAll(newEvents);
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

  Future<void> _loadInitialFromFuture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final initial = await widget.future;
      FavoriteHandlerService().applyFavoritesToEvents(initial);

      setState(() {
        if (initial.isEmpty) {
          _hasMore = false;
        } else {
          _events.addAll(initial);
          // since we already loaded page 1 (or a chunk), start fetching from page 2
          _currentPage = 2;
        }
      });
    } catch (e) {
      // ignore - keep existing behavior of trying to fetch later
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
              color: blackColor,
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
                        children: [
                          EventCard(
                            event: event,
                            onFavoriteToggled: () {
                              setState(() {
                                event.isFavorite = !event.isFavorite;
                              });
                            },
                          ),
                        ],
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
  // Use Futures for each section. Initialize with mocked data to avoid
  // late-initialization errors and to make the UI show predictable content.
  late Future<List<Event>> trendingEventsFuture;
  late Future<List<Event>> upcomingEventsFuture;
  late Future<List<Event>> allEventsFuture;

  List<Event> _mockEvents() {
    final address1 = Address(
      zipCode: '01000-000',
      street: 'Av. Paulista',
      number: '1000',
      logradouro: 'Av. Paulista',
      neighborhood: 'Bela Vista',
      city: 'São Paulo',
      state: 'SP',
      latitude: -23.561414,
      longitude: -46.655881,
    );

    final address2 = Address(
      zipCode: '20000-000',
      street: 'Rua das Flores',
      number: '250',
      logradouro: 'Rua das Flores',
      neighborhood: 'Centro',
      city: 'Rio de Janeiro',
      state: 'RJ',
      latitude: -22.906846,
      longitude: -43.172896,
    );

    return [
      Event(
        id: 1,
        categoryId: 1,
        name: 'Show de Jazz no Parque',
        startTime: '19:00',
        endTime: '22:00',
        date: '2025-11-20',
        address: address1,
        descricao: 'Uma noite de jazz ao ar livre com artistas locais.',
        distance: '2,5 km',
        distanceInMeters: 2500.0,
      ),
      Event(
        id: 2,
        categoryId: 2,
        name: 'Feira de Tecnologia',
        startTime: '09:00',
        endTime: '18:00',
        date: '2025-11-22',
        address: address2,
        descricao: 'Principais novidades em tecnologia e inovação.',
        distance: '5,0 km',
        distanceInMeters: 5000.0,
      ),
      Event(
        id: 3,
        categoryId: 3,
        name: 'Stand-up Comedy',
        startTime: '21:00',
        endTime: '23:00',
        date: '2025-11-25',
        address: address1,
        descricao: 'Os melhores comediantes da região no mesmo palco.',
        distance: '3,2 km',
        distanceInMeters: 3200.0,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    // initialize futures with mocked data so they are always defined
    final mock = _mockEvents();
    trendingEventsFuture = Future.value(mock);
    upcomingEventsFuture = Future.value(mock.reversed.toList());
    allEventsFuture = Future.value(mock);
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
                  EventSection(title: 'Em Alta', future: trendingEventsFuture),
                  SizedBox(height: 32),
                  EventSection(
                    title: 'Próximos Eventos',
                    future: upcomingEventsFuture,
                  ),
                  SizedBox(height: 32),
                  EventSection(
                    title: 'Todos os Eventos',
                    future: allEventsFuture,
                  ),
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
