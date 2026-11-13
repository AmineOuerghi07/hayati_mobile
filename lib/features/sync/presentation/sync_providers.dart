import 'package:hayati/core/database/database_provider.dart';
import 'package:hayati/features/sync/data/sync_engine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_providers.g.dart';

/// One in-memory remote for this process. The Supabase adapter replaces this
/// provider later. keepAlive so a sync from the profile and a later sync
/// see the same server.
@Riverpod(keepAlive: true)
MemorySyncRemote syncRemote(Ref ref) => MemorySyncRemote();

@riverpod
class SyncController extends _$SyncController {
  @override
  String build() => 'idle';

  Future<void> syncNow() async {
    state = 'syncing';
    final database = ref.read(appDatabaseProvider);
    final outbox = OutboxWriter(database)..writerId = 'this-device';
    await SyncEngine(
      database: database,
      remote: ref.read(syncRemoteProvider),
      outbox: outbox,
      writerId: 'this-device',
    ).run();
    state = 'idle';
  }
}
