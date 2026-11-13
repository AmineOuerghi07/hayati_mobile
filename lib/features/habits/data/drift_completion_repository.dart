import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/habits/data/habit_codec.dart';
import 'package:hayati/features/habits/domain/completion_repository.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:uuid/uuid.dart';

class DriftCompletionRepository implements CompletionRepository {
  DriftCompletionRepository(this._db, {Uuid? uuid, this.outbox})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;
  final OutboxWriter? outbox;

  @override
  Stream<List<HabitCompletion>> watchAll() {
    return _watchScoped((scope) async {
      final query = _db.select(_db.habitCompletions)
        ..where((row) => row.deletedAt.isNull() & row.scopeId.equals(scope))
        ..orderBy([(row) => OrderingTerm.asc(row.date)]);
      final rows = await query.get();
      return [for (final row in rows) completionFromRow(row)];
    });
  }

  @override
  Stream<List<HabitCompletion>> watchForHabit(String habitId) {
    return _watchScoped((scope) async {
      final query = _db.select(_db.habitCompletions)
        ..where(
          (row) =>
              row.habitId.equals(habitId) &
              row.deletedAt.isNull() &
              row.scopeId.equals(scope),
        )
        ..orderBy([(row) => OrderingTerm.asc(row.date)]);
      final rows = await query.get();
      return [for (final row in rows) completionFromRow(row)];
    });
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
      await _enqueue(habitId, date);
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
    await _enqueue(habitId, date);
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
    await _enqueue(habitId, date);
  }

  Future<void> _enqueue(String habitId, String date) async {
    final writer = outbox;
    if (writer == null) return;
    final row =
        await (_db.select(_db.habitCompletions)..where(
              (item) => item.habitId.equals(habitId) & item.date.equals(date),
            ))
            .getSingleOrNull();
    if (row == null) return;
    final completion = completionFromRow(row);
    await writer.record(
      SyncRecord(
        entityType: 'completion',
        entityKey: '$habitId|$date',
        deleted: completion.deletedAt != null,
        payload: {
          ...completion.toJson(),
          'scopeId': await DataScope(_db).current(),
        },
        updatedAt: completion.updatedAt,
        writerId: writer.writerId,
      ),
    );
  }

  Stream<T> _watchScoped<T>(Future<T> Function(String scope) load) {
    final controller = StreamController<T>();
    Future<void> emit() async {
      if (controller.isClosed) return;
      controller.add(await load(await DataScope(_db).current()));
    }

    final rowsSub = _db
        .select(_db.habitCompletions)
        .watch()
        .listen((_) => emit());
    final settingsSub = _db
        .select(_db.appSettings)
        .watch()
        .listen((_) => emit());
    emit();
    controller.onCancel = () async {
      await rowsSub.cancel();
      await settingsSub.cancel();
    };
    return controller.stream;
  }
}
