import 'package:hayati/features/habits/domain/part_of_day.dart';

/// What Today shows besides the time-of-day filter.
///
/// [open] is the default: finished habits step out of the way, the way
/// Habitify and Benji keep the day focused on what is left.
enum TodayStatus { open, done, all }

bool showsHabit({
  required PartOfDay? part,
  required PartOfDay? partFilter,
  required bool complete,
  required TodayStatus status,
}) {
  if (partFilter != null && part != partFilter) return false;
  return switch (status) {
    TodayStatus.open => !complete,
    TodayStatus.done => complete,
    TodayStatus.all => true,
  };
}
