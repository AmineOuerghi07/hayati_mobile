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
  String get syncNow => 'Sync now';

  @override
  String get syncing => 'Syncing';

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

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get heatmap => 'Last 12 weeks';

  @override
  String get habits => 'Habits';

  @override
  String get noInsightsYet =>
      'Nothing to measure yet. Finish a habit and it will show up here.';

  @override
  String get somethingWentWrong =>
      'Something went wrong. Try again in a moment.';

  @override
  String get usageReports => 'Usage reports';

  @override
  String get usageReportsBody =>
      'Off by default. Nothing is sent from this build.';

  @override
  String streakMilestone(int count) {
    return '$count-day streak';
  }

  @override
  String get allDoneTitle => 'That\'s the day';

  @override
  String get allDoneBody => 'Every habit for today is done.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String doneOfTotal(int done, int total) {
    return '$done of $total done';
  }

  @override
  String backfillBanner(String date) {
    return 'Logging $date';
  }

  @override
  String get loggingPastBody => 'This day stays in your history.';

  @override
  String get backToToday => 'Back to today';

  @override
  String get browseTemplates => 'Browse templates';

  @override
  String get skip => 'Skip';

  @override
  String get continueAction => 'Continue';

  @override
  String get getStarted => 'Start';

  @override
  String get welcomeTitle => 'Hayati';

  @override
  String get welcomeSubtitle => 'My life';

  @override
  String get welcomeBody =>
      'A quiet place for the habits that make up your day.';

  @override
  String get onboardingHabitsTitle => 'Start with a few';

  @override
  String get onboardingHabitsBody =>
      'Pick any that feel right. You can change them later.';

  @override
  String get onboardingReminderTitle => 'A gentle nudge';

  @override
  String get onboardingReminderBody =>
      'Optional. One reminder for the habits you just picked.';

  @override
  String get templateWater => 'Drink water';

  @override
  String get templateRead => 'Read';

  @override
  String get templateWalk => 'Walk';

  @override
  String get templatePray => 'Pray';

  @override
  String get templateSleep => 'Sleep on time';

  @override
  String get templateJournal => 'Journal';

  @override
  String get unitGlasses => 'glasses';

  @override
  String get unitPages => 'pages';

  @override
  String get unitMinutes => 'minutes';

  @override
  String get unitTimes => 'times';

  @override
  String get goal => 'Goal';

  @override
  String get goalCheck => 'Check off';

  @override
  String get goalCount => 'Count';

  @override
  String get target => 'Target';

  @override
  String get unit => 'Unit';

  @override
  String get preview => 'Preview';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get customUnit => 'Or type a unit';

  @override
  String quantityProgress(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String percentValue(int percent) {
    return '$percent%';
  }

  @override
  String get noRate => '—';

  @override
  String ringSemantics(String label, String value) {
    return '$label, $value percent';
  }

  @override
  String ringEmpty(String label) {
    return '$label, nothing due';
  }

  @override
  String increaseHabit(String name) {
    return 'Increase $name';
  }

  @override
  String decreaseHabit(String name) {
    return 'Decrease $name';
  }

  @override
  String get noteTitle => 'Note';

  @override
  String get saveNote => 'Save note';

  @override
  String get moodLabel => 'How did it feel?';

  @override
  String get moodAwful => 'Rough';

  @override
  String get moodLow => 'Low';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodGood => 'Good';

  @override
  String get moodGreat => 'Great';

  @override
  String get recentNotes => 'Notes';

  @override
  String get noNotesYet => 'No notes yet.';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody =>
      'Your habits stay on this device. Nothing is sent from this build, even if usage reports are on.';

  @override
  String get archivedHabits => 'Archived';

  @override
  String get noArchivedHabits => 'No archived habits.';

  @override
  String get replayOnboarding => 'Replay the introduction';

  @override
  String get licenses => 'Licenses';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get sectionAbout => 'About';

  @override
  String get archiveHabitTitle => 'Archive this habit?';

  @override
  String get archiveHabitMessage =>
      'It leaves Today. You can restore it from Profile.';

  @override
  String get archivedMessage => 'Archived';

  @override
  String get restoredMessage => 'Restored';

  @override
  String get lastSevenDays => 'Last 7 days';

  @override
  String get completionRate => 'Completion';

  @override
  String get addNote => 'Add a note';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get nothingDueOnDay => 'Nothing due on this day';

  @override
  String get cleared => 'Cleared';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get heroStart => 'A fresh day. One small step is enough to begin.';

  @override
  String get heroProgress => 'Nice rhythm. Keep it going.';

  @override
  String plantGrowth(int percent) {
    return 'Your plant is $percent percent grown';
  }

  @override
  String get perfectDays => 'Perfect days, last 30';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get moodThisWeek => 'Mood this week';

  @override
  String get quote1 => 'Small steps every day become a life you love.';

  @override
  String get quote2 => 'You don\'t have to be perfect, just consistent.';

  @override
  String get quote3 => 'Water the plant you want to grow.';

  @override
  String get quote4 => 'Progress, not perfection.';

  @override
  String get quote5 => 'Be gentle with yourself. You are growing.';

  @override
  String get quote6 =>
      'What you do every day matters more than what you do once in a while.';

  @override
  String get quote7 => 'Begin where you are. Use what you have.';

  @override
  String get quote8 => 'A calm mind builds a strong life.';
}
