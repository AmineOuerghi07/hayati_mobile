import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/hayati_app.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:hayati/features/reminders/presentation/reminder_providers.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:material_ui/material_ui.dart';

import 'support/memory_auth_repository.dart';
import 'support/memory_habit_repository.dart';
import 'support/memory_settings_repository.dart';
import 'support/silent_reminder_scheduler.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpApp(
  WidgetTester tester,
  Size size, {
  AppPreferences? preferences,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWith(
          (ref) => preferences == null
              ? MemorySettingsRepository()
              : MemorySettingsRepository(initial: preferences),
        ),
        habitRepositoryProvider.overrideWith((ref) => MemoryHabitRepository()),
        completionRepositoryProvider.overrideWith(
          (ref) => MemoryCompletionRepository(),
        ),
        reminderCoordinatorProvider.overrideWith(
          (ref) => ReminderCoordinator(SilentReminderScheduler()),
        ),
        authRepositoryProvider.overrideWith((ref) => MemoryAuthRepository()),
      ],
      child: const HayatiApp(),
    ),
  );
  await _settle(tester);
}

void main() {
  testWidgets('wide windows use a navigation rail', (tester) async {
    await _pumpApp(tester, const Size(1200, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Nothing due today'), findsOneWidget);

    await tester.tap(find.text('Stats'));
    await _settle(tester);
    expect(find.text('This week'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await _settle(tester);
    expect(find.text('Language'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phones keep the bottom navigation bar', (tester) async {
    await _pumpApp(tester, const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('onboarding fits a landscape phone', (tester) async {
    await _pumpApp(
      tester,
      const Size(844, 390),
      preferences: AppPreferences.fallback,
    );

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('My life'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Start'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
