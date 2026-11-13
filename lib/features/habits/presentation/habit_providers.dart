import 'package:hayati/core/database/database_provider.dart';
import 'package:hayati/features/habits/data/drift_completion_repository.dart';
import 'package:hayati/features/habits/data/drift_habit_repository.dart';
import 'package:hayati/features/habits/domain/completion_repository.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_repository.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'habit_providers.g.dart';

/// keepAlive so opening a habit does not rebuild the repository, which has
/// no state of its own beyond the shared database.
@Riverpod(keepAlive: true)
HabitRepository habitRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftHabitRepository(
    database,
    outbox: OutboxWriter(database)..writerId = 'this-device',
  );
}

@Riverpod(keepAlive: true)
CompletionRepository completionRepository(Ref ref) {
  return DriftCompletionRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<List<Habit>> activeHabits(Ref ref) {
  return ref.watch(habitRepositoryProvider).watchActive();
}

@riverpod
Stream<Habit?> habitById(Ref ref, String id) {
  return ref.watch(habitRepositoryProvider).watchById(id);
}

@riverpod
Stream<List<HabitCompletion>> allCompletions(Ref ref) {
  return ref.watch(completionRepositoryProvider).watchAll();
}

@riverpod
Stream<List<HabitCompletion>> completionsForHabit(Ref ref, String habitId) {
  return ref.watch(completionRepositoryProvider).watchForHabit(habitId);
}
