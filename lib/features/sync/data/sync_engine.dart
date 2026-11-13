import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';

class SyncRecord {
  const SyncRecord({
    required this.entityType,
    required this.entityKey,
    required this.deleted,
    required this.payload,
    required this.updatedAt,
    required this.writerId,
  });

  final String entityType;
  final String entityKey;
  final bool deleted;
  final Map<String, dynamic> payload;
  final DateTime updatedAt;
  final String writerId;

  String get identity => '$entityType:$entityKey';
}

/// Later [updatedAt] wins. Equal timestamps break the tie by [writerId]
/// so two devices reach the same row.
bool incomingWins(SyncRecord local, SyncRecord incoming) {
  final compared = incoming.updatedAt.compareTo(local.updatedAt);
  if (compared > 0) return true;
  if (compared < 0) return false;
  return incoming.writerId.compareTo(local.writerId) > 0;
}

class OutboxWriter {
  OutboxWriter(this._db);

  final AppDatabase _db;
  var suppress = false;
  String writerId = 'device';

  Future<void> record(SyncRecord record) async {
    if (suppress) return;
    final existing =
        await (_db.select(_db.syncOutbox)..where(
              (row) =>
                  row.entityType.equals(record.entityType) &
                  row.entityKey.equals(record.entityKey),
            ))
            .getSingleOrNull();
    final companion = SyncOutboxCompanion(
      entityType: Value(record.entityType),
      entityKey: Value(record.entityKey),
      deleted: Value(record.deleted),
      payload: Value(jsonEncode(record.payload)),
      rowUpdatedAt: Value(record.updatedAt),
      writerId: Value(record.writerId),
      attempts: const Value(0),
    );
    if (existing == null) {
      await _db.into(_db.syncOutbox).insert(companion);
    } else {
      await (_db.update(
        _db.syncOutbox,
      )..where((row) => row.id.equals(existing.id))).write(companion);
    }
  }

  Future<List<SyncRecord>> pending() async {
    final rows = await (_db.select(
      _db.syncOutbox,
    )..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    return [
      for (final row in rows)
        SyncRecord(
          entityType: row.entityType,
          entityKey: row.entityKey,
          deleted: row.deleted,
          payload: jsonDecode(row.payload) as Map<String, dynamic>,
          updatedAt: row.rowUpdatedAt,
          writerId: row.writerId,
        ),
    ];
  }

  Future<void> remove(SyncRecord record) {
    return (_db.delete(_db.syncOutbox)..where(
          (row) =>
              row.entityType.equals(record.entityType) &
              row.entityKey.equals(record.entityKey),
        ))
        .go();
  }
}

abstract class SyncRemote {
  Future<void> push(SyncRecord record);

  Future<List<SyncRecord>> pull();
}

class MemorySyncRemote implements SyncRemote {
  final Map<String, SyncRecord> _records = {};

  @override
  Future<void> push(SyncRecord record) async {
    final current = _records[record.identity];
    if (current == null || incomingWins(current, record)) {
      _records[record.identity] = record;
    }
  }

  @override
  Future<List<SyncRecord>> pull() async => _records.values.toList();
}

class SyncEngine {
  SyncEngine({
    required this.database,
    required this.remote,
    required this.outbox,
    required this.writerId,
  });

  final AppDatabase database;
  final SyncRemote remote;
  final OutboxWriter outbox;
  final String writerId;

  Future<void> run() async {
    for (final record in await outbox.pending()) {
      final stamped = SyncRecord(
        entityType: record.entityType,
        entityKey: record.entityKey,
        deleted: record.deleted,
        payload: record.payload,
        updatedAt: record.updatedAt,
        writerId: writerId,
      );
      await remote.push(stamped);
      await outbox.remove(record);
    }
    outbox.suppress = true;
    try {
      for (final remoteRecord in await remote.pull()) {
        await _apply(remoteRecord);
      }
    } finally {
      outbox.suppress = false;
    }
  }

  Future<void> _apply(SyncRecord record) async {
    if (record.entityType == 'habit') {
      final existing = await (database.select(
        database.habits,
      )..where((row) => row.id.equals(record.entityKey))).getSingleOrNull();
      if (existing != null) {
        final local = SyncRecord(
          entityType: 'habit',
          entityKey: existing.id,
          deleted: existing.deletedAt != null,
          payload: const {},
          updatedAt: existing.updatedAt,
          writerId: '',
        );
        if (!incomingWins(local, record)) return;
      }
      if (record.deleted) {
        await (database.update(
          database.habits,
        )..where((row) => row.id.equals(record.entityKey))).write(
          HabitsCompanion(
            deletedAt: Value(record.updatedAt),
            updatedAt: Value(record.updatedAt),
          ),
        );
        return;
      }
      final payload = record.payload;
      await database
          .into(database.habits)
          .insertOnConflictUpdate(
            HabitsCompanion.insert(
              id: record.entityKey,
              createdAt: DateTime.parse(payload['createdAt'] as String),
              updatedAt: record.updatedAt,
              deletedAt: const Value(null),
              name: payload['name'] as String,
              icon: payload['icon'] as String,
              colorKey: payload['colorKey'] as String,
              type: payload['type'] as String,
              frequencyType: payload['frequencyType'] as String,
              startDate: payload['startDate'] as String,
              scopeId: Value(payload['scopeId'] as String? ?? record.writerId),
              weekdays: Value(
                (payload['weekdays'] as List<dynamic>? ?? []).join(','),
              ),
              targetValue: Value(
                (payload['targetValue'] as num?)?.toDouble() ?? 1,
              ),
              timesPerWeek: Value(payload['timesPerWeek'] as int? ?? 1),
            ),
          );
      return;
    }
    if (record.entityType == 'completion') {
      await _applyCompletion(record);
    }
  }

  Future<void> _applyCompletion(SyncRecord record) async {
    final split = record.entityKey.indexOf('|');
    if (split <= 0) return;
    final habitId = record.entityKey.substring(0, split);
    final date = record.entityKey.substring(split + 1);
    final existing =
        await (database.select(database.habitCompletions)..where(
              (row) => row.habitId.equals(habitId) & row.date.equals(date),
            ))
            .getSingleOrNull();
    if (existing != null) {
      final local = SyncRecord(
        entityType: 'completion',
        entityKey: record.entityKey,
        deleted: existing.deletedAt != null,
        payload: const {},
        updatedAt: existing.updatedAt,
        writerId: '',
      );
      if (!incomingWins(local, record)) return;
    }
    final payload = record.payload;
    final createdAt = DateTime.parse(payload['createdAt'] as String);
    final companion = HabitCompletionsCompanion(
      id: Value(existing?.id ?? payload['id'] as String? ?? record.entityKey),
      createdAt: Value(existing?.createdAt ?? createdAt),
      updatedAt: Value(record.updatedAt),
      deletedAt: Value(record.deleted ? record.updatedAt : null),
      habitId: Value(habitId),
      date: Value(date),
      value: Value((payload['value'] as num?)?.toDouble() ?? 1),
      note: Value(payload['note'] as String?),
      completedAt: Value(
        payload['completedAt'] == null
            ? null
            : DateTime.parse(payload['completedAt'] as String),
      ),
      scopeId: Value(payload['scopeId'] as String? ?? 'guest'),
    );
    if (existing == null) {
      await database.into(database.habitCompletions).insert(companion);
      return;
    }
    await (database.update(
      database.habitCompletions,
    )..where((row) => row.id.equals(existing.id))).write(companion);
  }
}
