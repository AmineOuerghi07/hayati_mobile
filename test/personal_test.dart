import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/auth/domain/data_choice.dart';
import 'package:hayati/features/auth/presentation/data_choice_sheet.dart';
import 'package:hayati/features/garden/domain/plant_stage.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/part_of_day.dart';
import 'package:hayati/features/recap/domain/weekly_recap.dart';
import 'package:hayati/features/recap/presentation/recap_page.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    theme: buildHayatiTheme(AppThemeId.hayati, Brightness.light),
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  test('a reminder hour fills in a missing part of day', () {
    expect(partOfDayAt(8), PartOfDay.morning);
    expect(partOfDayAt(13), PartOfDay.afternoon);
    expect(partOfDayAt(22), PartOfDay.evening);
    expect(
      resolvedPartOfDay(chosen: null, reminderMinutes: 8 * 60),
      PartOfDay.morning,
    );
    expect(
      resolvedPartOfDay(chosen: PartOfDay.evening, reminderMinutes: 8 * 60),
      PartOfDay.evening,
    );
    expect(resolvedPartOfDay(chosen: null, reminderMinutes: null), isNull);
  });

  test('plants grow from check-ins and streaks', () {
    expect(plantStage(checkIns: 0, bestStreak: 0), PlantStage.seed);
    expect(plantStage(checkIns: 1, bestStreak: 0), PlantStage.sprout);
    expect(plantStage(checkIns: 2, bestStreak: 3), PlantStage.bud);
    expect(plantStage(checkIns: 4, bestStreak: 7), PlantStage.bloom);
    expect(plantStage(checkIns: 10, bestStreak: 30), PlantStage.tree);
  });

  test('the weekly recap counts the last seven days', () {
    final habit = Habit(
      id: 'read',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      name: 'Read',
      icon: 'book',
      colorKey: 'dusk',
      type: HabitType.boolean,
      frequencyType: FrequencyType.daily,
      startDate: '2026-01-01',
    );
    final today = CalendarDate(2026, 1, 10);
    final recap = weeklyRecap(
      habits: [habit],
      completions: [
        HabitCompletion(
          id: 'a',
          createdAt: DateTime.utc(2026, 1, 10),
          updatedAt: DateTime.utc(2026, 1, 10),
          habitId: habit.id,
          date: today.iso,
          value: 1,
        ),
        HabitCompletion(
          id: 'old',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          habitId: habit.id,
          date: today.addDays(-20).iso,
          value: 1,
        ),
      ],
      today: today,
    );
    expect(recap.checkIns, 1);
    expect(recap.topHabitName, 'Read');
    expect(recap.grownPlants, 1);
    expect(recap.isEmpty, isFalse);
    expect(isFirstDayOfWeek(CalendarDate(2026, 1, 5), DateTime.monday), isTrue);
  });

  testWidgets('a new account offers to bring habits along or start fresh', (
    tester,
  ) async {
    DataChoice? picked;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              picked = await showDataChoiceSheet(
                context,
                here: const ScopeCounts(habits: 2, checkIns: 4),
                account: ScopeCounts.empty,
                accountHasData: false,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Keep both'), findsOneWidget);
    expect(find.text('Use the account'), findsNothing);
    await tester.tap(find.text('Keep both'));
    await tester.pumpAndSettle();
    expect(picked, DataChoice.merge);
  });

  testWidgets('the weekly recap opens on the check-in card', (tester) async {
    await tester.pumpWidget(
      _host(
        const RecapView(
          recap: WeeklyRecap(
            checkIns: 6,
            bestDay: null,
            bestDayCount: 0,
            topHabitName: 'Read',
            topHabitCount: 4,
            perfectDays: 1,
            averageMood: null,
            grownPlants: 2,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Check-ins'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
