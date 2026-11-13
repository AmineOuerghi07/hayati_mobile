import 'package:material_ui/material_ui.dart';

/// Seed for [ColorScheme.fromSeed]. Filled buttons do not use the seed:
/// white text on #10B981 is hard to read, so they use [hayatiFilledButtonColor].
const hayatiSeedColor = Color(0xFF10B981);
const hayatiFilledButtonColor = Color(0xFF047857);
const hayatiFontFamily = 'IBMPlexSansArabic';

ThemeData buildHayatiTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: hayatiSeedColor,
    brightness: brightness,
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
        backgroundColor: hayatiFilledButtonColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: hayatiFilledButtonColor.withValues(
          alpha: 0.38,
        ),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.70),
      ),
    ),
  );
}
