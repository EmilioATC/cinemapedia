import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(Duration(milliseconds: 300));
    isLoading = false;
  }
}

final moviesSimilarProvider =
    StateNotifierProvider.family<MoviesNotifierSimilar, AsyncValue<List<Movie>>, int>(
        (ref, int id) {
  final fetchMoviesSimilar =
      ref.watch(movieRepositoryProvider).getSimilarMovies;
  return MoviesNotifierSimilar(fetchMoviesSimilar: fetchMoviesSimilar, id: id);
});

typedef MoviesSimilarCallback = Future<List<Movie>> Function(int, {int page});

class MoviesNotifierSimilar extends StateNotifier<AsyncValue<List<Movie>>> {
  int currentPage = 0;
  bool isLoading = false;
  final int id;
  MoviesSimilarCallback fetchMoviesSimilar;

  MoviesNotifierSimilar({required this.fetchMoviesSimilar, required this.id})
      : super(const AsyncValue.loading()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    try {
      currentPage++;
      final movies = await fetchMoviesSimilar(id, page: currentPage);
      state = AsyncValue.data([...?state.value, ...movies]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      isLoading = false;
    }
  }
}
