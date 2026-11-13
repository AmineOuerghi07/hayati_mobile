import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const hayatiFontFamily = 'IBMPlexSansArabic';

class AppThemePreset {
  const AppThemePreset({
    required this.id,
    required this.seed,
    required this.filled,
    this.contrastLevel = 0,
  });

  final AppThemeId id;
  final Color seed;

  /// Dark enough that white label text stays readable.
  final Color filled;
  final double contrastLevel;
}

/// Named palettes. Each one has a light scheme and a dark scheme.
/// Appearance (system, light, dark) chooses which of those is showing.
const appThemes = <AppThemePreset>[
  AppThemePreset(
    id: AppThemeId.hayati,
    seed: Color(0xFF10B981),
    filled: Color(0xFF047857),
  ),
  AppThemePreset(
    id: AppThemeId.oasis,
    seed: Color(0xFF0F766E),
    filled: Color(0xFF115E59),
  ),
  AppThemePreset(
    id: AppThemeId.dawn,
    seed: Color(0xFFD97706),
    filled: Color(0xFF92400E),
  ),
  AppThemePreset(
    id: AppThemeId.dusk,
    seed: Color(0xFF4F46E5),
    filled: Color(0xFF3730A3),
  ),
  AppThemePreset(
    id: AppThemeId.blossom,
    seed: Color(0xFFE11D48),
    filled: Color(0xFF9F1239),
  ),
  AppThemePreset(
    id: AppThemeId.sea,
    seed: Color(0xFF0369A1),
    filled: Color(0xFF075985),
  ),
  AppThemePreset(
    id: AppThemeId.ink,
    seed: Color(0xFF334155),
    filled: Color(0xFF0F172A),
  ),
  AppThemePreset(
    id: AppThemeId.contrast,
    seed: Color(0xFF10B981),
    filled: Color(0xFF064E3B),
    contrastLevel: 1,
  ),
];

AppThemePreset presetFor(AppThemeId id) {
  return appThemes.firstWhere((preset) => preset.id == id);
}

String themeLabel(AppLocalizations l10n, AppThemeId id) {
  return switch (id) {
    AppThemeId.hayati => l10n.themeHayati,
    AppThemeId.oasis => l10n.themeOasis,
    AppThemeId.dawn => l10n.themeDawn,
    AppThemeId.dusk => l10n.themeDusk,
    AppThemeId.blossom => l10n.themeBlossom,
    AppThemeId.sea => l10n.themeSea,
    AppThemeId.ink => l10n.themeInk,
    AppThemeId.contrast => l10n.themeContrast,
  };
}

ThemeData buildHayatiTheme(AppThemeId id, Brightness brightness) {
  final preset = presetFor(id);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: preset.seed,
    brightness: brightness,
    contrastLevel: preset.contrastLevel,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,
    fontFamily: hayatiFontFamily,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: hayatiFontFamily),
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: hayatiFontFamily),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: preset.filled,
        foregroundColor: Colors.white,
        disabledBackgroundColor: preset.filled.withValues(alpha: 0.38),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.70),
      ),
    ),
  );
}

ThemeMode themeModeFor(Appearance appearance) {
  return switch (appearance) {
    Appearance.system => ThemeMode.system,
    Appearance.light => ThemeMode.light,
    Appearance.dark => ThemeMode.dark,
  };
}
