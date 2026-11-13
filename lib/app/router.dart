import 'package:go_router/go_router.dart';
import 'package:hayati/app/app_shell.dart';
import 'package:hayati/features/habits/presentation/today_page.dart';
import 'package:hayati/features/settings/presentation/settings_page.dart';
import 'package:hayati/features/stats/presentation/stats_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// App navigation.
///
/// keepAlive because replacing the [GoRouter] clears the back stack. Locale
/// and theme are read by the app widget, not here, so changing them does
/// not rebuild this router.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
