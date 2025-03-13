import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/actors_movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_similar.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/helpers/human_formats.dart';
import '../../providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeAlign: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,
          ))
        ],
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _MovieDetails extends ConsumerWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    final isFavoriteMovie = ref.watch(isFavoriteProvider(movie.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Poster

        SizedBox(
          height: size.height * 0.3,
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) return const SizedBox();
              return FadeIn(child: child);
            },
          ),
        ),
        //*Título
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: textStyles.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text(
                      '${movie.releaseDate!.year}-${movie.releaseDate!.month}-${movie.releaseDate!.day}',
                      style: textStyles.bodyLarge,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.star_half_outlined,
                        color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyLarge
                            ?.copyWith(color: Colors.yellow.shade900)),
                  ],
                ),
              ),
            ],
          ),
        ),
        //*Iconos
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    // await ref
                    //     .read(localStorageRepositoryProvider)
                    //     .toggleFavorite(movie);

                    await ref
                        .read(favoriteMoviesProvider.notifier)
                        .toggleFavorite(movie);

                    ref.invalidate(isFavoriteProvider(movie.id));
                  },
                  icon: isFavoriteMovie.when(
                      data: (isFavorite) => isFavorite
                          ? const Icon(Icons.favorite_rounded,
                              color: Colors.pink, size: 30.0)
                          : const Icon(Icons.favorite_outline, size: 30.0),
                      error: (_, __) => throw UnimplementedError(),
                      loading: () => const CircularProgressIndicator(
                            strokeWidth: 2,
                          ))),
              // icon: Icon(
              //   Icons.favorite,
              //   color: Colors.pink,
              //   size: 30.0,
              // )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share_outlined,
                    size: 30.0,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.airplay_rounded,
                    size: 30.0,
                  )),
            ],
          ),
        ),
        //*Línea
        const Divider(
          height: 10,
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 221, 220, 220),
        ),

        //*Sinopsis
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      width: size.width * 0.3,
                    )),
              ),
              const SizedBox(width: 10),
              SizedBox(
                  width: (size.width - 50) * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(movie.overview)],
                  ))
            ],
          ),
        ),

        //*Generos de la películas
        Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              children: [
                ...movie.genreIds.map((gender) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Chip(
                        elevation: 5,
                        padding: const EdgeInsets.all(2),
                        shadowColor: Colors.black,
                        label: Text(
                          gender,
                          style: TextStyle(fontSize: 12),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ))
              ],
            ),
          ),
        ),

        SizedBox(
          height: 10,
        ),

        DefaultTabController(
            length: 3,
            child: TabMovie(
              movie: movie,
            )),

        //*Línea
        // const Divider(
        //   height: 10,
        //   thickness: 1,
        //   indent: 10,
        //   endIndent: 10,
        //   color: Color.fromARGB(31, 170, 170, 170),
        // ),
      ],
    );
  }
}

class TabMovie extends StatelessWidget {
  final Movie movie;
  const TabMovie({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        PreferredSize(
          preferredSize: Size.fromHeight(300),
          child: Material(
            textStyle: TextStyle(fontSize: 50),
            child: TabBar(
                labelStyle: TextStyle(fontSize: 15), // Texto seleccionado
                unselectedLabelStyle: TextStyle(fontSize: 14),
                tabs: [
                  Tab(child: Center(child: Text('Detalles'))),
                  Tab(
                    child: Center(child: Text('Más títulos similares')),
                  ),
                  Tab(child: Center(child: Text('Trailer'))),
                ]),
          ),
        ),
        Column(
          children: [
            SizedBox(
                height: size.height * 0.6,
                child: TabBarView(children: [
                  Column(children: [
                    //*Actores
                    ActorsByMovie(movieId: movie.id.toString()),
                  ]),
                  Column(
                    children: [
                      //*Películas Recomendadas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MoviesSimilar(movieId: movie.id),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      //*Trailer
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        child: VideoTrailer(movieId: movie.id),
                      ),
                    ],
                  ),
                ])),
          ],
        )
      ],
    );
  }
}

class VideoTrailer extends StatefulWidget {
  final int movieId;
  const VideoTrailer({super.key, required this.movieId});

  @override
  State<VideoTrailer> createState() => _VideoTrailerState();
}

class _VideoTrailerState extends State<VideoTrailer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Asegura que AutomaticKeepAlive funcione
    return Center(
      child: VideosMovie(movieId: widget.movieId),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, ref) {
    final bool isDarkmode = ref.watch(themeNotifierProvider).isDarkMode;
    return SliverAppBar(
      floating: true,
      expandedHeight: 10,
      actions: [
        IconButton(
          onPressed: () {
            ref.read(themeNotifierProvider.notifier).toggleDarkMode();
          },
          icon: Icon(isDarkmode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined),
        )
      ],
    );
  }
}
