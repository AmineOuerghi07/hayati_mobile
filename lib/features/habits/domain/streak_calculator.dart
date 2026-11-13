import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

/// Pure streak rules from the product plan.
///
/// A completion belongs to a local calendar date. Today is still open: if it
/// is not done yet, the streak is the run that ends yesterday (or the previous
/// scheduled day, or the previous week). A finished day with no completion
/// breaks the streak. Days before [HabitSchedule.startDate] are ignored.
/// Archived habits keep their history and are scored as of the archive day.
class StreakCalculator {
  const StreakCalculator();

  Streak calculate({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required String today,
    required int weekStart,
  }) {
    final start = CalendarDate.parse(habit.startDate);
    final todayDate = CalendarDate.parse(today);
    final archived = habit.archivedOn == null
        ? null
        : CalendarDate.parse(habit.archivedOn!);
    final horizon = archived != null && archived < todayDate
        ? archived
        : todayDate;
    if (horizon < start) {
      return const Streak(current: 0, best: 0);
    }
    final forgiveOpenDay = horizon == todayDate;

    return switch (habit.frequencyType) {
      FrequencyType.daily => _daily(
        habit: habit,
        completions: completions,
        start: start,
        horizon: horizon,
        forgiveOpenDay: forgiveOpenDay,
      ),
      FrequencyType.weekdays => _weekdays(
        habit: habit,
        completions: completions,
        start: start,
        horizon: horizon,
        forgiveOpenDay: forgiveOpenDay,
      ),
      FrequencyType.timesPerWeek => _timesPerWeek(
        habit: habit,
        completions: completions,
        start: start,
        horizon: horizon,
        forgiveOpenDay: forgiveOpenDay,
        weekStart: weekStart,
      ),
    };
  }

  bool _counts(
    HabitSchedule habit,
    Map<String, double> completions,
    CalendarDate day,
  ) {
    final value = completions[day.iso] ?? 0;
    return value >= habit.targetValue;
  }

  Streak _daily({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required CalendarDate start,
    required CalendarDate horizon,
    required bool forgiveOpenDay,
  }) {
    var best = 0;
    var run = 0;
    for (var day = start; day <= horizon; day = day.addDays(1)) {
      if (_counts(habit, completions, day)) {
        run += 1;
        if (run > best) best = run;
      } else {
        run = 0;
      }
    }

    var cursor = horizon;
    if (forgiveOpenDay && !_counts(habit, completions, cursor)) {
      cursor = cursor.addDays(-1);
    }
    var current = 0;
    while (cursor >= start && _counts(habit, completions, cursor)) {
      current += 1;
      cursor = cursor.addDays(-1);
    }
    return Streak(current: current, best: best);
  }

  Streak _weekdays({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required CalendarDate start,
    required CalendarDate horizon,
    required bool forgiveOpenDay,
  }) {
    final scheduled = habit.weekdays.toSet();
    bool isDue(CalendarDate day) => scheduled.contains(day.weekday);

    var best = 0;
    var run = 0;
    for (var day = start; day <= horizon; day = day.addDays(1)) {
      if (!isDue(day)) continue;
      if (_counts(habit, completions, day)) {
        run += 1;
        if (run > best) best = run;
      } else {
        run = 0;
      }
    }

    CalendarDate? anchor = isDue(horizon)
        ? horizon
        : _previousDue(horizon, start, isDue);
    if (anchor != null &&
        forgiveOpenDay &&
        anchor == horizon &&
        !_counts(habit, completions, anchor)) {
      anchor = _previousDue(anchor, start, isDue);
    }
    if (anchor != null && !_counts(habit, completions, anchor)) {
      return Streak(current: 0, best: best);
    }

    var current = 0;
    var cursor = anchor;
    while (cursor != null && _counts(habit, completions, cursor)) {
      current += 1;
      cursor = _previousDue(cursor, start, isDue);
    }
    return Streak(current: current, best: best);
  }

  CalendarDate? _previousDue(
    CalendarDate from,
    CalendarDate start,
    bool Function(CalendarDate day) isDue,
  ) {
    var day = from.addDays(-1);
    while (day >= start) {
      if (isDue(day)) return day;
      day = day.addDays(-1);
    }
    return null;
  }

  Streak _timesPerWeek({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required CalendarDate start,
    required CalendarDate horizon,
    required bool forgiveOpenDay,
    required int weekStart,
  }) {
    final target = habit.timesPerWeek;
    final firstWeek = start.startOfWeek(weekStart);
    final lastWeek = horizon.startOfWeek(weekStart);

    int countWeek(CalendarDate week) {
      var count = 0;
      for (var i = 0; i < 7; i++) {
        final day = week.addDays(i);
        if (day < start || day > horizon) continue;
        if (_counts(habit, completions, day)) count += 1;
      }
      return count;
    }

    final forgiveWeek =
        forgiveOpenDay && lastWeek == horizon.startOfWeek(weekStart);

    var best = 0;
    var run = 0;
    for (var week = firstWeek; week <= lastWeek; week = week.addDays(7)) {
      final success = countWeek(week) >= target;
      final inProgress = forgiveWeek && week == lastWeek && !success;
      if (success) {
        run += 1;
        if (run > best) best = run;
      } else if (!inProgress) {
        run = 0;
      }
    }

    var week = lastWeek;
    if (forgiveWeek && countWeek(week) < target) {
      week = week.addDays(-7);
    }
    var current = 0;
    while (week.addDays(6) >= start) {
      if (countWeek(week) >= target) {
        current += 1;
        week = week.addDays(-7);
      } else {
        break;
      }
    }
    return Streak(current: current, best: best);
  }
}
