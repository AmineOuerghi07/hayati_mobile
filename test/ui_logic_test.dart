import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_due.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/week_strip.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_redirect.dart';
import 'package:hayati/features/stats/domain/insights.dart';

void main() {
  test('notes round-trip a mood and keep older plain text', () {
    const note = CompletionNote(mood: 3, text: 'hello|there');
    expect(CompletionNote.decode(note.encode()), note);
    expect(
      CompletionNote.decode('just text'),
      const CompletionNote(text: 'just text'),
    );
    expect(const CompletionNote().encode(), isNull);
    expect(CompletionNote.decode('mood:9|nope').mood, isNull);
  });

  test('quantity steps stay inside the target range', () {
    expect(meetsTarget(8, 8), isTrue);
    expect(meetsTarget(7, 8), isFalse);
    expect(stepQuantity(0, -1), 0);
    expect(stepQuantity(998, 5), 999);
    expect(stepQuantity(2, 1), 3);
  });

  test('the week strip only offers days up to today', () {
    final wednesday = CalendarDate(2026, 1, 7);
    final week = weekContaining(wednesday, DateTime.monday);
    expect(week.first, CalendarDate(2026, 1, 5));
    expect(week.length, 7);
    expect(canLogDay(wednesday.addDays(1), wednesday), isFalse);
    expect(canLogDay(wednesday.addDays(-1), wednesday), isTrue);
  });

  test('a selected day uses that weekday, not today', () {
    final habit = Habit(
      id: '1',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      name: 'Read',
      icon: 'book',
      colorKey: 'dusk',
      type: HabitType.boolean,
      frequencyType: FrequencyType.weekdays,
      weekdays: const [DateTime.monday],
      startDate: '2026-01-01',
    );
    expect(isHabitDueOn(habit, CalendarDate(2026, 1, 5)), isTrue);
    expect(isHabitDueOn(habit, CalendarDate(2026, 1, 6)), isFalse);
  });

  test('day counts compare the logged value with the target', () {
    final habit = Habit(
      id: 'water',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      name: 'Water',
      icon: 'water',
      colorKey: 'sea',
      type: HabitType.quantity,
      targetValue: 8,
      unit: 'glasses',
      frequencyType: FrequencyType.daily,
      startDate: '2026-01-01',
    );
    final day = CalendarDate(2026, 1, 6);
    final partial = dayCounts(
      habits: [habit],
      completions: [
        HabitCompletion(
          id: 'c',
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
          habitId: habit.id,
          date: day.iso,
          value: 3,
        ),
      ],
      day: day,
    );
    expect(partial.done, 0);
    expect(partial.due, 1);
    expect(partial.rate, 0);
  });

  test('perfect days, check-ins, and mood summarize recent history', () {
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
    HabitCompletion done(CalendarDate day, double value) => HabitCompletion(
      id: day.iso,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      habitId: habit.id,
      date: day.iso,
      value: value,
    );
    final logged = [
      done(today, 1),
      done(today.addDays(-1), 1),
      done(today.addDays(-2), 0),
    ];
    expect(perfectDays(habits: [habit], completions: logged, today: today), 2);
    expect(totalCheckIns(habits: [habit], completions: logged), 2);
    expect(totalCheckIns(habits: const [], completions: logged), 0);
    expect(averageMood(const []), isNull);
    expect(averageMood(const [2, 4, 5]), closeTo(3.67, 0.01));
  });

  test('onboarding redirect waits until the flag is known', () {
    expect(
      onboardingRedirect(onboardingDone: null, location: '/today'),
      isNull,
    );
    expect(
      onboardingRedirect(onboardingDone: false, location: '/today'),
      '/onboarding',
    );
    expect(
      onboardingRedirect(onboardingDone: false, location: '/onboarding'),
      isNull,
    );
    expect(
      onboardingRedirect(onboardingDone: true, location: '/onboarding'),
      '/today',
    );
    expect(
      onboardingRedirect(onboardingDone: true, location: '/stats'),
      isNull,
    );
  });
}
