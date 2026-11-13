import 'package:drift/drift.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get colorKey => text()();
  TextColumn get type => text()();
  RealColumn get targetValue => real().withDefault(const Constant(1))();
  TextColumn get unit => text().nullable()();
  TextColumn get frequencyType => text()();
  TextColumn get weekdays => text().withDefault(const Constant(''))();
  IntColumn get timesPerWeek => integer().withDefault(const Constant(1))();
  IntColumn get reminderTime => integer().nullable()();
  TextColumn get startDate => text()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CompletionRow')
class HabitCompletions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get habitId => text()();
  TextColumn get date => text()();
  RealColumn get value => real().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {habitId, date},
  ];
}

@DataClassName('SettingRow')
class AppSettings extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {settingKey},
  ];
}
