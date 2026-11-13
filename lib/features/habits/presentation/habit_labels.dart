import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/habit_templates.dart';
import 'package:hayati/l10n/app_localizations.dart';

const knownUnits = <String>['glasses', 'pages', 'minutes', 'times'];

String greetingFor(AppLocalizations l10n, DateTime now) {
  final hour = now.hour;
  if (hour < 12) return l10n.greetingMorning;
  if (hour < 17) return l10n.greetingAfternoon;
  return l10n.greetingEvening;
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
