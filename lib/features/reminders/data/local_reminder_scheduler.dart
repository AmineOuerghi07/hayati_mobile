import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hayati/features/reminders/domain/reminder_planner.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the plans with the OS. Uses inexact alarms so the app does not
/// need the special exact-alarm permission, which Android 14 limits.
class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler(this._plugin, {this.onOpenToday});

  final FlutterLocalNotificationsPlugin _plugin;
  final void Function()? onOpenToday;
  var _ready = false;

  static const _payload = 'today';

  @override
  Future<bool> ensurePermission() async {
    await _ensureReady();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  @override
  Future<void> replaceAll(List<ReminderPlan> plans) async {
    await _ensureReady();
    await _plugin.cancelAll();
    for (final plan in plans) {
      await _plugin.zonedSchedule(
        id: plan.id,
        title: plan.title,
        body: plan.title,
        scheduledDate: _next(plan.minutesFromMidnight),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_reminders',
            'Habit reminders',
            channelDescription: 'Daily reminders for habits',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: _payload,
      );
    }
  }

  Future<void> _ensureReady() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    var identifier = 'UTC';
    try {
      identifier = (await FlutterTimezone.getLocalTimezone()).identifier;
    } on Object {
      identifier = 'UTC';
    }
    tz.setLocalLocation(reminderLocation(identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == _payload) onOpenToday?.call();
      },
    );
    _ready = true;
  }

  tz.TZDateTime _next(int minutes) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      minutes ~/ 60,
      minutes % 60,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

/// Simulator hosts sometimes report `GMT`, which this database does not ship.
tz.Location reminderLocation(String identifier) {
  try {
    return tz.getLocation(identifier);
  } on tz.LocationNotFoundException {
    return tz.UTC;
  }
}
