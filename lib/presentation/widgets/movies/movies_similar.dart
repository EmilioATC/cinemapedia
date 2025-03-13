import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesSimilar extends ConsumerStatefulWidget {
  final int movieId;
  const MoviesSimilar({super.key, required this.movieId});

  @override
  ConsumerState<MoviesSimilar> createState() => _MoviesSimilarState();
}

class _MoviesSimilarState extends ConsumerState<MoviesSimilar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesSimilarProvider(widget.movieId).notifier).loadNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final moviesSimilar = ref.watch(moviesSimilarProvider(widget.movieId));
    return moviesSimilar.when(
      data: (movies) => _MoviesList(
        movies: movies,
        loadNextPage: () => ref
            .read(moviesSimilarProvider(widget.movieId).notifier)
            .loadNextPage(),
      ),
      error: (_, __) =>
          const Center(child: Text('No se pudo cargar películas similares')),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _MoviesList extends StatelessWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;
  const _MoviesList({required this.movies, this.loadNextPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: MovieHorizontalListview(
          title: "Películas Similares",
          movies: movies,
          loadNextPage: loadNextPage ?? () {}),
    );
  }
}
