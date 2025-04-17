import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_eye_of_the_world/src/feature/main/presentation/chapters_screen.dart';
import 'package:the_eye_of_the_world/src/feature/main/presentation/game_screen.dart';
import 'package:the_eye_of_the_world/src/feature/main/presentation/main_screen.dart';

import '../src/feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: RouteValue.home.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MainScreen(key: UniqueKey()),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutQuart,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 350),
              ),
              routes: [
                GoRoute(
                  path: RouteValue.chapters.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: ChaptersScreen(key: UniqueKey()),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuart,
                          )),
                          child: child,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                ),
                GoRoute(
                  path: RouteValue.game.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: GameScreen(key: UniqueKey()),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuart,
                          )),
                          child: child,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
      ],
    ),
  ],
);
