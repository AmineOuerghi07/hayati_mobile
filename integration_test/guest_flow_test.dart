import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _until(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) return;
  }
  final visible = find
      .byType(Text)
      .evaluate()
      .map((element) => (element.widget as Text).data)
      .whereType<String>()
      .join(' | ');
  final loading = find.byKey(const Key('today-loading')).evaluate().isNotEmpty;
  fail(
    'Timed out waiting for $finder. '
    'Loading: $loading. Visible text: $visible',
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a guest can add a habit and open stats', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    app.main();
    await _until(
      tester,
      find.byWidgetPredicate((widget) {
        if (widget is! Text) return false;
        final value = widget.data ?? '';
        return value == 'Skip' ||
            value == 'Nothing due today' ||
            value == 'لا شيء مستحق اليوم' ||
            value.contains('aujourd');
      }),
      timeout: const Duration(seconds: 90),
    );
    final skip = find.text('Skip');
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip.first);
      await tester.pump();
    }
    await _until(
      tester,
      find.byWidgetPredicate((widget) {
        if (widget is! Text) return false;
        final value = widget.data ?? '';
        return value == 'Nothing due today' ||
            value == 'لا شيء مستحق اليوم' ||
            value.contains('aujourd');
      }),
    );

    await tester.tap(find.text('Add habit'));
    await _until(tester, find.byType(TextField));

    final field = tester.widget<TextField>(find.byType(TextField).first);
    field.controller!.value = const TextEditingValue(
      text: 'Water',
      selection: TextSelection.collapsed(offset: 5),
    );
    await tester.pump();
    await tester.tap(find.text('Save'));
    await _until(tester, find.text('Water'));

    await tester.tap(find.text('Stats'));
    await _until(tester, find.text('This week'));
  });
}
