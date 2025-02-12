import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
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

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

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
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: 30.0,
                  )),
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

        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
    final actors = actorsByMovie[movieId]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];
            return Container(
              padding: const EdgeInsets.all(8),
              width: 135,
              child: Column(
                children: [
                  FadeIn(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        height: 150,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    actor.name,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }),
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
