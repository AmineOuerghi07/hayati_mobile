// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'a69d11b66dc0d826953593045b4f011044931d9e';

/// The saved language, palette, brightness, and week start.
///
/// keepAlive so a route change cannot drop the choice back to the defaults
/// while the settings screen is off stage. The stream comes from Drift, so
/// a write shows up on the next frame.

@ProviderFor(PreferencesController)
final preferencesControllerProvider = PreferencesControllerProvider._();

/// The saved language, palette, brightness, and week start.
///
/// keepAlive so a route change cannot drop the choice back to the defaults
/// while the settings screen is off stage. The stream comes from Drift, so
/// a write shows up on the next frame.
final class PreferencesControllerProvider
    extends $StreamNotifierProvider<PreferencesController, AppPreferences> {
  /// The saved language, palette, brightness, and week start.
  ///
  /// keepAlive so a route change cannot drop the choice back to the defaults
  /// while the settings screen is off stage. The stream comes from Drift, so
  /// a write shows up on the next frame.
  PreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesControllerHash();

  @$internal
  @override
  PreferencesController create() => PreferencesController();
}

String _$preferencesControllerHash() =>
    r'fe62a707cdea9f39ff41cc2ee116580fc5b56d41';

/// The saved language, palette, brightness, and week start.
///
/// keepAlive so a route change cannot drop the choice back to the defaults
/// while the settings screen is off stage. The stream comes from Drift, so
/// a write shows up on the next frame.

abstract class _$PreferencesController extends $StreamNotifier<AppPreferences> {
  Stream<AppPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppPreferences>, AppPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppPreferences>, AppPreferences>,
              AsyncValue<AppPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
