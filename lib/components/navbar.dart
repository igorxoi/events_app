import 'package:events_app/themes/colors.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context, Icons.home_outlined, "Home", 0),
          _buildNavItem(context, Icons.search, "Explorar", 1),
          _buildNavItem(context, Icons.favorite_border, "Favoritos", 2),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    String route = '/';

    switch (index) {
      case 0:
        route = '/';
        break;
      case 1:
        route = '/explore';
        break;
      case 2:
        route = '/favorite';
        break;
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        onItemTapped(index);
        _navigateToPage(context, index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: isSelected ? primaryColor : blackColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? primaryColor : blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
