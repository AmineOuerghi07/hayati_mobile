import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

/// Whether [habit] should appear on [day].
///
/// Daily and times-per-week habits are available every day from the start
/// date until the archive date. Weekday habits only appear on chosen days.
bool isHabitDueOn(Habit habit, CalendarDate day) {
  final start = CalendarDate.parse(habit.startDate);
  if (day < start) return false;
  final archived = habit.schedule.archivedOn;
  if (archived != null && day > CalendarDate.parse(archived)) return false;
  return switch (habit.frequencyType) {
    FrequencyType.daily || FrequencyType.timesPerWeek => true,
    FrequencyType.weekdays => habit.weekdays.contains(day.weekday),
  };
}
