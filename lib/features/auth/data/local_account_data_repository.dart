import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/auth/domain/data_choice.dart';
import 'package:hayati/features/habits/data/habit_codec.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';

class LocalAccountDataRepository {
  LocalAccountDataRepository(this._db, this._remote);

  final AppDatabase _db;
  final SyncRemote _remote;

  Future<ScopeCounts> guestCounts() async {
    return _counts(await DataScope(_db).current(), includeRemote: false);
  }

  Future<ScopeCounts> accountCounts(String userId) {
    return _counts(userId, includeRemote: true);
  }

  Future<void> apply(String userId, DataChoice choice) async {
    final guest = await DataScope(_db).current();
    final scope = DataScope(_db);
    switch (choice) {
      case DataChoice.merge:
        await scope.attachCurrentGuestTo(userId);
      case DataChoice.keepAccount:
        await _softDeleteScope(guest);
        await scope.setCurrent(userId);
      case DataChoice.keepDevice:
        await _softDeleteScope(userId);
        await scope.attachCurrentGuestTo(userId);
      case DataChoice.fresh:
        await _softDeleteScope(guest);
        await _softDeleteScope(userId);
        await scope.setCurrent(userId);
    }
    await _queueLive(userId);
  }

  Future<ScopeCounts> _counts(
    String scopeId, {
    required bool includeRemote,
  }) async {
    final habits =
        await (_db.select(_db.habits)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    final completions =
        await (_db.select(_db.habitCompletions)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    final habitKeys = habits.map((row) => row.id).toSet();
    final completionKeys = completions
        .map((row) => '${row.habitId}|${row.date}')
        .toSet();
    if (includeRemote) {
      for (final record in await _remote.pull()) {
        if (record.deleted || record.payload['scopeId'] != scopeId) continue;
        if (record.entityType == 'habit') habitKeys.add(record.entityKey);
        if (record.entityType == 'completion') {
          completionKeys.add(record.entityKey);
        }
      }
    }
    return ScopeCounts(
      habits: habitKeys.length,
      checkIns: completionKeys.length,
    );
  }

  Future<void> _softDeleteScope(String scopeId) async {
    final now = DateTime.now().toUtc();
    final habits =
        await (_db.select(_db.habits)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    for (final row in habits) {
      await (_db.update(_db.habits)..where((item) => item.id.equals(row.id)))
          .write(HabitsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
      await _recordHabit(row.id, deleted: true);
    }
    final completions =
        await (_db.select(_db.habitCompletions)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    for (final row in completions) {
      await (_db.update(
        _db.habitCompletions,
      )..where((item) => item.id.equals(row.id))).write(
        HabitCompletionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await _recordCompletion(row.id, deleted: true);
    }
  }

  Future<void> _queueLive(String scopeId) async {
    final habits =
        await (_db.select(_db.habits)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    for (final row in habits) {
      await _recordHabit(row.id, deleted: false);
    }
    final completions =
        await (_db.select(_db.habitCompletions)..where(
              (row) => row.scopeId.equals(scopeId) & row.deletedAt.isNull(),
            ))
            .get();
    for (final row in completions) {
      await _recordCompletion(row.id, deleted: false);
    }
  }

  Future<void> _recordHabit(String id, {required bool deleted}) async {
    final row = await (_db.select(
      _db.habits,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    final habit = habitFromRow(row);
    await _writer.record(
      SyncRecord(
        entityType: 'habit',
        entityKey: habit.id,
        deleted: deleted,
        payload: {...habit.toJson(), 'scopeId': row.scopeId},
        updatedAt: habit.updatedAt,
        writerId: _writer.writerId,
      ),
    );
  }

  Future<void> _recordCompletion(String id, {required bool deleted}) async {
    final row = await (_db.select(
      _db.habitCompletions,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    final item = completionFromRow(row);
    await _writer.record(
      SyncRecord(
        entityType: 'completion',
        entityKey: '${item.habitId}|${item.date}',
        deleted: deleted,
        payload: {...item.toJson(), 'scopeId': row.scopeId},
        updatedAt: item.updatedAt,
        writerId: _writer.writerId,
      ),
    );
  }

  OutboxWriter get _writer => OutboxWriter(_db)..writerId = 'this-device';
}
