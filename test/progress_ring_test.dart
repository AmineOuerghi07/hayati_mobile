import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/progress_ring.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the percent stays inside the ring at 0, 50, and 100', (
    tester,
  ) async {
    for (final entry in const [(0.0, '0%'), (0.5, '50%'), (1.0, '100%')]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildHayatiTheme(AppThemeId.hayati, Brightness.light),
          home: Center(
            child: ProgressRing(
              value: entry.$1,
              centerLabel: entry.$2,
              semanticsLabel: 'Today ${entry.$2}',
              size: 72,
              strokeWidth: 8,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final ring = tester.getRect(find.byType(ProgressRing));
      final text = tester.getRect(find.text(entry.$2));
      final hole = ring.deflate(8);
      expect(hole.contains(text.center), isTrue);
      expect(text.left, greaterThanOrEqualTo(hole.left - 0.5));
      expect(text.right, lessThanOrEqualTo(hole.right + 0.5));
    }
  });

  testWidgets('100% still fits when text is twice as large', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildHayatiTheme(AppThemeId.hayati, Brightness.light),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Center(
            child: ProgressRing(
              value: 1,
              centerLabel: '100%',
              semanticsLabel: 'Today 100 percent',
              size: 72,
              strokeWidth: 8,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final ring = tester.getRect(find.byType(ProgressRing));
    final text = tester.getRect(find.text('100%'));
    expect(ring.deflate(8).contains(text.center), isTrue);
  });
}
