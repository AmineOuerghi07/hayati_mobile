import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/habits/data/habit_codec.dart';
import 'package:hayati/features/habits/domain/completion_repository.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:uuid/uuid.dart';

class DriftCompletionRepository implements CompletionRepository {
  DriftCompletionRepository(this._db, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<HabitCompletion>> watchAll() {
    final query = _db.select(_db.habitCompletions)
      ..where((row) => row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.asc(row.date)]);
    return query.watch().map(
      (rows) => [for (final row in rows) completionFromRow(row)],
    );
  }

  @override
  Stream<List<HabitCompletion>> watchForHabit(String habitId) {
    final query = _db.select(_db.habitCompletions)
      ..where((row) => row.habitId.equals(habitId) & row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.asc(row.date)]);
    return query.watch().map(
      (rows) => [for (final row in rows) completionFromRow(row)],
    );
  }

  @override
  Future<void> setValue({
    required String habitId,
    required String date,
    required double value,
    String? note,
  }) async {
    final now = DateTime.now().toUtc();
    final existing =
        await (_db.select(_db.habitCompletions)..where(
              (row) => row.habitId.equals(habitId) & row.date.equals(date),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.habitCompletions)
          .insert(
            HabitCompletionsCompanion.insert(
              id: _uuid.v4(),
              createdAt: now,
              updatedAt: now,
              habitId: habitId,
              date: date,
              value: Value(value),
              note: Value(note),
              completedAt: Value(now),
              scopeId: Value(await DataScope(_db).current()),
            ),
          );
      return;
    }
    await (_db.update(
      _db.habitCompletions,
    )..where((row) => row.id.equals(existing.id))).write(
      HabitCompletionsCompanion(
        value: Value(value),
        note: Value(note),
        deletedAt: const Value(null),
        completedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> clear({required String habitId, required String date}) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.habitCompletions)..where(
          (row) =>
              row.habitId.equals(habitId) &
              row.date.equals(date) &
              row.deletedAt.isNull(),
        ))
        .write(
          HabitCompletionsCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
