import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/hayati_app.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:hayati/features/reminders/presentation/reminder_providers.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:material_ui/material_ui.dart';

import 'support/memory_habit_repository.dart';
import 'support/memory_settings_repository.dart';
import 'support/silent_reminder_scheduler.dart';

void main() {
  testWidgets('an empty today offers to add a habit', (tester) async {
    await _pump(tester);
    expect(find.text('Nothing due today'), findsOneWidget);
    await tester.tap(find.text('Add habit'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Name'), findsOneWidget);
  });

  testWidgets('tapping the circle marks today done and undo clears it', (
    tester,
  ) async {
    final habits = MemoryHabitRepository();
    final completions = MemoryCompletionRepository();
    final habit = await habits.create(
      HabitDraft(
        name: 'Water',
        icon: 'water',
        colorKey: 'sea',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: CalendarDate.today().iso,
      ),
    );
    await _pump(tester, habits: habits, completions: completions);

    expect(find.text('Water'), findsOneWidget);
    await tester.tap(find.byTooltip('Water'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Marked done'), findsOneWidget);
    expect((await completions.watchForHabit(habit.id).first), isNotEmpty);

    await tester.tap(find.text('Undo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(await completions.watchForHabit(habit.id).first, isEmpty);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  MemoryHabitRepository? habits,
  MemoryCompletionRepository? completions,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWith(
          (ref) => MemorySettingsRepository(),
        ),
        habitRepositoryProvider.overrideWith(
          (ref) => habits ?? MemoryHabitRepository(),
        ),
        completionRepositoryProvider.overrideWith(
          (ref) => completions ?? MemoryCompletionRepository(),
        ),
        reminderCoordinatorProvider.overrideWith(
          (ref) => ReminderCoordinator(SilentReminderScheduler()),
        ),
      ],
      child: const HayatiApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}
