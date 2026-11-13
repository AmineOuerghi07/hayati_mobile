import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('light and dark themes share the font and filled button color', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = buildHayatiTheme(brightness);
      final background = theme.filledButtonTheme.style?.backgroundColor
          ?.resolve(const <WidgetState>{});
      final foreground = theme.filledButtonTheme.style?.foregroundColor
          ?.resolve(const <WidgetState>{});

      expect(theme.useMaterial3, isTrue);
      expect(theme.textTheme.bodyMedium?.fontFamily, hayatiFontFamily);
      expect(theme.textTheme.headlineMedium?.fontFamily, hayatiFontFamily);
      expect(background, hayatiFilledButtonColor);
      expect(foreground, Colors.white);
    }
  });
}
