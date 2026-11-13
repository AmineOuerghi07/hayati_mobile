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
  String get profile => 'Profile';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Name';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get usePhoneCode => 'Use a code instead';

  @override
  String get emailOrPhone => 'Email or phone';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get localDemoCode => 'Local demo code';

  @override
  String get resetHint =>
      'If an account exists, a local demo code is created. No email is sent.';

  @override
  String get newPassword => 'New password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get changePassword => 'Change password';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get onThisDevice => 'On this device';

  @override
  String get guestStatus => 'Saved only on this device';

  @override
  String get invalidCredentials => 'Those details do not match.';

  @override
  String get emailInUse => 'That email already has an account.';

  @override
  String get invalidEmail => 'Enter a valid email.';

  @override
  String get weakPassword => 'Use at least 8 characters.';

  @override
  String get invalidCode => 'That code is not valid.';

  @override
  String get codeExpired => 'That code has expired.';

  @override
  String get accountNotFound => 'No account was found.';

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
