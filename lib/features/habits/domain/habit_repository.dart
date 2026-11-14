import 'package:hayati/features/habits/domain/habit.dart';

/// The only way the UI reads and writes habits.
abstract class HabitRepository {
  Stream<List<Habit>> watchActive();

  Stream<List<Habit>> watchArchived();

  Stream<Habit?> watchById(String id);

  Future<Habit> create(HabitDraft draft);

  Future<void> update(Habit habit);

  Future<void> archive(String id);

  Future<void> unarchive(String id);

  Future<void> softDelete(String id);

  /// [orderedIds] is the full active order, first item at the top.
  Future<void> reorder(List<String> orderedIds);
}
