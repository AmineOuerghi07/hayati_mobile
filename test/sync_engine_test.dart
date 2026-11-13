import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/features/habits/data/drift_habit_repository.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('a newer edit wins when two devices sync the same habit', () async {
    final first = AppDatabase(NativeDatabase.memory());
    final second = AppDatabase(NativeDatabase.memory());
    final remote = MemorySyncRemote();
    final outA = OutboxWriter(first)..writerId = 'device-a';
    final outB = OutboxWriter(second)..writerId = 'device-b';
    addTearDown(first.close);
    addTearDown(second.close);

    final habitsA = DriftHabitRepository(first, outbox: outA);
    final created = await habitsA.create(
      const HabitDraft(
        name: 'Water',
        icon: 'water',
        colorKey: 'sea',
        type: HabitType.boolean,
        frequencyType: FrequencyType.daily,
        startDate: '2026-03-01',
      ),
    );
    await SyncEngine(
      database: first,
      remote: remote,
      outbox: outA,
      writerId: 'device-a',
    ).run();
    await SyncEngine(
      database: second,
      remote: remote,
      outbox: outB,
      writerId: 'device-b',
    ).run();

    final onSecond = await second.select(second.habits).getSingle();
    expect(onSecond.name, 'Water');

    final habitsB = DriftHabitRepository(second, outbox: outB);
    final stored = await habitsB.watchById(created.id).first;
    await habitsB.update(
      stored!.copyWith(name: 'Water late', updatedAt: DateTime.utc(2026, 3, 3)),
    );
    await habitsA.update(
      created.copyWith(
        name: 'Water early',
        updatedAt: DateTime.utc(2026, 3, 2),
      ),
    );

    await SyncEngine(
      database: second,
      remote: remote,
      outbox: outB,
      writerId: 'device-b',
    ).run();
    await SyncEngine(
      database: first,
      remote: remote,
      outbox: outA,
      writerId: 'device-a',
    ).run();

    final winner = await first.select(first.habits).getSingle();
    expect(winner.name, 'Water late');
  });

  test('an equal timestamp breaks the tie by writer id', () {
    final time = DateTime.utc(2026, 3, 1);
    final local = SyncRecord(
      entityType: 'habit',
      entityKey: '1',
      deleted: false,
      payload: const {},
      updatedAt: time,
      writerId: 'a',
    );
    final incoming = SyncRecord(
      entityType: 'habit',
      entityKey: '1',
      deleted: false,
      payload: const {},
      updatedAt: time,
      writerId: 'b',
    );
    expect(incomingWins(local, incoming), isTrue);
    expect(incomingWins(incoming, local), isFalse);
  });
}
