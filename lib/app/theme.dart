import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const hayatiFontFamily = 'IBMPlexSansArabic';

/// Spacing, radii, and motion shared by every screen.
class HayatiTokens extends ThemeExtension<HayatiTokens> {
  const HayatiTokens({
    required this.cardTint,
    required this.warmSurface,
    this.space4 = 4,
    this.space8 = 8,
    this.space12 = 12,
    this.space16 = 16,
    this.space24 = 24,
    this.space32 = 32,
    this.radiusChip = 12,
    this.radiusCard = 20,
    this.radiusSheet = 28,
    this.motionFast = const Duration(milliseconds: 150),
    this.motionMedium = const Duration(milliseconds: 250),
    this.motionSlow = const Duration(milliseconds: 400),
    this.easeOut = Curves.easeOutCubic,
    this.checkOff = const Cubic(0.2, 1.15, 0.3, 1),
  });

  final Color cardTint;
  final Color warmSurface;
  final double space4;
  final double space8;
  final double space12;
  final double space16;
  final double space24;
  final double space32;
  final double radiusChip;
  final double radiusCard;
  final double radiusSheet;
  final Duration motionFast;
  final Duration motionMedium;
  final Duration motionSlow;
  final Curve easeOut;
  final Curve checkOff;

  static const fallback = HayatiTokens(
    cardTint: Color(0xFFFFFCF8),
    warmSurface: Color(0xFFF6F1EA),
  );

  static HayatiTokens of(BuildContext context) {
    return Theme.of(context).extension<HayatiTokens>() ?? fallback;
  }

  Duration motion(BuildContext context, Duration duration) {
    if (MediaQuery.disableAnimationsOf(context)) return Duration.zero;
    return duration;
  }

  @override
  HayatiTokens copyWith({
    Color? cardTint,
    Color? warmSurface,
    double? space4,
    double? space8,
    double? space12,
    double? space16,
    double? space24,
    double? space32,
    double? radiusChip,
    double? radiusCard,
    double? radiusSheet,
    Duration? motionFast,
    Duration? motionMedium,
    Duration? motionSlow,
    Curve? easeOut,
    Curve? checkOff,
  }) {
    return HayatiTokens(
      cardTint: cardTint ?? this.cardTint,
      warmSurface: warmSurface ?? this.warmSurface,
      space4: space4 ?? this.space4,
      space8: space8 ?? this.space8,
      space12: space12 ?? this.space12,
      space16: space16 ?? this.space16,
      space24: space24 ?? this.space24,
      space32: space32 ?? this.space32,
      radiusChip: radiusChip ?? this.radiusChip,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusSheet: radiusSheet ?? this.radiusSheet,
      motionFast: motionFast ?? this.motionFast,
      motionMedium: motionMedium ?? this.motionMedium,
      motionSlow: motionSlow ?? this.motionSlow,
      easeOut: easeOut ?? this.easeOut,
      checkOff: checkOff ?? this.checkOff,
    );
  }

  @override
  HayatiTokens lerp(ThemeExtension<HayatiTokens>? other, double t) {
    if (other is! HayatiTokens) return this;
    return HayatiTokens(
      cardTint: Color.lerp(cardTint, other.cardTint, t) ?? cardTint,
      warmSurface: Color.lerp(warmSurface, other.warmSurface, t) ?? warmSurface,
      space4: _lerpDouble(space4, other.space4, t),
      space8: _lerpDouble(space8, other.space8, t),
      space12: _lerpDouble(space12, other.space12, t),
      space16: _lerpDouble(space16, other.space16, t),
      space24: _lerpDouble(space24, other.space24, t),
      space32: _lerpDouble(space32, other.space32, t),
      radiusChip: _lerpDouble(radiusChip, other.radiusChip, t),
      radiusCard: _lerpDouble(radiusCard, other.radiusCard, t),
      radiusSheet: _lerpDouble(radiusSheet, other.radiusSheet, t),
      motionFast: t < 0.5 ? motionFast : other.motionFast,
      motionMedium: t < 0.5 ? motionMedium : other.motionMedium,
      motionSlow: t < 0.5 ? motionSlow : other.motionSlow,
      easeOut: t < 0.5 ? easeOut : other.easeOut,
      checkOff: t < 0.5 ? checkOff : other.checkOff,
    );
  }
}

double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

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
  final generated = ColorScheme.fromSeed(
    seedColor: preset.seed,
    brightness: brightness,
    contrastLevel: preset.contrastLevel,
  );
  final colorScheme = _calmScheme(generated, brightness, preset.seed);
  final tokens = HayatiTokens(
    cardTint: colorScheme.surfaceContainerLowest,
    warmSurface: colorScheme.surface,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,
    fontFamily: hayatiFontFamily,
    scaffoldBackgroundColor: colorScheme.surface,
    splashFactory: InkRipple.splashFactory,
    extensions: [tokens],
  );
  final textTheme = base.textTheme
      .copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.05,
          letterSpacing: -0.8,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.15,
          letterSpacing: -0.3,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      )
      .apply(
        fontFamily: hayatiFontFamily,
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      );
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  return base.copyWith(
    textTheme: textTheme,
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: hayatiFontFamily),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: tokens.cardTint,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      indicatorColor: colorScheme.primary.withValues(alpha: 0.22),
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 72,
      labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: tokens.cardTint,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.radiusSheet),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: tokens.cardTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radiusChip),
      ),
      side: BorderSide.none,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      minVerticalPadding: 12,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusChip),
          ),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: preset.filled,
        foregroundColor: Colors.white,
        disabledBackgroundColor: preset.filled.withValues(alpha: 0.38),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.70),
        minimumSize: const Size(48, 48),
        shape: buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: buttonShape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: preset.filled,
      foregroundColor: Colors.white,
      extendedPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      space: 1,
    ),
  );
}

ColorScheme _calmScheme(ColorScheme scheme, Brightness brightness, Color seed) {
  final light = brightness == Brightness.light;
  final warm = light ? const Color(0xFFF3EEE6) : const Color(0xFF141210);
  final paper = light ? const Color(0xFFFFFBF6) : const Color(0xFF1C1917);
  final wash = light ? 0.20 : 0.16;
  final surface = Color.alphaBlend(seed.withValues(alpha: wash), warm);
  final card = Color.alphaBlend(
    seed.withValues(alpha: light ? 0.12 : 0.10),
    paper,
  );
  return scheme.copyWith(
    surface: surface,
    surfaceContainerLowest: card,
    surfaceContainerLow: Color.alphaBlend(
      seed.withValues(alpha: light ? 0.16 : 0.12),
      surface,
    ),
    surfaceContainer: Color.alphaBlend(
      seed.withValues(alpha: light ? 0.24 : 0.16),
      surface,
    ),
    surfaceContainerHigh: Color.alphaBlend(
      seed.withValues(alpha: light ? 0.30 : 0.20),
      surface,
    ),
    primaryContainer: Color.alphaBlend(
      seed.withValues(alpha: light ? 0.34 : 0.42),
      light ? paper : scheme.surface,
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
