import 'dart:convert';
import 'package:events_app/models/category.dart';
import 'package:events_app/config/environment.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = Environment.baseUrl;

  Future<List<Category>> getCategorie() async {
    final uri = Uri.http(baseUrl, "/categories", {
      "latitude": "-23.56045",
      "longitude": "-46.63811",
      "page": "1",
      "limit": "10",
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data["data"];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar as categorias: ${response.statusCode}");
    }
  }
}
