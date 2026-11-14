import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/journal/domain/daily_reflection.dart';
import 'package:hayati/features/journal/domain/reflection_repository.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:uuid/uuid.dart';

class DriftReflectionRepository implements ReflectionRepository {
  DriftReflectionRepository(this._db, {Uuid? uuid, this.outbox})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;
  final OutboxWriter? outbox;

  @override
  Stream<List<DailyReflection>> watchAll() {
    final controller = StreamController<List<DailyReflection>>();
    Future<void> emit() async {
      if (controller.isClosed) return;
      final scope = await DataScope(_db).current();
      final rows =
          await (_db.select(_db.dailyReflections)
                ..where((row) => row.deletedAt.isNull())
                ..orderBy([(row) => OrderingTerm.desc(row.date)]))
              .get();
      controller.add([
        for (final row in rows)
          if (row.scopeId == scope)
            DailyReflection(
              id: row.id,
              date: row.date,
              mood: row.mood,
              gratitude: row.gratitude,
              note: row.note,
            ),
      ]);
    }

    final sub = _db.select(_db.dailyReflections).watch().listen((_) => emit());
    final settings = _db.select(_db.appSettings).watch().listen((_) => emit());
    controller.onCancel = () async {
      await sub.cancel();
      await settings.cancel();
    };
    emit();
    return controller.stream;
  }

  @override
  Future<void> save({
    required String date,
    int? mood,
    String? gratitude,
    String? note,
  }) async {
    final scope = await DataScope(_db).current();
    final now = DateTime.now().toUtc();
    final existing =
        await (_db.select(_db.dailyReflections)..where(
              (row) =>
                  row.scopeId.equals(scope) &
                  row.date.equals(date) &
                  row.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    final id = existing?.id ?? _uuid.v4();
    final companion = DailyReflectionsCompanion.insert(
      id: id,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      scopeId: Value(scope),
      date: date,
      mood: Value(mood),
      gratitude: Value(_blank(gratitude)),
      note: Value(_blank(note)),
    );
    if (existing == null) {
      await _db.into(_db.dailyReflections).insert(companion);
    } else {
      await (_db.update(
        _db.dailyReflections,
      )..where((row) => row.id.equals(id))).write(companion);
    }
    final row = await (_db.select(
      _db.dailyReflections,
    )..where((item) => item.id.equals(id))).getSingle();
    await _enqueue(row);
  }

  Future<void> _enqueue(ReflectionRow row) async {
    final writer = outbox;
    if (writer == null) return;
    await writer.record(
      SyncRecord(
        entityType: 'reflection',
        entityKey: '${row.scopeId}|${row.date}',
        deleted: row.deletedAt != null,
        payload: {
          'id': row.id,
          'createdAt': row.createdAt.toUtc().toIso8601String(),
          'mood': row.mood,
          'gratitude': row.gratitude,
          'note': row.note,
          'scopeId': row.scopeId,
        },
        updatedAt: row.updatedAt,
        writerId: writer.writerId,
      ),
    );
  }

  String? _blank(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
