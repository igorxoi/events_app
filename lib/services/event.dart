import 'dart:convert';
import 'package:events_app/models/event.dart';
import 'package:http/http.dart' as http;

class EventService {
  // final String baseUrl = "https://api-events-ploc.onrender.com";
  final String baseUrl = "http://localhost:3000";

  Future<List<Event>> getEvents({int page = 1}) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/events?latitude=-23.56045&longitude=-46.63811&page=1&limit=10",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List eventsJson = data["data"];
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar os eventos: ${response.statusCode}");
    }
  }

  Future<List<Event>> getEventsByCategory({int category = 1}) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/events/category/$category?latitude=-23.56045&longitude=-46.63811&page=1&limit=10",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List eventsJson = data["data"];
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar os eventos: ${response.statusCode}");
    }
  }
}
