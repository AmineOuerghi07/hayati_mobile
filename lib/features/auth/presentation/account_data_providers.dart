import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/database/database_provider.dart';
import 'package:hayati/features/auth/data/local_account_data_repository.dart';
import 'package:hayati/features/sync/presentation/sync_providers.dart';

final accountDataRepositoryProvider = Provider<LocalAccountDataRepository>((
  ref,
) {
  return LocalAccountDataRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncRemoteProvider),
  );
});
