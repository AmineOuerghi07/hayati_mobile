// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Locale override chosen in Settings.
///
/// Null follows the device. Nothing is persisted yet; the Drift settings
/// table arrives with the habit flows. keepAlive so the choice survives
/// leaving Settings, instead of resetting when the page is no longer watched.

@ProviderFor(LocaleController)
final localeControllerProvider = LocaleControllerProvider._();

/// Locale override chosen in Settings.
///
/// Null follows the device. Nothing is persisted yet; the Drift settings
/// table arrives with the habit flows. keepAlive so the choice survives
/// leaving Settings, instead of resetting when the page is no longer watched.
final class LocaleControllerProvider
    extends $NotifierProvider<LocaleController, Locale?> {
  /// Locale override chosen in Settings.
  ///
  /// Null follows the device. Nothing is persisted yet; the Drift settings
  /// table arrives with the habit flows. keepAlive so the choice survives
  /// leaving Settings, instead of resetting when the page is no longer watched.
  LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeControllerHash() => r'e4d0fa49dd5ce82781813ee90666612f088cf486';

/// Locale override chosen in Settings.
///
/// Null follows the device. Nothing is persisted yet; the Drift settings
/// table arrives with the habit flows. keepAlive so the choice survives
/// leaving Settings, instead of resetting when the page is no longer watched.

abstract class _$LocaleController extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
