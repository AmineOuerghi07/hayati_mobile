import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/celebration_overlay.dart';
import 'package:hayati/core/widgets/check_button.dart';
import 'package:hayati/core/widgets/concentric_rings.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/today_hero.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    theme: buildHayatiTheme(AppThemeId.hayati, Brightness.light),
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reduceMotion,
        ),
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  test('the daily quote is stable for a day and changes the next', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final morning = dailyQuote(l10n, DateTime(2026, 3, 4, 7));
    final night = dailyQuote(l10n, DateTime(2026, 3, 4, 23));
    final tomorrow = dailyQuote(l10n, DateTime(2026, 3, 5, 7));
    expect(morning, night);
    expect(morning, isNot(tomorrow));
  });

  for (final locale in const [Locale('en'), Locale('ar')]) {
    testWidgets('the Today hero fits at double text size in $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _host(
          const Padding(
            padding: EdgeInsets.all(16),
            child: TodayHero(
              greeting: 'Good morning',
              dateLabel: 'Saturday, November 14',
              quote: 'Progress, not perfection.',
              counts: DayCounts(done: 2, due: 5),
              bestStreak: 12,
            ),
          ),
          textScale: 2,
          locale: locale,
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      expect(find.textContaining('12'), findsOneWidget);
    });
  }

  testWidgets('the check button fills and keeps its tooltip', (tester) async {
    var checked = false;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => Center(
            child: AnimatedCheckButton(
              checked: checked,
              color: Colors.teal,
              tooltip: 'Read',
              onPressed: () => setState(() => checked = !checked),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Read'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(checked, isTrue);
    expect(
      tester.getSemantics(find.byType(AnimatedCheckButton)),
      isSemantics(isChecked: true, isButton: true),
    );
  });

  testWidgets('rings keep the center label inside at 100 percent', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const Center(
          child: ConcentricRings(
            size: 136,
            strokeWidth: 13,
            semanticsLabel: 'Today 100 percent',
            rings: [
              RingValue(value: 1, color: Colors.teal),
              RingValue(value: 0.5, color: Colors.indigo),
              RingValue(value: null, color: Colors.amber),
            ],
            center: Text('100%'),
          ),
        ),
        textScale: 2,
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
    final rings = tester.getRect(find.byType(ConcentricRings));
    final label = tester.getRect(find.text('100%'));
    final hole = rings.deflate(13 * 3);
    expect(hole.contains(label.topLeft), isTrue);
    expect(hole.contains(label.bottomRight), isTrue);
  });

  testWidgets('the celebration shows its message with reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const CelebrationOverlay(message: 'All done for today'),
        reduceMotion: true,
      ),
    );
    await tester.pump();
    expect(find.text('All done for today'), findsOneWidget);
    await tester.pump(celebrationDuration);
  });
}
