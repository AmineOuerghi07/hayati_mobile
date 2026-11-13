import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hayati/app/router.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/reminders/data/local_reminder_scheduler.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_providers.g.dart';

/// Keeps OS reminders aligned with active habits.
///
/// keepAlive so leaving Today does not cancel the subscription that
/// reschedules after an edit, archive, or delete. Permission is requested
/// inside [ReminderCoordinator.sync], only when a reminder exists.
@Riverpod(keepAlive: true)
ReminderCoordinator reminderCoordinator(Ref ref) {
  final coordinator = ReminderCoordinator(
    LocalReminderScheduler(
      FlutterLocalNotificationsPlugin(),
      onOpenToday: () => ref.read(appRouterProvider).go('/today'),
    ),
  );
  ref.listen(activeHabitsProvider, (_, next) {
    next.whenData(coordinator.sync);
  });
  final lifecycle = AppLifecycleListener(
    onResume: () async {
      final habits = await ref.read(activeHabitsProvider.future);
      await coordinator.sync(habits);
    },
  );
  ref.onDispose(lifecycle.dispose);
  return coordinator;
}
