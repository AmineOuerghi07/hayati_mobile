import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/reminders/data/local_reminder_scheduler.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  Habit habit({
    required String id,
    required String name,
    int? reminder,
    bool archived = false,
    bool deleted = false,
  }) {
    final now = DateTime.utc(2026, 3, 1);
    return Habit(
      id: id,
      createdAt: now,
      updatedAt: now,
      name: name,
      icon: 'check',
      colorKey: 'hayati',
      type: HabitType.boolean,
      frequencyType: FrequencyType.daily,
      startDate: '2026-03-01',
      reminderTime: reminder,
      archivedAt: archived ? now : null,
      deletedAt: deleted ? now : null,
    );
  }

  test('only active habits with a time become plans', () {
    final plans = planReminders([
      habit(id: 'a', name: 'Water', reminder: 8 * 60),
      habit(id: 'b', name: 'Read'),
      habit(id: 'c', name: 'Old', reminder: 9 * 60, archived: true),
      habit(id: 'd', name: 'Gone', reminder: 10 * 60, deleted: true),
    ]);
    expect(plans, hasLength(1));
    expect(plans.single.habitId, 'a');
    expect(plans.single.minutesFromMidnight, 8 * 60);
    expect(plans.single.title, 'Water');
  });

  test('time off clears every plan', () {
    final plans = planReminders([
      habit(id: 'a', name: 'Water', reminder: 8 * 60),
    ], paused: true);
    expect(plans, isEmpty);
  });

  test('the same habit keeps the same notification id', () {
    final first = planReminders([
      habit(id: 'a', name: 'Water', reminder: 8 * 60),
    ]).single.id;
    final second = planReminders([
      habit(id: 'a', name: 'Water later', reminder: 9 * 60),
    ]).single.id;
    expect(first, second);
  });

  test('permission is asked once, and only when a reminder exists', () async {
    final scheduler = _FakeScheduler();
    final coordinator = ReminderCoordinator(scheduler);
    await coordinator.sync([habit(id: 'a', name: 'Read')]);
    expect(scheduler.permissionCalls, 0);
    expect(scheduler.replaced, isEmpty);

    await coordinator.sync([habit(id: 'a', name: 'Read', reminder: 7 * 60)]);
    expect(scheduler.permissionCalls, 1);
    expect(scheduler.replaced.single.habitId, 'a');

    await coordinator.sync([habit(id: 'a', name: 'Read', reminder: 8 * 60)]);
    expect(scheduler.permissionCalls, 1);
  });

  test('a denied permission does not schedule', () async {
    final scheduler = _FakeScheduler(allowed: false);
    final coordinator = ReminderCoordinator(scheduler);
    await coordinator.sync([habit(id: 'a', name: 'Read', reminder: 7 * 60)]);
    expect(scheduler.replaced, isEmpty);
  });

  test('an unknown timezone name falls back to UTC', () {
    tzdata.initializeTimeZones();
    expect(reminderLocation('GMT'), tz.UTC);
    expect(reminderLocation('Africa/Tunis').name, 'Africa/Tunis');
  });
}

class _FakeScheduler implements ReminderScheduler {
  _FakeScheduler({this.allowed = true});

  final bool allowed;
  var permissionCalls = 0;
  List<ReminderPlan> replaced = const [];

  @override
  Future<bool> ensurePermission() async {
    permissionCalls += 1;
    return allowed;
  }

  @override
  Future<void> replaceAll(List<ReminderPlan> plans) async {
    replaced = plans;
  }
}
