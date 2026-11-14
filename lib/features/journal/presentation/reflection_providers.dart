import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/database/database_provider.dart';
import 'package:hayati/features/journal/data/drift_reflection_repository.dart';
import 'package:hayati/features/journal/domain/daily_reflection.dart';
import 'package:hayati/features/journal/domain/reflection_repository.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';

final reflectionRepositoryProvider = Provider<ReflectionRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftReflectionRepository(
    database,
    outbox: OutboxWriter(database)..writerId = 'this-device',
  );
});

final reflectionsProvider = StreamProvider<List<DailyReflection>>((ref) {
  return ref.watch(reflectionRepositoryProvider).watchAll();
});
