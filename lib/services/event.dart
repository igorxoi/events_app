import 'package:events_app/models/event.dart';
import 'package:events_app/mocks/events_mock.dart';

class EventService {
  Future<List<Event>> getEvents({int page = 1, int limit = 10}) async {
    return Future.delayed(
      const Duration(milliseconds: 800),
      () => getMockedEvents(),
    );
  }

  Future<List<Event>> getTrendingEvents({int page = 1, int limit = 10}) async {
    return Future.delayed(
      const Duration(milliseconds: 800),
      () => getMockedTrendingEvents(),
    );
  }

  Future<List<Event>> getUpcomingEvents({int page = 1, int limit = 10}) async {
    return Future.delayed(
      const Duration(milliseconds: 800),
      () => getMockedUpcomingEvents(),
    );
  }

  Future<List<Event>> getEventsByCategory({
    int category = 1,
    int page = 1,
    int limit = 10,
  }) async {
    return Future.delayed(
      const Duration(milliseconds: 800),
      () => getMockedEvents()
          .where((event) => event.categoryId == category)
          .toList(),
    );
  }
}
