import 'dart:async';

import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/completion_repository.dart';
import 'package:hayati/features/habits/domain/habit_repository.dart';
import 'package:uuid/uuid.dart';

class MemoryHabitRepository implements HabitRepository {
  MemoryHabitRepository({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  final List<Habit> _habits = [];
  final _updates = StreamController<void>.broadcast();

  @override
  Stream<List<Habit>> watchActive() async* {
    yield _active();
    yield* _updates.stream.map((_) => _active());
  }

  @override
  Stream<Habit?> watchById(String id) async* {
    yield _find(id);
    yield* _updates.stream.map((_) => _find(id));
  }

  @override
  Future<Habit> create(HabitDraft draft) async {
    final now = DateTime.now().toUtc();
    final habit = Habit(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      name: draft.name.trim(),
      icon: draft.icon,
      colorKey: draft.colorKey,
      type: draft.type,
      targetValue: draft.targetValue,
      frequencyType: draft.frequencyType,
      weekdays: draft.weekdays,
      timesPerWeek: draft.timesPerWeek,
      reminderTime: draft.reminderTime,
      startDate: draft.startDate,
      sortOrder: _habits.length,
    );
    _habits.add(habit);
    _updates.add(null);
    return habit;
  }

  @override
  Future<void> update(Habit habit) async {
    final index = _habits.indexWhere((item) => item.id == habit.id);
    if (index >= 0) _habits[index] = habit;
    _updates.add(null);
  }

  @override
  Future<void> archive(String id) async {
    final current = _find(id);
    if (current == null) return;
    await update(current.copyWith(archivedAt: DateTime.now().toUtc()));
  }

  @override
  Future<void> unarchive(String id) async {
    final current = _habits.cast<Habit?>().firstWhere(
      (item) => item?.id == id,
      orElse: () => null,
    );
    if (current == null) return;
    await update(current.copyWith(archivedAt: null));
  }

  @override
  Future<void> softDelete(String id) async {
    final current = _find(id);
    if (current == null) return;
    await update(current.copyWith(deletedAt: DateTime.now().toUtc()));
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    for (var index = 0; index < orderedIds.length; index++) {
      final current = _find(orderedIds[index]);
      if (current != null) {
        final at = _habits.indexWhere((item) => item.id == current.id);
        _habits[at] = current.copyWith(sortOrder: index);
      }
    }
    _habits.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _updates.add(null);
  }

  List<Habit> _active() {
    final visible = [
      for (final habit in _habits)
        if (!habit.isDeleted && !habit.isArchived) habit,
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return visible;
  }

  Habit? _find(String id) {
    for (final habit in _habits) {
      if (habit.id == id && !habit.isDeleted) return habit;
    }
    return null;
  }
}

class MemoryCompletionRepository implements CompletionRepository {
  final List<HabitCompletion> _rows = [];
  final _updates = StreamController<void>.broadcast();
  final _uuid = const Uuid();

  @override
  Stream<List<HabitCompletion>> watchAll() async* {
    yield _visible();
    yield* _updates.stream.map((_) => _visible());
  }

  @override
  Stream<List<HabitCompletion>> watchForHabit(String habitId) async* {
    yield _visible(habitId: habitId);
    yield* _updates.stream.map((_) => _visible(habitId: habitId));
  }

  @override
  Future<void> setValue({
    required String habitId,
    required String date,
    required double value,
    String? note,
  }) async {
    final index = _rows.indexWhere(
      (row) => row.habitId == habitId && row.date == date,
    );
    final now = DateTime.now().toUtc();
    if (index < 0) {
      _rows.add(
        HabitCompletion(
          id: _uuid.v4(),
          createdAt: now,
          updatedAt: now,
          habitId: habitId,
          date: date,
          value: value,
          note: note,
          completedAt: now,
        ),
      );
    } else {
      _rows[index] = _rows[index].copyWith(
        value: value,
        note: note,
        deletedAt: null,
        updatedAt: now,
        completedAt: now,
      );
    }
    _updates.add(null);
  }

  @override
  Future<void> clear({required String habitId, required String date}) async {
    final index = _rows.indexWhere(
      (row) =>
          row.habitId == habitId && row.date == date && row.deletedAt == null,
    );
    if (index < 0) return;
    _rows[index] = _rows[index].copyWith(deletedAt: DateTime.now().toUtc());
    _updates.add(null);
  }

  List<HabitCompletion> _visible({String? habitId}) {
    return [
      for (final row in _rows)
        if (row.deletedAt == null &&
            (habitId == null || row.habitId == habitId))
          row,
    ];
  }
}
