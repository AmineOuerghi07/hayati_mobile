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

void main() {
  testWidgets('skip closes the introduction and opens today', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWith(
            (ref) => MemorySettingsRepository(initial: AppPreferences.fallback),
          ),
          habitRepositoryProvider.overrideWith(
            (ref) => MemoryHabitRepository(),
          ),
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('My life'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Nothing due today'), findsOneWidget);
  });
}
