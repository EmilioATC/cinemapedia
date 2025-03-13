import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;
  bool iconFavorite = true;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  void favoriteIcon() {
    setState(() {
      iconFavorite = !iconFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoriteMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(iconFavorite == false
                  ? Icons.favorite_outline
                  : Icons.favorite),
              iconSize: 60,
              color: Colors.pink,
              onPressed: () => favoriteIcon(),
            ),
            Padding(
              padding: const EdgeInsets.all(38.0),
              child: const Text(
                  'Para guardar películas, presiona el icono de corazón',
                  style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
                onPressed: () => context.go("/"),
                child: const Text('Empieza a buscar'))
          ],
        ),
      );
    }
    return Scaffold(
        body: MovieMasonry(
            loadNextPage: () => loadNextPage(), movies: favoriteMovies));
  }
}
