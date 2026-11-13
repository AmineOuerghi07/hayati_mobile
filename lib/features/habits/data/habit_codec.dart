import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

List<int> decodeWeekdays(String raw) {
  if (raw.trim().isEmpty) return const [];
  return [
    for (final part in raw.split(','))
      if (part.isNotEmpty) int.parse(part),
  ];
}

String encodeWeekdays(List<int> days) => days.join(',');

Habit habitFromRow(HabitRow row) {
  return Habit(
    id: row.id,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
    deletedAt: row.deletedAt?.toUtc(),
    name: row.name,
    icon: row.icon,
    colorKey: row.colorKey,
    type: HabitType.values.byName(row.type),
    targetValue: row.targetValue,
    unit: row.unit,
    frequencyType: FrequencyType.values.byName(row.frequencyType),
    weekdays: decodeWeekdays(row.weekdays),
    timesPerWeek: row.timesPerWeek,
    reminderTime: row.reminderTime,
    startDate: row.startDate,
    archivedAt: row.archivedAt?.toUtc(),
    sortOrder: row.sortOrder,
  );
}

HabitCompletion completionFromRow(CompletionRow row) {
  return HabitCompletion(
    id: row.id,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
    deletedAt: row.deletedAt?.toUtc(),
    habitId: row.habitId,
    date: row.date,
    value: row.value,
    note: row.note,
    completedAt: row.completedAt?.toUtc(),
  );
}
