import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/features/habits/data/habit_codec.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_repository.dart';
import 'package:uuid/uuid.dart';

class DriftHabitRepository implements HabitRepository {
  DriftHabitRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  @override
  Stream<List<Habit>> watchActive() {
    final query = _db.select(_db.habits)
      ..where((row) => row.deletedAt.isNull() & row.archivedAt.isNull())
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
    return query.watch().map(
      (rows) => [for (final row in rows) habitFromRow(row)],
    );
  }

  @override
  Stream<Habit?> watchById(String id) {
    final query = _db.select(_db.habits)
      ..where((row) => row.id.equals(id) & row.deletedAt.isNull());
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : habitFromRow(row),
    );
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
    await _db.into(_db.habits).insert(_companion(habit));
    return habit;
  }

  @override
  Future<void> update(Habit habit) async {
    final error = habit.name.trim().isEmpty ? 'required' : null;
    if (error != null) {
      throw ArgumentError.value(habit.name, 'name', error);
    }
    await (_db.update(
      _db.habits,
    )..where((row) => row.id.equals(habit.id))).write(
      _companion(
        habit.copyWith(
          name: habit.name.trim(),
          updatedAt: DateTime.now().toUtc(),
        ),
      ),
    );
  }

  @override
  Future<void> archive(String id) {
    return (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(
        archivedAt: Value(DateTime.now().toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> unarchive(String id) {
    return (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(
        archivedAt: const Value(null),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> softDelete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.habits)..where((row) => row.id.equals(id))).write(
      HabitsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> reorder(List<String> orderedIds) {
    return _db.transaction(() async {
      final now = DateTime.now().toUtc();
      for (var index = 0; index < orderedIds.length; index++) {
        await (_db.update(
          _db.habits,
        )..where((row) => row.id.equals(orderedIds[index]))).write(
          HabitsCompanion(sortOrder: Value(index), updatedAt: Value(now)),
        );
      }
    });
  }

  HabitsCompanion _companion(Habit habit) {
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
    );
  }
}
