import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hayati/core/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Habits,
    HabitCompletions,
    AppSettings,
    LocalAccounts,
    AuthChallenges,
    SyncOutbox,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// File-backed database in the app documents directory.
  ///
  /// The connection stays on the UI isolate. A background isolate never
  /// delivered its first result on the Android emulator used in CI.
  AppDatabase.persistent()
    : super(
        DatabaseConnection.delayed(
          Future(() async {
            final cache = await getTemporaryDirectory();
            sqlite3.tempDirectory = cache.path;
            final directory = await getApplicationDocumentsDirectory();
            final file = File(p.join(directory.path, 'hayati.sqlite'));
            return DatabaseConnection(NativeDatabase(file));
          }),
        ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(habits, habits.scopeId);
        await migrator.addColumn(habitCompletions, habitCompletions.scopeId);
        await migrator.createTable(localAccounts);
        await migrator.createTable(authChallenges);
      }
      if (from < 3) {
        await migrator.createTable(syncOutbox);
      }
    },
  );
}
