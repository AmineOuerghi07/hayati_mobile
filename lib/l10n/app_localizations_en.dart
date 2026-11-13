// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hayati';

  @override
  String get today => 'Today';

  @override
  String get stats => 'Stats';

  @override
  String get settings => 'Settings';

  @override
  String get todayPlaceholder => 'Habits you are working on will show up here.';

  @override
  String get statsPlaceholder => 'Insights are coming in a later update.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageFrench => 'French';

  @override
  String get environment => 'Environment';

  @override
  String get flavorDev => 'Development';

  @override
  String get flavorProd => 'Production';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSystem => 'System';

  @override
  String get appearanceLight => 'Light';

  @override
  String get appearanceDark => 'Dark';

  @override
  String get colorTheme => 'Color theme';

  @override
  String get themeHayati => 'Hayati';

  @override
  String get themeOasis => 'Oasis';

  @override
  String get themeDawn => 'Dawn';

  @override
  String get themeDusk => 'Dusk';

  @override
  String get themeBlossom => 'Blossom';

  @override
  String get themeSea => 'Sea';

  @override
  String get themeInk => 'Ink';

  @override
  String get themeContrast => 'Contrast';

  @override
  String get weekStartsOn => 'Week starts on';

  @override
  String get weekDayMonday => 'Monday';

  @override
  String get weekDaySaturday => 'Saturday';

  @override
  String get weekDaySunday => 'Sunday';

  @override
  String get addHabit => 'Add habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get habitName => 'Name';

  @override
  String get nameRequired => 'Enter a name';

  @override
  String get save => 'Save';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Unarchive';

  @override
  String get delete => 'Delete';

  @override
  String get deleteHabitTitle => 'Delete this habit?';

  @override
  String get deleteHabitMessage =>
      'The habit leaves your list. Its history stays on this device.';

  @override
  String get cancel => 'Cancel';

  @override
  String get frequency => 'Frequency';

  @override
  String get frequencyDaily => 'Every day';

  @override
  String get frequencyWeekdays => 'Specific days';

  @override
  String get frequencyTimesPerWeek => 'Times per week';

  @override
  String get timesEachWeek => 'Times each week';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderNone => 'No reminder';

  @override
  String get clearReminder => 'Clear reminder';

  @override
  String get currentStreak => 'Current streak';

  @override
  String get bestStreak => 'Best streak';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String streakWeeks(int count) {
    return '$count weeks';
  }

  @override
  String get markedDone => 'Marked done';

  @override
  String get clearedForToday => 'Cleared for today';

  @override
  String get undo => 'Undo';

  @override
  String get emptyTodayTitle => 'Nothing due today';

  @override
  String get emptyTodayBody => 'Add a habit and it will show up here.';

  @override
  String get chooseDays => 'Choose at least one day';

  @override
  String get history => 'History';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get loading => 'Loading';
}
