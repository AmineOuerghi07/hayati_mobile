import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/habits/data/habit_codec.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_repository.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:uuid/uuid.dart';

class DriftHabitRepository implements HabitRepository {
  DriftHabitRepository(this._db, {Uuid? uuid, this.outbox})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;
  final OutboxWriter? outbox;

  @override
  Stream<List<Habit>> watchActive() {
    return _watchScoped((scope) {
      final query = _db.select(_db.habits)
        ..where(
          (row) =>
              row.deletedAt.isNull() &
              row.archivedAt.isNull() &
              row.scopeId.equals(scope),
        )
        ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
      return query.get().then(
        (rows) => [for (final row in rows) habitFromRow(row)],
      );
    });
  }

  @override
  Stream<List<Habit>> watchArchived() {
    return _watchScoped((scope) {
      final query = _db.select(_db.habits)
        ..where(
          (row) =>
              row.deletedAt.isNull() &
              row.archivedAt.isNotNull() &
              row.scopeId.equals(scope),
        )
        ..orderBy([(row) => OrderingTerm.desc(row.archivedAt)]);
      return query.get().then(
        (rows) => [for (final row in rows) habitFromRow(row)],
      );
    });
  }

  @override
  Stream<Habit?> watchById(String id) {
    return _watchScoped((scope) {
      final query = _db.select(_db.habits)
        ..where(
          (row) =>
              row.id.equals(id) &
              row.deletedAt.isNull() &
              row.scopeId.equals(scope),
        );
      return query.getSingleOrNull().then(
        (row) => row == null ? null : habitFromRow(row),
      );
    });
  }

  @override
  Future<Habit> create(HabitDraft draft) async {
    final error = draft.nameError;
    if (error != null) {
      throw ArgumentError.value(draft.name, 'name', error);
    }
    final now = DateTime.now().toUtc();
    final active = await watchActive().first;
    final habit = Habit(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      name: draft.name.trim(),
      icon: draft.icon,
      colorKey: draft.colorKey,
      type: draft.type,
      targetValue: draft.targetValue,
      unit: draft.unit,
      frequencyType: draft.frequencyType,
      weekdays: draft.weekdays,
      timesPerWeek: draft.timesPerWeek,
      reminderTime: draft.reminderTime,
      startDate: draft.startDate,
      sortOrder: active.length,
    );
    await _db.into(_db.habits).insert(await _companion(habit));
    await _enqueue(habit, deleted: false);
    return habit;
  }

  @override
  Future<void> update(Habit habit) async {
    final error = habit.name.trim().isEmpty ? 'required' : null;
    if (error != null) {
      throw ArgumentError.value(habit.name, 'name', error);
    }
    final saved = habit.copyWith(
      name: habit.name.trim(),
      updatedAt: DateTime.now().toUtc(),
    );
    await (_db.update(
      _db.habits,
    )..where((row) => row.id.equals(habit.id))).write(await _companion(saved));
    await _enqueue(saved, deleted: false);
  }

  @override
  Future<void> archive(String id) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(archivedAt: Value(now), updatedAt: Value(now)),
    );
    await _enqueueId(id);
  }

  @override
  Future<void> unarchive(String id) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(archivedAt: const Value(null), updatedAt: Value(now)),
    );
    await _enqueueId(id);
  }

  @override
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    await _enqueueId(id, deleted: true);
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      for (var index = 0; index < orderedIds.length; index++) {
        await (_db.update(
          _db.habits,
        )..where((row) => row.id.equals(orderedIds[index]))).write(
          HabitsCompanion(sortOrder: Value(index), updatedAt: Value(now)),
        );
      }
    });
    for (final id in orderedIds) {
      await _enqueueId(id);
    }
  }

  Future<void> _enqueueId(String id, {bool deleted = false}) async {
    final row = await (_db.select(
      _db.habits,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    await _enqueue(habitFromRow(row), deleted: deleted);
  }

  Future<void> _enqueue(Habit habit, {required bool deleted}) async {
    final writer = outbox;
    if (writer == null) return;
    await writer.record(
      SyncRecord(
        entityType: 'habit',
        entityKey: habit.id,
        deleted: deleted,
        payload: {...habit.toJson(), 'scopeId': await DataScope(_db).current()},
        updatedAt: habit.updatedAt,
        writerId: writer.writerId,
      ),
    );
  }

  Future<HabitsCompanion> _companion(Habit habit) async {
    return HabitsCompanion.insert(
      id: habit.id,
      createdAt: habit.createdAt,
      updatedAt: habit.updatedAt,
      deletedAt: Value(habit.deletedAt),
      name: habit.name,
      icon: habit.icon,
      colorKey: habit.colorKey,
      type: habit.type.name,
      targetValue: Value(habit.targetValue),
      unit: Value(habit.unit),
      frequencyType: habit.frequencyType.name,
      weekdays: Value(encodeWeekdays(habit.weekdays)),
      timesPerWeek: Value(habit.timesPerWeek),
      reminderTime: Value(habit.reminderTime),
      startDate: habit.startDate,
      archivedAt: Value(habit.archivedAt),
      sortOrder: Value(habit.sortOrder),
      scopeId: Value(await DataScope(_db).current()),
    );
  }

  Stream<T> _watchScoped<T>(Future<T> Function(String scope) load) {
    final controller = StreamController<T>();
    Future<void> emit() async {
      if (controller.isClosed) return;
      try {
        controller.add(await load(await DataScope(_db).current()));
      } catch (error, stack) {
        debugPrint('habit watch failed: $error\n$stack');
        if (!controller.isClosed) controller.addError(error, stack);
      }
    }

    final habitsSub = _db.select(_db.habits).watch().listen((_) => emit());
    final settingsSub = _db
        .select(_db.appSettings)
        .watch()
        .listen((_) => emit());
    emit();
    controller.onCancel = () async {
      await habitsSub.cancel();
      await settingsSub.cancel();
    };
    return controller.stream;
  }
}
