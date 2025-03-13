import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const ActorsByMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
    final actors = actorsByMovie[movieId]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              final actor = actors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    FadeIn(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          actor.profilePath,
                          height: 160,
                          width: 115,
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
      ),
    );
  }
}
