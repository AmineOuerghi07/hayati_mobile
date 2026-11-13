import 'package:hayati/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// The on-device database.
///
/// keepAlive because every feature shares this connection for the life of
/// the process. Tests override it with an in-memory database.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase.persistent();
  ref.onDispose(database.close);
  return database;
}
