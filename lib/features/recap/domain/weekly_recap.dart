import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/stats/domain/insights.dart';

class WeeklyRecap {
  const WeeklyRecap({
    required this.checkIns,
    required this.bestDay,
    required this.bestDayCount,
    required this.topHabitName,
    required this.topHabitCount,
    required this.perfectDays,
    required this.averageMood,
    required this.grownPlants,
  });

  final int checkIns;
  final CalendarDate? bestDay;
  final int bestDayCount;
  final String? topHabitName;
  final int topHabitCount;
  final int perfectDays;
  final double? averageMood;
  final int grownPlants;

  bool get isEmpty => checkIns == 0 && perfectDays == 0;
}

/// The seven days ending on [today], inclusive.
WeeklyRecap weeklyRecap({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate today,
}) {
  final start = today.addDays(-6).iso;
  final targets = {for (final habit in habits) habit.id: habit.targetValue};
  final names = {for (final habit in habits) habit.id: habit.name};
  final byDay = <String, int>{};
  final byHabit = <String, int>{};
  final moods = <int>[];
  var checkIns = 0;
  for (final item in completions) {
    if (item.deletedAt != null) continue;
    if (item.date.compareTo(start) < 0 || item.date.compareTo(today.iso) > 0) {
      continue;
    }
    final mood = CompletionNote.decode(item.note).mood;
    if (mood != null) moods.add(mood);
    final target = targets[item.habitId];
    if (target == null || item.value < target) continue;
    checkIns += 1;
    byDay[item.date] = (byDay[item.date] ?? 0) + 1;
    byHabit[item.habitId] = (byHabit[item.habitId] ?? 0) + 1;
  }

  String? bestIso;
  var bestCount = 0;
  for (final entry in byDay.entries) {
    if (entry.value > bestCount) {
      bestCount = entry.value;
      bestIso = entry.key;
    }
  }
  String? topId;
  var topCount = 0;
  for (final entry in byHabit.entries) {
    if (entry.value > topCount) {
      topCount = entry.value;
      topId = entry.key;
    }
  }
  final days = recentDayCounts(
    habits: habits,
    completions: completions,
    today: today,
  );
  return WeeklyRecap(
    checkIns: checkIns,
    bestDay: bestIso == null ? null : CalendarDate.parse(bestIso),
    bestDayCount: bestCount,
    topHabitName: topId == null ? null : names[topId],
    topHabitCount: topCount,
    perfectDays: days.where((day) => day.due > 0 && day.done == day.due).length,
    averageMood: averageMood(moods),
    grownPlants: byHabit.length,
  );
}

bool isFirstDayOfWeek(CalendarDate today, int weekStart) =>
    today == today.startOfWeek(weekStart);

/// The last day of the week that just finished, when [today] is a week start.
CalendarDate previousWeekEnd(CalendarDate today) => today.addDays(-1);

/// Today offers last week's story on the first day of a new week, and only
/// when that week has check-ins the person has not already dismissed.
bool offerPreviousWeekRecap({
  required CalendarDate today,
  required int weekStart,
  required WeeklyRecap previousWeek,
  required String? dismissedWeek,
}) {
  if (!isFirstDayOfWeek(today, weekStart)) return false;
  if (previousWeek.isEmpty) return false;
  return dismissedWeek != today.iso;
}
