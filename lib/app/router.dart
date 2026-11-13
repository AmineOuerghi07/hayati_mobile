import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/app_shell.dart';
import 'package:hayati/features/auth/presentation/account_pages.dart';
import 'package:hayati/features/auth/presentation/sign_in_page.dart';
import 'package:hayati/features/habits/presentation/habit_detail_page.dart';
import 'package:hayati/features/habits/presentation/habit_editor_page.dart';
import 'package:hayati/features/habits/presentation/today_page.dart';
import 'package:hayati/features/settings/presentation/settings_page.dart';
import 'package:hayati/features/stats/presentation/stats_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// App navigation.
///
/// keepAlive because replacing the [GoRouter] clears the back stack. Locale
/// and theme are read by the app widget, not here, so changing them does
/// not rebuild this router.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
      GoRoute(
        path: '/auth/sign-in',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/auth/otp',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OtpPage(),
      ),
      GoRoute(
        path: '/auth/forgot',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/auth/change-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/habits/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HabitEditorPage(),
      ),
      GoRoute(
        path: '/habits/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return HabitEditorPage(habitId: state.pathParameters['id']);
        },
      ),
      GoRoute(
        path: '/habits/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return HabitDetailPage(habitId: state.pathParameters['id']!);
        },
      ),
    ],
  );
}
