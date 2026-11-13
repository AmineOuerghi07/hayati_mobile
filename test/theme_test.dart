import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every palette keeps the font and white text on its filled button', () {
    for (final preset in appThemes) {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final theme = buildHayatiTheme(preset.id, brightness);
        final background = theme.filledButtonTheme.style?.backgroundColor
            ?.resolve(const <WidgetState>{});
        final foreground = theme.filledButtonTheme.style?.foregroundColor
            ?.resolve(const <WidgetState>{});

        expect(theme.useMaterial3, isTrue);
        expect(theme.textTheme.bodyMedium?.fontFamily, hayatiFontFamily);
        expect(background, preset.filled);
        expect(foreground, Colors.white);
      }
    }
  });

  test('appearance maps onto ThemeMode', () {
    expect(themeModeFor(Appearance.system), ThemeMode.system);
    expect(themeModeFor(Appearance.light), ThemeMode.light);
    expect(themeModeFor(Appearance.dark), ThemeMode.dark);
  });
}
