import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) => {navigationShell.goBranch(index)},
        currentIndex: navigationShell.currentIndex,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
              size: 30,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(selectedIndex == 1 ? Icons.people : Icons.people_outline),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline),
              label: 'Favoritos'),
        ],
      ),
    );
  }
}
