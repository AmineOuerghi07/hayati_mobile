import 'package:flutter/widgets.dart';
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
  debugDumpApp();
  fail('Timed out waiting for $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a guest can add a habit and open stats', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    app.main();
    await _until(
      tester,
      find.text('Nothing due today'),
      timeout: const Duration(seconds: 60),
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
