import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hayati/core/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitCompletions, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// File-backed database in the app documents directory.
  AppDatabase.persistent() : super(driftDatabase(name: 'hayati'));

  @override
  int get schemaVersion => 1;
}
