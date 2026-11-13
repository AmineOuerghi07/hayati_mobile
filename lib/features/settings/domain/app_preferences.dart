/// Which palette the app paints with. Light and dark are separate: every
/// palette has both, and [Appearance] picks which one is on screen.
enum AppThemeId { hayati, oasis, dawn, dusk, blossom, sea, ink, contrast }

/// System follows the phone. Light and dark force a brightness.
enum Appearance { system, light, dark }

class AppPreferences {
  const AppPreferences({
    required this.localeCode,
    required this.themeId,
    required this.appearance,
    required this.weekStart,
    this.analyticsEnabled = false,
    this.onboardingDone = false,
  });

  /// Null follows the device language.
  final String? localeCode;
  final AppThemeId themeId;
  final Appearance appearance;

  /// 1 = Monday through 7 = Sunday.
  final int weekStart;

  /// Opt-in for a future crash and usage reporter. Nothing is sent while this
  /// stays off, and the current reporter is a no-op even when it is on.
  final bool analyticsEnabled;

  /// False until the first-run introduction is finished or skipped.
  final bool onboardingDone;

  static const fallback = AppPreferences(
    localeCode: null,
    themeId: AppThemeId.hayati,
    appearance: Appearance.system,
    weekStart: DateTime.monday,
  );

  AppPreferences copyWith({
    String? localeCode,
    bool clearLocale = false,
    AppThemeId? themeId,
    Appearance? appearance,
    int? weekStart,
    bool? analyticsEnabled,
    bool? onboardingDone,
  }) {
    return AppPreferences(
      localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
      themeId: themeId ?? this.themeId,
      appearance: appearance ?? this.appearance,
      weekStart: weekStart ?? this.weekStart,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}
