import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
                height: 180,
                fit: BoxFit.cover,
                placeholder:
                    const AssetImage('assets/loaders/action-movie.gif'),
                image: NetworkImage(movie.posterPath))),
      ),
    );
  }
}
