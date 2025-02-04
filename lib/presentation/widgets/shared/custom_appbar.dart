import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/movie.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final title = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: colors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Cinemapedia',
                  style: title,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      //final movieRepository = ref.read(movieRepositoryProvider);
                      final searchQuery = ref.watch(searchQueryProvider);

                      final movie = await showSearch<Movie?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchMovieDelegate(
                          searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                        ),
                      );

                      if (movie == null || !context.mounted) return;
                      {
                        GoRouter.of(context).go('/movie/${movie.id}');
                      }
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
          ),
        ));
  }
}
