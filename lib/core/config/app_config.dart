/// Matches `version` in pubspec.yaml. Shown on the profile screen.
const hayatiVersion = '0.1.0';

/// Which installable variant of the app this binary is.
enum AppFlavor { dev, prod }

/// Compile-time configuration.
///
/// The flavor selects the native app id and display name. Supabase values
/// stay empty until auth is wired, and they only ever come from
/// `--dart-define`, never from a file in the repo.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get isDev => flavor == AppFlavor.dev;

  /// [flavorName] is the native flavor (`appFlavor` from `--flavor`).
  /// `APP_FLAVOR` wins when it is set, so tests can pin the flavor without
  /// a native build.
  factory AppConfig.fromEnvironment({String? flavorName}) {
    const override = String.fromEnvironment('APP_FLAVOR');
    final name = override.isNotEmpty ? override : flavorName;
    return AppConfig(
      flavor: parseAppFlavor(name),
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }
}

/// Maps a flavor name to [AppFlavor].
///
/// A missing name means prod, so an unflavored archive does not present
/// itself as a development build. `dev` and `prod` are the only names.
AppFlavor parseAppFlavor(String? name) {
  return switch (name) {
    null || '' || 'prod' => AppFlavor.prod,
    'dev' => AppFlavor.dev,
    _ => throw ArgumentError.value(name, 'flavor', 'Expected dev or prod.'),
  };
}
