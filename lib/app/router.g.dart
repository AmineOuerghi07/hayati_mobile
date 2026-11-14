// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App navigation.
///
/// keepAlive because replacing the [GoRouter] clears the back stack. Locale
/// and theme are read by the app widget, not here, so changing them does
/// not rebuild this router. The introduction flag is the one exception:
/// finishing it or replaying it refreshes the redirect.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// App navigation.
///
/// keepAlive because replacing the [GoRouter] clears the back stack. Locale
/// and theme are read by the app widget, not here, so changing them does
/// not rebuild this router. The introduction flag is the one exception:
/// finishing it or replaying it refreshes the redirect.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// App navigation.
  ///
  /// keepAlive because replacing the [GoRouter] clears the back stack. Locale
  /// and theme are read by the app widget, not here, so changing them does
  /// not rebuild this router. The introduction flag is the one exception:
  /// finishing it or replaying it refreshes the redirect.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'7e6be891a894d20c214c9fff9c2a7475b973a83c';
