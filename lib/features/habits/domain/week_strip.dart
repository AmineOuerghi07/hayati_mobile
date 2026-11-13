import 'package:hayati/core/time/calendar_date.dart';

/// The seven days of the week that contains [day], starting on [weekStart].
List<CalendarDate> weekContaining(CalendarDate day, int weekStart) {
  final start = day.startOfWeek(weekStart);
  return [for (var index = 0; index < 7; index++) start.addDays(index)];
}

/// Days after [today] cannot be logged yet.
bool canLogDay(CalendarDate day, CalendarDate today) => day <= today;
