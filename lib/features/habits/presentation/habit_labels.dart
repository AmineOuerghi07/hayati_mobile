import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/part_of_day.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/habit_templates.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const knownUnits = <String>['glasses', 'pages', 'minutes', 'times'];

String greetingFor(AppLocalizations l10n, DateTime now, {String? name}) {
  final hour = now.hour;
  final base = hour < 12
      ? l10n.greetingMorning
      : hour < 17
      ? l10n.greetingAfternoon
      : l10n.greetingEvening;
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty) return base;
  return l10n.greetingNamed(base, trimmed);
}

/// The account name while signed in, otherwise the name saved on this device.
String? preferredName(AuthSession? session, AppPreferences? preferences) {
  if (session != null && !session.isGuest) {
    final account = session.user?.displayName.trim() ?? '';
    if (account.isNotEmpty) return account;
  }
  final guest = preferences?.displayName.trim() ?? '';
  return guest.isEmpty ? null : guest;
}

String partLabel(AppLocalizations l10n, PartOfDay? part) => switch (part) {
  PartOfDay.morning => l10n.partMorning,
  PartOfDay.afternoon => l10n.partAfternoon,
  PartOfDay.evening => l10n.partEvening,
  null => l10n.partAnytime,
};

IconData partIcon(PartOfDay? part) => switch (part) {
  PartOfDay.morning => Icons.wb_twilight_rounded,
  PartOfDay.afternoon => Icons.light_mode_outlined,
  PartOfDay.evening => Icons.dark_mode_outlined,
  null => Icons.schedule_rounded,
};

/// The same line all day, a different one tomorrow.
String dailyQuote(AppLocalizations l10n, DateTime day) {
  final quotes = [
    l10n.quote1,
    l10n.quote2,
    l10n.quote3,
    l10n.quote4,
    l10n.quote5,
    l10n.quote6,
    l10n.quote7,
    l10n.quote8,
  ];
  final dayOfYear = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(day.year)).inDays;
  return quotes[dayOfYear % quotes.length];
}

String unitLabel(AppLocalizations l10n, String? unit) {
  return switch (unit) {
    'glasses' => l10n.unitGlasses,
    'pages' => l10n.unitPages,
    'minutes' => l10n.unitMinutes,
    'times' => l10n.unitTimes,
    null || '' => '',
    _ => unit,
  };
}

String templateTitle(AppLocalizations l10n, String id) {
  return switch (id) {
    'water' => l10n.templateWater,
    'read' => l10n.templateRead,
    'walk' => l10n.templateWalk,
    'pray' => l10n.templatePray,
    'sleep' => l10n.templateSleep,
    'journal' => l10n.templateJournal,
    _ => id,
  };
}

HabitDraft draftFromTemplate(
  AppLocalizations l10n,
  HabitTemplate template, {
  required String startDate,
  int? reminderTime,
}) {
  return HabitDraft(
    name: templateTitle(l10n, template.id),
    icon: template.icon,
    colorKey: template.colorKey,
    type: template.type,
    targetValue: template.targetValue,
    unit: template.unit,
    frequencyType: FrequencyType.daily,
    reminderTime: reminderTime,
    startDate: startDate,
  );
}

String amountText(double value) {
  if (value == value.roundToDouble()) return '${value.round()}';
  return value.toStringAsFixed(1);
}

String moodLabel(AppLocalizations l10n, int mood) {
  return switch (mood) {
    1 => l10n.moodAwful,
    2 => l10n.moodLow,
    3 => l10n.moodOkay,
    4 => l10n.moodGood,
    _ => l10n.moodGreat,
  };
}
