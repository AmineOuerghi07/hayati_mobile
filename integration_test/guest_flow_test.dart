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
    final save = find.text('Save');
    final editor = find.byKey(const Key('habit-editor'));
    for (
      var attempt = 0;
      attempt < 6 && tester.any(save.hitTestable()) == false;
      attempt++
    ) {
      await tester.drag(editor, const Offset(0, -400));
      await tester.pumpAndSettle();
    }
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Water'), findsWidgets);
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('This week'), findsOneWidget);
  });
}
