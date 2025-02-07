import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  StatefulShellRoute.indexedStack(
    builder: (context, state, StatefulNavigationShell navidationShell) {
      return CustomBottomNavigation(navigationShell: navidationShell,);
    },
    branches: [
      StatefulShellBranch(routes: <RouteBase>[
        GoRoute(
            path: '/',
            name: HomeScreen.name,
            builder: (context, state) => HomeView(),
            routes: [
              GoRoute(
                path: 'movie/:id',
                name: MovieScreen.name,
                builder: (context, state) {
                  final movieId = state.pathParameters['id'] ?? 'no-id';
                  return MovieScreen(movieId: movieId);
                },
              ),
            ]),
      ]),
      StatefulShellBranch(routes: <RouteBase>[
        GoRoute(
          path: '/categories',
          builder: (context, state) => FavoritesView(),
        )
      ]),
      StatefulShellBranch(routes: <RouteBase>[
        GoRoute(
          path: '/favorites',
          builder: (context, state) => FavoritesView(),
        )
      ]),
    ],
  )
  // Rutas padre/hijo
  // GoRoute(
  //     path: '/',
  //     name: HomeScreen.name,
  //     builder: (context, state) => const HomeScreen(childView: HomeView(),),
  //     routes: [
  //       GoRoute(
  //         path: 'movie/:id',
  //         name: MovieScreen.name,
  //         builder: (context, state) {
  //           final movieId = state.pathParameters['id'] ?? 'no-id';
  //           return MovieScreen(movieId: movieId);
  //         },
  //       ),
  //     ]),
]);
