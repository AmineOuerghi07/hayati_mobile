// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One in-memory remote for this process. The Supabase adapter replaces this
/// provider later. keepAlive so a sync from the profile and a later sync
/// see the same server.

@ProviderFor(syncRemote)
final syncRemoteProvider = SyncRemoteProvider._();

/// One in-memory remote for this process. The Supabase adapter replaces this
/// provider later. keepAlive so a sync from the profile and a later sync
/// see the same server.

final class SyncRemoteProvider
    extends
        $FunctionalProvider<
          MemorySyncRemote,
          MemorySyncRemote,
          MemorySyncRemote
        >
    with $Provider<MemorySyncRemote> {
  /// One in-memory remote for this process. The Supabase adapter replaces this
  /// provider later. keepAlive so a sync from the profile and a later sync
  /// see the same server.
  SyncRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRemoteHash();

  @$internal
  @override
  $ProviderElement<MemorySyncRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MemorySyncRemote create(Ref ref) {
    return syncRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemorySyncRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemorySyncRemote>(value),
    );
  }
}

String _$syncRemoteHash() => r'4b48d4433ec476bcaaca8ca3053fce0d017b2fd6';

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

final class SyncControllerProvider
    extends $NotifierProvider<SyncController, String> {
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$syncControllerHash() => r'87e3c23d9925053a57bd00d9ac84916fc2f4b976';

abstract class _$SyncController extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
