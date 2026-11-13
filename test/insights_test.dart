import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/stats/domain/insights.dart';

void main() {
  final today = CalendarDate.parse('2026-03-11');
  final habit = Habit(
    id: 'h1',
    createdAt: DateTime.utc(2026, 3, 1),
    updatedAt: DateTime.utc(2026, 3, 1),
    name: 'Water',
    icon: 'water',
    colorKey: 'sea',
    type: HabitType.boolean,
    frequencyType: FrequencyType.daily,
    startDate: '2026-03-09',
  );

  HabitCompletion done(String date) {
    return HabitCompletion(
      id: date,
      createdAt: DateTime.utc(2026, 3, 9),
      updatedAt: DateTime.utc(2026, 3, 9),
      habitId: 'h1',
      date: date,
    );
  }

  test('today and the week count only due days that were completed', () {
    final rates = computeInsightRates(
      habits: [habit],
      completions: [done('2026-03-09'), done('2026-03-10')],
      today: today,
      weekStart: DateTime.monday,
    );
    expect(rates.today, 0);
    expect(rates.week, closeTo(2 / 3, 0.001));
  });

  test('a milestone fires once when the streak crosses it', () {
    expect(crossedMilestone(2, 3), 3);
    expect(crossedMilestone(3, 4), isNull);
    expect(crossedMilestone(6, 8), 7);
  });

  test('the heatmap is 84 days and marks a finished day', () {
    final levels = heatmapLevels(
      habits: [habit],
      completions: [done('2026-03-11')],
      today: today,
    );
    expect(levels, hasLength(84));
    expect(levels.last, 4);
  });
}
