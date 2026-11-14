// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// keepAlive because the session is read by the profile on every tab.
/// The implementation is the local fake. A later adapter can replace this
/// provider without changing the screens.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// keepAlive because the session is read by the profile on every tab.
/// The implementation is the local fake. A later adapter can replace this
/// provider without changing the screens.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// keepAlive because the session is read by the profile on every tab.
  /// The implementation is the local fake. A later adapter can replace this
  /// provider without changing the screens.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'c8650bc889a0e51f6bebf3d110a8706e1d61b6f4';

@ProviderFor(authSession)
final authSessionProvider = AuthSessionProvider._();

final class AuthSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthSession>,
          AuthSession,
          Stream<AuthSession>
        >
    with $FutureModifier<AuthSession>, $StreamProvider<AuthSession> {
  AuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionHash();

  @$internal
  @override
  $StreamProviderElement<AuthSession> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AuthSession> create(Ref ref) {
    return authSession(ref);
  }
}

String _$authSessionHash() => r'74b9780c9cc0bf64cf0621fe212314d53f294558';
