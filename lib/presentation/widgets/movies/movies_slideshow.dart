import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 229,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.9,
        scale: 0.95,
        autoplay: true,
        pagination: SwiperPagination(
            margin: const EdgeInsets.only(top:0),
            builder: DotSwiperPaginationBuilder(
                activeColor: colors.primary, color: colors.secondary)),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movie: movies[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: const Offset(0, 10),
        ),
      ],
    );

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: DecoratedBox(
          decoration: decoration,
          child: FadeIn(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('assets/loaders/action-movie.gif'),
                      image: NetworkImage(movie.backdropPath),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 15, top: 110),
          child: SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: GestureDetector(
                onTap: () => context.push('/movie/${movie.id}'),
                child: FadeInImage(
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder:
                        const AssetImage('assets/loaders/action-movie.gif'),
                    image: NetworkImage(movie.posterPath)),
              ),
            ),
          ),
        ),
      
    ]);
  }
}
