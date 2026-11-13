import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a guest can add a habit and open stats', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Nothing due today'), findsOneWidget);
    await tester.tap(find.text('Add habit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Water');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Save'),
      400,
      scrollable: find.descendant(
        of: find.byKey(const Key('habit-editor')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Water'), findsWidgets);
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('This week'), findsOneWidget);
  });
}
