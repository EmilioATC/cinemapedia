import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/videos.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Movie>> getSimilarMovies(int id, {int page = 1} );

  Future<List<Video>> getYoutubeVideosById(int id);
}
