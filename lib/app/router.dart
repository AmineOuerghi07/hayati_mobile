import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/app_shell.dart';
import 'package:hayati/features/achievements/presentation/achievements_page.dart';
import 'package:hayati/features/auth/presentation/account_pages.dart';
import 'package:hayati/features/auth/presentation/sign_in_page.dart';
import 'package:hayati/features/habits/presentation/habit_detail_page.dart';
import 'package:hayati/features/habits/presentation/habit_editor_page.dart';
import 'package:hayati/features/habits/presentation/today_page.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_gate.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_page.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_redirect.dart';
import 'package:hayati/features/settings/presentation/archived_habits_page.dart';
import 'package:hayati/features/settings/presentation/settings_page.dart';
import 'package:hayati/features/stats/presentation/stats_page.dart';
import 'package:hayati/features/tools/presentation/breathe_page.dart';
import 'package:hayati/features/tools/presentation/focus_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

/// App navigation.
///
/// keepAlive because replacing the [GoRouter] clears the back stack. Locale
/// and theme are read by the app widget, not here, so changing them does
/// not rebuild this router. The introduction flag is the one exception:
/// finishing it or replaying it refreshes the redirect.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  ref.listen(onboardingFlagProvider, (previous, next) {
    if (previous != next) refresh.ping();
  });
  final started = ref.read(onboardingFlagProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: started == false ? '/onboarding' : '/today',
    refreshListenable: refresh,
    redirect: (context, state) {
      return onboardingRedirect(
        onboardingDone: ref.read(onboardingFlagProvider),
        location: state.uri.path,
      );
    },
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
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/archived',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ArchivedHabitsPage(),
      ),
      GoRoute(
        path: '/achievements',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AchievementsPage(),
      ),
      GoRoute(
        path: '/focus',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => slideUpPage(
          pageKey: state.pageKey,
          child: FocusPage(habitId: state.uri.queryParameters['habit']),
        ),
      ),
      GoRoute(
        path: '/breathe',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            slideUpPage(pageKey: state.pageKey, child: const BreathePage()),
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
        pageBuilder: (context, state) {
          return slideUpPage(
            pageKey: state.pageKey,
            child: const HabitEditorPage(),
          );
        },
      ),
      GoRoute(
        path: '/habits/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return slideUpPage(
            pageKey: state.pageKey,
            child: HabitEditorPage(habitId: state.pathParameters['id']),
          );
        },
      ),
      GoRoute(
        path: '/habits/:id',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return slideUpPage(
            pageKey: state.pageKey,
            child: HabitDetailPage(habitId: state.pathParameters['id']!),
          );
        },
      ),
    ],
  );
}
