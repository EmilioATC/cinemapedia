import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieProvider, Map<String, List<Actor>>>(
        (ref) {
  final actorRepository = ref.watch(actorsRepositoryProvider);
  return ActorsByMovieProvider(getActor: actorRepository.getActorsByMovie);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieProvider extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActor;
  ActorsByMovieProvider({required this.getActor}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActor(movieId);

    state = {
      ...state,
      movieId: actors,
    };
  }
}
