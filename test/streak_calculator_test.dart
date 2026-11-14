import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';

void main() {
  final calculator = const StreakCalculator();
  final file = File('test/fixtures/streak_cases.json');
  final cases =
      (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)['cases']
          as List<dynamic>;

  for (final raw in cases) {
    final data = raw as Map<String, dynamic>;
    test(data['name'] as String, () {
      final habitJson = data['habit'] as Map<String, dynamic>;
      final completions = <String, double>{
        for (final entry in data['completions'] as List<dynamic>)
          (entry as Map<String, dynamic>)['date'] as String:
              (entry['value'] as num).toDouble(),
      };
      final result = calculator.calculate(
        habit: HabitSchedule(
          type: HabitType.values.byName(habitJson['type'] as String),
          frequencyType: FrequencyType.values.byName(
            habitJson['frequencyType'] as String,
          ),
          startDate: habitJson['startDate'] as String,
          weekdays: [
            for (final day in habitJson['weekdays'] as List<dynamic>? ?? [])
              day as int,
          ],
          timesPerWeek: habitJson['timesPerWeek'] as int? ?? 1,
          targetValue: (habitJson['targetValue'] as num?)?.toDouble() ?? 1,
          archivedOn: habitJson['archivedOn'] as String?,
        ),
        completions: completions,
        today: data['today'] as String,
        weekStart: _weekStart(data['weekStart'] as String),
      );
      final expected = data['expected'] as Map<String, dynamic>;
      expect(result.current, expected['current'], reason: 'current');
      expect(result.best, expected['best'], reason: 'best');
    });
  }

  HabitSchedule daily(String start) => HabitSchedule(
    type: HabitType.boolean,
    frequencyType: FrequencyType.daily,
    startDate: start,
    targetValue: 1,
  );

  test('a skip pauses a daily streak without growing it', () {
    final result = calculator.calculate(
      habit: daily('2026-03-01'),
      completions: {'2026-03-01': 1, '2026-03-02': -1, '2026-03-03': 1},
      today: '2026-03-04',
      weekStart: DateTime.monday,
    );
    expect(result.current, 2);
    expect(result.best, 2);
  });

  test('time off pauses a missed day instead of resetting it', () {
    final result = calculator.calculate(
      habit: daily('2026-03-01'),
      completions: {'2026-03-01': 1, '2026-03-03': 1},
      today: '2026-03-04',
      weekStart: DateTime.monday,
      pauseStart: '2026-03-02',
      pauseEnd: '2026-03-02',
    );
    expect(result.current, 2);
    expect(result.best, 2);
  });

  test('weekly skips lower the target and a skipped week freezes', () {
    final habit = HabitSchedule(
      type: HabitType.boolean,
      frequencyType: FrequencyType.timesPerWeek,
      startDate: '2026-03-02',
      timesPerWeek: 3,
      targetValue: 1,
    );
    final metWithOneSkip = calculator.calculate(
      habit: habit,
      completions: {
        '2026-03-02': 1,
        '2026-03-03': 1,
        '2026-03-04': 1,
        '2026-03-09': -1,
        '2026-03-10': 1,
        '2026-03-11': 1,
      },
      today: '2026-03-16',
      weekStart: DateTime.monday,
    );
    expect(metWithOneSkip.current, 2);

    final frozen = calculator.calculate(
      habit: habit,
      completions: {
        '2026-03-02': 1,
        '2026-03-03': 1,
        '2026-03-04': 1,
        '2026-03-09': -1,
        '2026-03-10': -1,
        '2026-03-11': -1,
      },
      today: '2026-03-16',
      weekStart: DateTime.monday,
    );
    expect(frozen.current, 1);
    expect(frozen.best, 1);
  });
}

int _weekStart(String name) {
  return switch (name) {
    'monday' => DateTime.monday,
    'tuesday' => DateTime.tuesday,
    'wednesday' => DateTime.wednesday,
    'thursday' => DateTime.thursday,
    'friday' => DateTime.friday,
    'saturday' => DateTime.saturday,
    'sunday' => DateTime.sunday,
    _ => throw ArgumentError.value(name, 'weekStart'),
  };
}
