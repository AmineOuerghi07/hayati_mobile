import 'package:hayati/features/habits/domain/habit.dart';

/// One local notification derived from a habit. The id is stable for the
/// habit so a later sync replaces the same notification instead of piling up.
class ReminderPlan {
  const ReminderPlan({
    required this.id,
    required this.habitId,
    required this.minutesFromMidnight,
    required this.title,
  });

  final int id;
  final String habitId;
  final int minutesFromMidnight;
  final String title;
}

/// Habits with a reminder, that are still active, become plans.
/// Archived and deleted habits are skipped, which cancels their alarms
/// when the scheduler replaces the whole set.
List<ReminderPlan> planReminders(
  Iterable<Habit> habits, {
  bool paused = false,
}) {
  if (paused) return const [];
  return [
    for (final habit in habits)
      if (!habit.isDeleted && !habit.isArchived && habit.reminderTime != null)
        ReminderPlan(
          id: habit.id.hashCode & 0x7fffffff,
          habitId: habit.id,
          minutesFromMidnight: habit.reminderTime!,
          title: habit.name,
        ),
  ];
}

abstract class ReminderScheduler {
  Future<bool> ensurePermission();

  Future<void> replaceAll(List<ReminderPlan> plans);
}

/// Asks for notification permission the first time a reminder exists.
/// Launching the app with no reminders does not prompt.
class ReminderCoordinator {
  ReminderCoordinator(this._scheduler);

  final ReminderScheduler _scheduler;
  var _asked = false;

  Future<void> sync(List<Habit> habits, {bool paused = false}) async {
    final plans = planReminders(habits, paused: paused);
    if (plans.isEmpty) {
      await _scheduler.replaceAll(const []);
      return;
    }
    if (!_asked) {
      _asked = true;
      final allowed = await _scheduler.ensurePermission();
      if (!allowed) return;
    }
    await _scheduler.replaceAll(plans);
  }
}
