import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {

final StatefulNavigationShell navigationShell;

  const CustomBottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) => navigationShell.goBranch(index),
        currentIndex: navigationShell.currentIndex,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_rounded), label: 'Categorías'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
        ],
      ),
    );
    // NavigationBar(
    //   elevation: 0,
    //   backgroundColor: Colors.white10,
    //   destinations: const [
    //     NavigationDestination(
    //       icon: Icon(Icons.home_max_outlined),
    //       label: 'Inicio',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.label_outline),
    //       label: 'Categorías',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.favorite_outline),
    //       label: 'Favoritos',
    //     ),
    //   ],
    // );
  }
}
