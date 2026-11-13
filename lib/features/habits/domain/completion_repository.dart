import 'package:hayati/features/habits/domain/habit_completion.dart';

/// Logged values. Clearing a day soft-deletes the row so sync can see it.
abstract class CompletionRepository {
  Stream<List<HabitCompletion>> watchAll();

  Stream<List<HabitCompletion>> watchForHabit(String habitId);

  Future<void> setValue({
    required String habitId,
    required String date,
    required double value,
    String? note,
  });

  Future<void> clear({required String habitId, required String date});
}
