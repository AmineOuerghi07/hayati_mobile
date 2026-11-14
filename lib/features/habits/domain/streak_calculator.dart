import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

/// A skipped day is stored as a negative amount so the streak can pause
/// without a second map.
double streakAmount({required double value, required String? note}) {
  if (CompletionNote.decode(note).skipped) return -1;
  return value;
}

enum _Mark { done, skip, miss }

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
    String? pauseStart,
    String? pauseEnd,
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
        pauseStart: pauseStart,
        pauseEnd: pauseEnd,
      ),
      FrequencyType.weekdays => _weekdays(
        habit: habit,
        completions: completions,
        start: start,
        horizon: horizon,
        forgiveOpenDay: forgiveOpenDay,
        pauseStart: pauseStart,
        pauseEnd: pauseEnd,
      ),
      FrequencyType.timesPerWeek => _timesPerWeek(
        habit: habit,
        completions: completions,
        start: start,
        horizon: horizon,
        forgiveOpenDay: forgiveOpenDay,
        weekStart: weekStart,
        pauseStart: pauseStart,
        pauseEnd: pauseEnd,
      ),
    };
  }

  bool _isPaused(CalendarDate day, String? pauseStart, String? pauseEnd) {
    if (pauseStart == null ||
        pauseEnd == null ||
        pauseStart.isEmpty ||
        pauseEnd.isEmpty) {
      return false;
    }
    final iso = day.iso;
    return iso.compareTo(pauseStart) >= 0 && iso.compareTo(pauseEnd) <= 0;
  }

  _Mark _mark(
    HabitSchedule habit,
    Map<String, double> completions,
    CalendarDate day,
    String? pauseStart,
    String? pauseEnd,
  ) {
    if (_isPaused(day, pauseStart, pauseEnd)) return _Mark.skip;
    if (!completions.containsKey(day.iso)) return _Mark.miss;
    final value = completions[day.iso]!;
    if (value < 0) return _Mark.skip;
    if (value >= habit.targetValue) return _Mark.done;
    return _Mark.miss;
  }

  Streak _daily({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required CalendarDate start,
    required CalendarDate horizon,
    required bool forgiveOpenDay,
    required String? pauseStart,
    required String? pauseEnd,
  }) {
    _Mark mark(CalendarDate day) =>
        _mark(habit, completions, day, pauseStart, pauseEnd);

    var best = 0;
    var run = 0;
    for (var day = start; day <= horizon; day = day.addDays(1)) {
      switch (mark(day)) {
        case _Mark.done:
          run += 1;
          if (run > best) best = run;
        case _Mark.skip:
          break;
        case _Mark.miss:
          run = 0;
      }
    }

    var cursor = horizon;
    if (forgiveOpenDay && mark(cursor) == _Mark.miss) {
      cursor = cursor.addDays(-1);
    }
    var current = 0;
    while (cursor >= start) {
      switch (mark(cursor)) {
        case _Mark.done:
          current += 1;
          cursor = cursor.addDays(-1);
        case _Mark.skip:
          cursor = cursor.addDays(-1);
        case _Mark.miss:
          return Streak(current: current, best: best);
      }
    }
    return Streak(current: current, best: best);
  }

  Streak _weekdays({
    required HabitSchedule habit,
    required Map<String, double> completions,
    required CalendarDate start,
    required CalendarDate horizon,
    required bool forgiveOpenDay,
    required String? pauseStart,
    required String? pauseEnd,
  }) {
    final scheduled = habit.weekdays.toSet();
    bool isDue(CalendarDate day) => scheduled.contains(day.weekday);
    _Mark mark(CalendarDate day) =>
        _mark(habit, completions, day, pauseStart, pauseEnd);

    var best = 0;
    var run = 0;
    for (var day = start; day <= horizon; day = day.addDays(1)) {
      if (!isDue(day)) continue;
      switch (mark(day)) {
        case _Mark.done:
          run += 1;
          if (run > best) best = run;
        case _Mark.skip:
          break;
        case _Mark.miss:
          run = 0;
      }
    }

    CalendarDate? anchor = isDue(horizon)
        ? horizon
        : _previousDue(horizon, start, isDue);
    if (anchor != null &&
        forgiveOpenDay &&
        anchor == horizon &&
        mark(anchor) == _Mark.miss) {
      anchor = _previousDue(anchor, start, isDue);
    }
    if (anchor != null && mark(anchor) == _Mark.miss) {
      return Streak(current: 0, best: best);
    }

    var current = 0;
    var cursor = anchor;
    while (cursor != null) {
      switch (mark(cursor)) {
        case _Mark.done:
          current += 1;
          cursor = _previousDue(cursor, start, isDue);
        case _Mark.skip:
          cursor = _previousDue(cursor, start, isDue);
        case _Mark.miss:
          cursor = null;
      }
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
    required String? pauseStart,
    required String? pauseEnd,
  }) {
    final target = habit.timesPerWeek;
    final firstWeek = start.startOfWeek(weekStart);
    final lastWeek = horizon.startOfWeek(weekStart);

    _Week weekResult(CalendarDate week) {
      var done = 0;
      var skips = 0;
      for (var i = 0; i < 7; i++) {
        final day = week.addDays(i);
        if (day < start || day > horizon) continue;
        switch (_mark(habit, completions, day, pauseStart, pauseEnd)) {
          case _Mark.done:
            done += 1;
          case _Mark.skip:
            skips += 1;
          case _Mark.miss:
            break;
        }
      }
      // Skips lower the bar. A week that is only skips freezes the streak
      // instead of growing it or wiping it.
      final needed = target - skips;
      if (needed <= 0) return _Week.freeze;
      if (done >= needed) return _Week.success;
      return _Week.fail;
    }

    final forgiveWeek =
        forgiveOpenDay && lastWeek == horizon.startOfWeek(weekStart);

    var best = 0;
    var run = 0;
    for (var week = firstWeek; week <= lastWeek; week = week.addDays(7)) {
      final result = weekResult(week);
      final inProgress =
          forgiveWeek && week == lastWeek && result == _Week.fail;
      switch (result) {
        case _Week.success:
          run += 1;
          if (run > best) best = run;
        case _Week.freeze:
          break;
        case _Week.fail:
          if (!inProgress) run = 0;
      }
    }

    var week = lastWeek;
    if (forgiveWeek && weekResult(week) == _Week.fail) {
      week = week.addDays(-7);
    }
    var current = 0;
    while (week.addDays(6) >= start) {
      switch (weekResult(week)) {
        case _Week.success:
          current += 1;
          week = week.addDays(-7);
        case _Week.freeze:
          week = week.addDays(-7);
        case _Week.fail:
          return Streak(current: current, best: best);
      }
    }
    return Streak(current: current, best: best);
  }
}

enum _Week { success, freeze, fail }
