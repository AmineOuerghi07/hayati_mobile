import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/hayati_app.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const ProviderScope(child: HayatiApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('today, stats, and settings are reachable', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Today'), findsWidgets);
    expect(
      find.text('Habits you are working on will show up here.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('Insights are coming in a later update.'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Development'), findsOneWidget);
  });

  testWidgets('Arabic selection mirrors the layout', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();

    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('اللغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('اللغة'))),
      TextDirection.rtl,
    );
  });

  testWidgets('French selection uses the French strings', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();

    expect(find.text("Aujourd'hui"), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);
    expect(find.text('Développement'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Langue'))),
      TextDirection.ltr,
    );
  });
}
