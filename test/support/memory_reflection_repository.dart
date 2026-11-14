import 'dart:async';

import 'package:hayati/features/journal/domain/daily_reflection.dart';
import 'package:hayati/features/journal/domain/reflection_repository.dart';

/// In-memory reflections so widget tests never open SQLite.
class MemoryReflectionRepository implements ReflectionRepository {
  var _items = const <DailyReflection>[];
  final _updates = StreamController<List<DailyReflection>>.broadcast();

  @override
  Stream<List<DailyReflection>> watchAll() async* {
    yield _items;
    yield* _updates.stream;
  }

  @override
  Future<void> save({
    required String date,
    int? mood,
    String? gratitude,
    String? note,
  }) async {
    _items = [
      DailyReflection(
        id: date,
        date: date,
        mood: mood,
        gratitude: gratitude,
        note: note,
      ),
      for (final item in _items)
        if (item.date != date) item,
    ];
    _updates.add(_items);
  }
}
