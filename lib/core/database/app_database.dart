import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hayati/core/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Habits,
    HabitCompletions,
    AppSettings,
    LocalAccounts,
    AuthChallenges,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// File-backed database in the app documents directory.
  AppDatabase.persistent() : super(driftDatabase(name: 'hayati'));

  @override
  int get schemaVersion => 2;

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
    },
  );
}
