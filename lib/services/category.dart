import 'dart:convert';
import 'package:events_app/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  // final String baseUrl = "https://api-events-ploc.onrender.com";
  final String baseUrl = "http://localhost:3000";

  Future<List<Category>> getCategorie() async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/categories?latitude=-23.56045&longitude=-46.63811&page=1&limit=10",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data["data"];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar as categorias: ${response.statusCode}");
    }
  }
}
