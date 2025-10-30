import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.home, size: 24, color: Colors.blue),
              SizedBox(height: 4),
              Text('Home', style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.search, size: 24, color: Colors.blue),
              SizedBox(height: 4),
              Text('Search', style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.favorite, size: 24, color: Colors.blue),
              SizedBox(height: 4),
              Text('Favorites', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
