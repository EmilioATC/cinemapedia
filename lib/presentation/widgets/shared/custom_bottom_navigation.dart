import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white10,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_max_outlined),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.label_outline),
          label: 'Categorías',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}