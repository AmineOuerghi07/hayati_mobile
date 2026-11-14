import 'package:hayati/features/reminders/domain/reminder_planner.dart';

class SilentReminderScheduler implements ReminderScheduler {
  @override
  Future<bool> ensurePermission() async => true;

  @override
  Future<void> replaceAll(List<ReminderPlan> plans) async {}
}
