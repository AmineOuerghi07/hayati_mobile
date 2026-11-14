import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/app/hayati_app.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/journal/presentation/reflection_providers.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:hayati/features/reminders/presentation/reminder_providers.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:material_ui/material_ui.dart';

import 'support/memory_auth_repository.dart';
import 'support/memory_habit_repository.dart';
import 'support/memory_reflection_repository.dart';
import 'support/memory_settings_repository.dart';
import 'support/silent_reminder_scheduler.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final settings = MemorySettingsRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWith((ref) => settings),
        habitRepositoryProvider.overrideWith((ref) => MemoryHabitRepository()),
        completionRepositoryProvider.overrideWith(
          (ref) => MemoryCompletionRepository(),
        ),
        reminderCoordinatorProvider.overrideWith(
          (ref) => ReminderCoordinator(SilentReminderScheduler()),
        ),
        authRepositoryProvider.overrideWith((ref) => MemoryAuthRepository()),
        reflectionRepositoryProvider.overrideWith(
          (ref) => MemoryReflectionRepository(),
        ),
      ],
      child: const HayatiApp(),
    ),
  );
  await _settle(tester);
}

void main() {
  testWidgets('today, stats, and settings are reachable', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Nothing due today'), findsOneWidget);

    await tester.tap(find.text('Stats'));
    await _settle(tester);
    expect(find.text('This week'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await _settle(tester);
    expect(find.text('Language'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Development'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ResponsiveListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Development'), findsOneWidget);

    final before = Theme.of(tester.element(find.text('Color theme')))
        .colorScheme
        .primary;
    await tester.tap(find.byTooltip('Dawn'));
    await _settle(tester);
    final after = Theme.of(tester.element(find.text('Color theme')))
        .colorScheme
        .primary;
    expect(after, isNot(before));
  });

  testWidgets('Arabic selection mirrors the layout', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await _settle(tester);
    await tester.tap(find.text('Arabic'));
    await _settle(tester);

    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('اللغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('اللغة'))),
      TextDirection.rtl,
    );
  });

  testWidgets('French selection uses the French strings', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await _settle(tester);
    await tester.tap(find.text('French'));
    await _settle(tester);

    expect(find.text("Aujourd'hui"), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Développement'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ResponsiveListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Développement'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Langue'))),
      TextDirection.ltr,
    );
  });
}
