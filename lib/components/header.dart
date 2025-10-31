import 'package:events_app/models/category.dart';
import 'package:events_app/services/category.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final Function(int) onCategorySelected;
  final Function(String) onSearchTextChanged;

  final int categorySelectedId;
  final String title;
  final String subtitle;
  final bool showFilters;

  const Header({
    super.key,
    this.onCategorySelected = _defaultOnCategorySelected,
    this.onSearchTextChanged = _defaultOnSearchTextChanged,
    this.categorySelectedId = 1,
    this.showFilters = true,
    this.title = 'Busque os eventos com facilidade!',
    this.subtitle =
        'Encontre o evento que quiser, onde quiser, no momento em que achar melhor.',
  });

  static void _defaultOnCategorySelected(int id) {}
  static void _defaultOnSearchTextChanged(String text) {}

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Future<List<Category>> categoriesFuture;
  final TextEditingController _searchController = TextEditingController();

  int? selectedCategoryId;
  String title = '';
  String subtitle = '';

  @override
  void initState() {
    super.initState();
    final categoriesService = CategoryService();
    categoriesFuture = categoriesService.getCategorie();

    title = widget.title;
    subtitle = widget.subtitle;
    selectedCategoryId = widget.categorySelectedId;

    _searchController.addListener(() {
      final text = _searchController.text;
      if (text != '') {
        widget.onSearchTextChanged(text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(33, 150, 243, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color.fromRGBO(144, 202, 249, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          if (widget.showFilters)
            SizedBox(
              height: 50,
              child: FutureBuilder<List<Category>>(
                future: categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhuma categoria encontrada');
                  }

                  final categories = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final bool isSelected = category.id == selectedCategoryId;

                      return Container(
                        margin: EdgeInsets.only(
                          right: index == categories.length - 1 ? 0 : 12,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              selectedCategoryId = category.id;
                            });
                            widget.onCategorySelected(category.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.white
                                : const Color.fromRGBO(21, 101, 192, 1),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color.fromRGBO(21, 101, 192, 1)
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          if (widget.showFilters)
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                top: 16,
                bottom: 32,
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Procure o evento pelo nome',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
