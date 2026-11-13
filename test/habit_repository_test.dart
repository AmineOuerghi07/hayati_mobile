import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/data/drift_completion_repository.dart';
import 'package:hayati/features/habits/data/drift_habit_repository.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/settings/data/drift_settings_repository.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';

void main() {
  late AppDatabase database;
  late DriftHabitRepository habits;
  late DriftCompletionRepository completions;
  late DriftSettingsRepository settings;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    habits = DriftHabitRepository(database);
    completions = DriftCompletionRepository(database);
    settings = DriftSettingsRepository(database);
  });

  tearDown(() => database.close());

  test('creating, completing, reordering, and deleting a habit', () async {
    final first = await habits.create(
      const HabitDraft(
        name: 'Water',
        icon: 'water',
        colorKey: 'sea',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: '2026-03-01',
      ),
    );
    final second = await habits.create(
      const HabitDraft(
        name: 'Read',
        icon: 'book',
        colorKey: 'dawn',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: '2026-03-01',
      ),
    );

    await habits.reorder([second.id, first.id]);
    final ordered = await habits.watchActive().first;
    expect(ordered.map((habit) => habit.name), ['Read', 'Water']);

    await completions.setValue(habitId: first.id, date: '2026-03-10', value: 1);
    final logged = await completions.watchForHabit(first.id).first;
    expect(logged.single.date, '2026-03-10');

    await completions.clear(habitId: first.id, date: '2026-03-10');
    expect(await completions.watchForHabit(first.id).first, isEmpty);

    await completions.setValue(habitId: first.id, date: '2026-03-10', value: 1);
    final revived = await completions.watchForHabit(first.id).first;
    expect(revived.single.value, 1);

    await habits.softDelete(first.id);
    expect((await habits.watchActive().first).map((habit) => habit.id), [
      second.id,
    ]);
  });

  test('a stored completion feeds the streak calculator', () async {
    final habit = await habits.create(
      const HabitDraft(
        name: 'Walk',
        icon: 'walk',
        colorKey: 'hayati',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: '2026-03-01',
      ),
    );
    await completions.setValue(habitId: habit.id, date: '2026-03-08', value: 1);
    await completions.setValue(habitId: habit.id, date: '2026-03-09', value: 1);

    final rows = await completions.watchForHabit(habit.id).first;
    final streak = const StreakCalculator().calculate(
      habit: habit.schedule,
      completions: {for (final row in rows) row.date: row.value},
      today: '2026-03-10',
      weekStart: DateTime.monday,
    );
    expect(streak.current, 2);
    expect(streak.best, 2);
  });

  test('preferences round-trip through the settings table', () async {
    expect((await settings.watch().first).themeId, AppThemeId.hayati);
    await settings.setTheme(AppThemeId.dawn);
    await settings.setAppearance(Appearance.dark);
    await settings.setLocale('ar');
    await settings.setWeekStart(DateTime.saturday);

    final saved = await settings.watch().first;
    expect(saved.themeId, AppThemeId.dawn);
    expect(saved.appearance, Appearance.dark);
    expect(saved.localeCode, 'ar');
    expect(saved.weekStart, DateTime.saturday);

    await settings.setLocale(null);
    expect((await settings.watch().first).localeCode, isNull);
  });

  test('today is a calendar date, not a timestamp', () {
    final date = CalendarDate.fromDateTime(DateTime.utc(2026, 3, 29, 23));
    expect(date.iso, isNotEmpty);
    expect(date.addDays(1).iso, isNot(date.iso));
  });
}
