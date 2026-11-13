import 'package:hayati/core/database/database_provider.dart';
import 'package:hayati/features/auth/data/fake_auth_repository.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// keepAlive because the session is read by the profile on every tab.
/// The implementation is the local fake. A later adapter can replace this
/// provider without changing the screens.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FakeAuthRepository(ref.watch(appDatabaseProvider));
}

@riverpod
Stream<AuthSession> authSession(Ref ref) {
  return ref.watch(authRepositoryProvider).watch();
}
