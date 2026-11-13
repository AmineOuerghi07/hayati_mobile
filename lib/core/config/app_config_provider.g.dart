// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flavor and dart-define values for this process.
///
/// keepAlive because the values are fixed at compile time. Recreating the
/// provider when a screen is disposed would suggest they can change.

@ProviderFor(appConfig)
final appConfigProvider = AppConfigProvider._();

/// Flavor and dart-define values for this process.
///
/// keepAlive because the values are fixed at compile time. Recreating the
/// provider when a screen is disposed would suggest they can change.

final class AppConfigProvider
    extends $FunctionalProvider<AppConfig, AppConfig, AppConfig>
    with $Provider<AppConfig> {
  /// Flavor and dart-define values for this process.
  ///
  /// keepAlive because the values are fixed at compile time. Recreating the
  /// provider when a screen is disposed would suggest they can change.
  AppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigHash();

  @$internal
  @override
  $ProviderElement<AppConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppConfig create(Ref ref) {
    return appConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfig>(value),
    );
  }
}

String _$appConfigHash() => r'2a59b5e331b90d2320a74440ef7fef187865c71d';
