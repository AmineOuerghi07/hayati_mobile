import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hayati/app/router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/reminders/data/local_reminder_scheduler.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
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
  Future<void> resync() async {
    final habits = await ref.read(activeHabitsProvider.future);
    await coordinator.sync(habits, paused: _timeOffToday(ref));
  }

  ref.listen(activeHabitsProvider, (_, next) {
    next.whenData(
      (habits) => coordinator.sync(habits, paused: _timeOffToday(ref)),
    );
  });
  ref.listen(preferencesControllerProvider, (_, _) {
    resync();
  });
  final lifecycle = AppLifecycleListener(
    onResume: () async {
      await resync();
    },
  );
  ref.onDispose(lifecycle.dispose);
  return coordinator;
}

bool _timeOffToday(Ref ref) {
  final prefs = ref.read(preferencesControllerProvider).value;
  final start = prefs?.pauseStart;
  final end = prefs?.pauseEnd;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return false;
  }
  final today = CalendarDate.today().iso;
  return today.compareTo(start) >= 0 && today.compareTo(end) <= 0;
}
