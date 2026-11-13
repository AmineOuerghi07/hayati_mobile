import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_due.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

class InsightRates {
  const InsightRates({this.today, this.week, this.month});

  /// Null when nothing was due.
  final double? today;
  final double? week;
  final double? month;
}

const streakMilestones = [3, 7, 14, 30, 50, 100];

/// The highest milestone crossed by moving from [before] to [after].
int? crossedMilestone(int before, int after) {
  int? hit;
  for (final milestone in streakMilestones) {
    if (before < milestone && after >= milestone) hit = milestone;
  }
  return hit;
}

InsightRates computeInsightRates({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate today,
  required int weekStart,
}) {
  final values = {
    for (final item in completions) '${item.habitId}|${item.date}': item.value,
  };

  double? rate(CalendarDate start, CalendarDate end) {
    var due = 0;
    var done = 0;
    final weekly = habits
        .where((habit) => habit.frequencyType == FrequencyType.timesPerWeek)
        .toList();
    final daily = habits
        .where((habit) => habit.frequencyType != FrequencyType.timesPerWeek)
        .toList();

    for (var day = start; day <= end && day <= today; day = day.addDays(1)) {
      for (final habit in daily) {
        if (!isHabitDueOn(habit, day)) continue;
        due += 1;
        final value = values['${habit.id}|${day.iso}'] ?? 0;
        if (value >= habit.targetValue) done += 1;
      }
    }

    var week = start.startOfWeek(weekStart);
    final last = (end < today ? end : today).startOfWeek(weekStart);
    while (week <= last) {
      for (final habit in weekly) {
        final target = habit.timesPerWeek;
        var count = 0;
        for (var i = 0; i < 7; i++) {
          final day = week.addDays(i);
          if (day < start || day > today || day > end) continue;
          if (!isHabitDueOn(habit, day)) continue;
          final value = values['${habit.id}|${day.iso}'] ?? 0;
          if (value >= habit.targetValue) count += 1;
        }
        if (target <= 0) continue;
        due += target;
        done += count > target ? target : count;
      }
      week = week.addDays(7);
    }

    if (due == 0) return null;
    return done / due;
  }

  final weekStartDate = today.startOfWeek(weekStart);
  final monthStart = CalendarDate(today.year, today.month, 1);
  return InsightRates(
    today: rate(today, today),
    week: rate(weekStartDate, weekStartDate.addDays(6)),
    month: rate(monthStart, CalendarDate(today.year, today.month + 1, 0)),
  );
}

/// Intensity 0–4 for each of the last 84 days, oldest first.
List<int> heatmapLevels({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate today,
}) {
  final values = {
    for (final item in completions) '${item.habitId}|${item.date}': item.value,
  };
  final start = today.addDays(-83);
  return [
    for (var day = start; day <= today; day = day.addDays(1))
      _level(habits, values, day),
  ];
}

class DayCounts {
  const DayCounts({required this.done, required this.due});

  final int done;
  final int due;

  double? get rate => due == 0 ? null : done / due;
}

/// How many habits were due on [day], and how many reached their target.
DayCounts dayCounts({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate day,
}) {
  final values = {
    for (final item in completions)
      if (item.date == day.iso) item.habitId: item.value,
  };
  var due = 0;
  var done = 0;
  for (final habit in habits) {
    if (!isHabitDueOn(habit, day)) continue;
    due += 1;
    if ((values[habit.id] ?? 0) >= habit.targetValue) done += 1;
  }
  return DayCounts(done: done, due: due);
}

/// Oldest first, ending on [today].
List<DayCounts> recentDayCounts({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate today,
  int days = 7,
}) {
  final start = today.addDays(1 - days);
  return [
    for (var index = 0; index < days; index++)
      dayCounts(
        habits: habits,
        completions: completions,
        day: start.addDays(index),
      ),
  ];
}

/// Share of due days in the last [days] where [habit] reached its target.
double? habitCompletionRate({
  required Habit habit,
  required List<HabitCompletion> completions,
  required CalendarDate today,
  int days = 30,
}) {
  var due = 0;
  var done = 0;
  final values = {
    for (final item in completions)
      if (item.habitId == habit.id) item.date: item.value,
  };
  final start = today.addDays(1 - days);
  for (var day = start; day <= today; day = day.addDays(1)) {
    if (!isHabitDueOn(habit, day)) continue;
    due += 1;
    if ((values[day.iso] ?? 0) >= habit.targetValue) done += 1;
  }
  if (due == 0) return null;
  return done / due;
}

int _level(List<Habit> habits, Map<String, double> values, CalendarDate day) {
  var due = 0;
  var done = 0;
  for (final habit in habits) {
    if (habit.frequencyType == FrequencyType.timesPerWeek) continue;
    if (!isHabitDueOn(habit, day)) continue;
    due += 1;
    if ((values['${habit.id}|${day.iso}'] ?? 0) >= habit.targetValue) done += 1;
  }
  if (due == 0) return 0;
  final fraction = done / due;
  if (fraction <= 0) return 0;
  if (fraction <= 0.25) return 1;
  if (fraction <= 0.5) return 2;
  if (fraction <= 0.75) return 3;
  return 4;
}
