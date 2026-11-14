// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Application name shown in the task switcher.
  ///
  /// In en, this message translates to:
  /// **'Hayati'**
  String get appTitle;

  /// Bottom navigation label for the daily habits screen.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Bottom navigation label for the insights screen.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// Bottom navigation label for the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Empty state on the Today screen before habits exist.
  ///
  /// In en, this message translates to:
  /// **'Habits you are working on will show up here.'**
  String get todayPlaceholder;

  /// Placeholder on the Stats screen until insights are built.
  ///
  /// In en, this message translates to:
  /// **'Insights are coming in a later update.'**
  String get statsPlaceholder;

  /// Settings section title for the language picker.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language option that follows the device locale.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// Language option for English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language option for Arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Language option for French.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// Settings row that shows whether this build is dev or prod.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// Name of the development build flavor.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get flavorDev;

  /// Name of the production build flavor.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get flavorProd;

  /// Settings section for light, dark, or system brightness.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// Settings section for the named color palettes.
  ///
  /// In en, this message translates to:
  /// **'Color theme'**
  String get colorTheme;

  /// No description provided for @themeHayati.
  ///
  /// In en, this message translates to:
  /// **'Hayati'**
  String get themeHayati;

  /// No description provided for @themeOasis.
  ///
  /// In en, this message translates to:
  /// **'Oasis'**
  String get themeOasis;

  /// No description provided for @themeDawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get themeDawn;

  /// No description provided for @themeDusk.
  ///
  /// In en, this message translates to:
  /// **'Dusk'**
  String get themeDusk;

  /// No description provided for @themeBlossom.
  ///
  /// In en, this message translates to:
  /// **'Blossom'**
  String get themeBlossom;

  /// No description provided for @themeSea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get themeSea;

  /// No description provided for @themeInk.
  ///
  /// In en, this message translates to:
  /// **'Ink'**
  String get themeInk;

  /// No description provided for @themeContrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get themeContrast;

  /// No description provided for @weekStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get weekStartsOn;

  /// No description provided for @weekDayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekDayMonday;

  /// No description provided for @weekDaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekDaySaturday;

  /// No description provided for @weekDaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekDaySunday;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get displayName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @usePhoneCode.
  ///
  /// In en, this message translates to:
  /// **'Use a code instead'**
  String get usePhoneCode;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get emailOrPhone;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @localDemoCode.
  ///
  /// In en, this message translates to:
  /// **'Local demo code'**
  String get localDemoCode;

  /// No description provided for @resetHint.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, a local demo code is created. No email is sent.'**
  String get resetHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @onThisDevice.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get onThisDevice;

  /// No description provided for @guestStatus.
  ///
  /// In en, this message translates to:
  /// **'Saved only on this device'**
  String get guestStatus;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Those details do not match.'**
  String get invalidCredentials;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'That email already has an account.'**
  String get emailInUse;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get weakPassword;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'That code is not valid.'**
  String get invalidCode;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired.'**
  String get codeExpired;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account was found.'**
  String get accountNotFound;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncing;

  /// No description provided for @addHabit.
  ///
  /// In en, this message translates to:
  /// **'Add habit'**
  String get addHabit;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get editHabit;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get habitName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get nameRequired;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchive;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this habit?'**
  String get deleteHabitTitle;

  /// No description provided for @deleteHabitMessage.
  ///
  /// In en, this message translates to:
  /// **'The habit leaves your list. Its history stays on this device.'**
  String get deleteHabitMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @frequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get frequencyDaily;

  /// No description provided for @frequencyWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Specific days'**
  String get frequencyWeekdays;

  /// No description provided for @frequencyTimesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Times per week'**
  String get frequencyTimesPerWeek;

  /// No description provided for @timesEachWeek.
  ///
  /// In en, this message translates to:
  /// **'Times each week'**
  String get timesEachWeek;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get reminderNone;

  /// No description provided for @clearReminder.
  ///
  /// In en, this message translates to:
  /// **'Clear reminder'**
  String get clearReminder;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreak;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDays(int count);

  /// No description provided for @streakWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String streakWeeks(int count);

  /// No description provided for @markedDone.
  ///
  /// In en, this message translates to:
  /// **'Marked done'**
  String get markedDone;

  /// No description provided for @clearedForToday.
  ///
  /// In en, this message translates to:
  /// **'Cleared for today'**
  String get clearedForToday;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @emptyTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing due today'**
  String get emptyTodayTitle;

  /// No description provided for @emptyTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Add a habit and it will show up here.'**
  String get emptyTodayBody;

  /// No description provided for @chooseDays.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one day'**
  String get chooseDays;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @heatmap.
  ///
  /// In en, this message translates to:
  /// **'Last 12 weeks'**
  String get heatmap;

  /// No description provided for @habits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habits;

  /// No description provided for @noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing to measure yet. Finish a habit and it will show up here.'**
  String get noInsightsYet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again in a moment.'**
  String get somethingWentWrong;

  /// No description provided for @usageReports.
  ///
  /// In en, this message translates to:
  /// **'Usage reports'**
  String get usageReports;

  /// No description provided for @usageReportsBody.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Nothing is sent from this build.'**
  String get usageReportsBody;

  /// No description provided for @streakMilestone.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String streakMilestone(int count);

  /// No description provided for @allDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s the day'**
  String get allDoneTitle;

  /// No description provided for @allDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Every habit for today is done.'**
  String get allDoneBody;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @doneOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String doneOfTotal(int done, int total);

  /// No description provided for @backfillBanner.
  ///
  /// In en, this message translates to:
  /// **'Logging {date}'**
  String backfillBanner(String date);

  /// No description provided for @loggingPastBody.
  ///
  /// In en, this message translates to:
  /// **'This day stays in your history.'**
  String get loggingPastBody;

  /// No description provided for @backToToday.
  ///
  /// In en, this message translates to:
  /// **'Back to today'**
  String get backToToday;

  /// No description provided for @browseTemplates.
  ///
  /// In en, this message translates to:
  /// **'Browse templates'**
  String get browseTemplates;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get getStarted;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hayati'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'My life'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A quiet place for the habits that make up your day.'**
  String get welcomeBody;

  /// No description provided for @onboardingHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a few'**
  String get onboardingHabitsTitle;

  /// No description provided for @onboardingHabitsBody.
  ///
  /// In en, this message translates to:
  /// **'Pick any that feel right. You can change them later.'**
  String get onboardingHabitsBody;

  /// No description provided for @onboardingReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge'**
  String get onboardingReminderTitle;

  /// No description provided for @onboardingReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. One reminder for the habits you just picked.'**
  String get onboardingReminderBody;

  /// No description provided for @templateWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get templateWater;

  /// No description provided for @templateRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get templateRead;

  /// No description provided for @templateWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get templateWalk;

  /// No description provided for @templatePray.
  ///
  /// In en, this message translates to:
  /// **'Pray'**
  String get templatePray;

  /// No description provided for @templateSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep on time'**
  String get templateSleep;

  /// No description provided for @templateJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get templateJournal;

  /// No description provided for @unitGlasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get unitGlasses;

  /// No description provided for @unitPages.
  ///
  /// In en, this message translates to:
  /// **'pages'**
  String get unitPages;

  /// No description provided for @unitMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get unitMinutes;

  /// No description provided for @unitTimes.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get unitTimes;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @goalCheck.
  ///
  /// In en, this message translates to:
  /// **'Check off'**
  String get goalCheck;

  /// No description provided for @goalCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get goalCount;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @customUnit.
  ///
  /// In en, this message translates to:
  /// **'Or type a unit'**
  String get customUnit;

  /// No description provided for @quantityProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} {unit}'**
  String quantityProgress(int current, int target, String unit);

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percentValue(int percent);

  /// No description provided for @noRate.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noRate;

  /// No description provided for @ringSemantics.
  ///
  /// In en, this message translates to:
  /// **'{label}, {value} percent'**
  String ringSemantics(String label, String value);

  /// No description provided for @ringEmpty.
  ///
  /// In en, this message translates to:
  /// **'{label}, nothing due'**
  String ringEmpty(String label);

  /// No description provided for @increaseHabit.
  ///
  /// In en, this message translates to:
  /// **'Increase {name}'**
  String increaseHabit(String name);

  /// No description provided for @decreaseHabit.
  ///
  /// In en, this message translates to:
  /// **'Decrease {name}'**
  String decreaseHabit(String name);

  /// No description provided for @noteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteTitle;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get saveNote;

  /// No description provided for @moodLabel.
  ///
  /// In en, this message translates to:
  /// **'How did it feel?'**
  String get moodLabel;

  /// No description provided for @moodAwful.
  ///
  /// In en, this message translates to:
  /// **'Rough'**
  String get moodAwful;

  /// No description provided for @moodLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodLow;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// No description provided for @recentNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get recentNotes;

  /// No description provided for @noNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get noNotesYet;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your habits stay on this device. Nothing is sent from this build, even if usage reports are on.'**
  String get privacyBody;

  /// No description provided for @archivedHabits.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedHabits;

  /// No description provided for @noArchivedHabits.
  ///
  /// In en, this message translates to:
  /// **'No archived habits.'**
  String get noArchivedHabits;

  /// No description provided for @replayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay the introduction'**
  String get replayOnboarding;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @archiveHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive this habit?'**
  String get archiveHabitTitle;

  /// No description provided for @archiveHabitMessage.
  ///
  /// In en, this message translates to:
  /// **'It leaves Today. You can restore it from Profile.'**
  String get archiveHabitMessage;

  /// No description provided for @archivedMessage.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedMessage;

  /// No description provided for @restoredMessage.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restoredMessage;

  /// No description provided for @lastSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get lastSevenDays;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completionRate;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addNote;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// No description provided for @nothingDueOnDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing due on this day'**
  String get nothingDueOnDay;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;

  /// No description provided for @heroStart.
  ///
  /// In en, this message translates to:
  /// **'A fresh day. One small step is enough to begin.'**
  String get heroStart;

  /// No description provided for @heroProgress.
  ///
  /// In en, this message translates to:
  /// **'Nice rhythm. Keep it going.'**
  String get heroProgress;

  /// No description provided for @plantGrowth.
  ///
  /// In en, this message translates to:
  /// **'Your plant is {percent} percent grown'**
  String plantGrowth(int percent);

  /// No description provided for @perfectDays.
  ///
  /// In en, this message translates to:
  /// **'Perfect days, last 30'**
  String get perfectDays;

  /// No description provided for @checkIns.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get checkIns;

  /// No description provided for @moodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Mood this week'**
  String get moodThisWeek;

  /// No description provided for @quote1.
  ///
  /// In en, this message translates to:
  /// **'Small steps every day become a life you love.'**
  String get quote1;

  /// No description provided for @quote2.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to be perfect, just consistent.'**
  String get quote2;

  /// No description provided for @quote3.
  ///
  /// In en, this message translates to:
  /// **'Water the plant you want to grow.'**
  String get quote3;

  /// No description provided for @quote4.
  ///
  /// In en, this message translates to:
  /// **'Progress, not perfection.'**
  String get quote4;

  /// No description provided for @quote5.
  ///
  /// In en, this message translates to:
  /// **'Be gentle with yourself. You are growing.'**
  String get quote5;

  /// No description provided for @quote6.
  ///
  /// In en, this message translates to:
  /// **'What you do every day matters more than what you do once in a while.'**
  String get quote6;

  /// No description provided for @quote7.
  ///
  /// In en, this message translates to:
  /// **'Begin where you are. Use what you have.'**
  String get quote7;

  /// No description provided for @quote8.
  ///
  /// In en, this message translates to:
  /// **'A calm mind builds a strong life.'**
  String get quote8;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your habits in sync across your devices.'**
  String get authSignInBody;

  /// No description provided for @authCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey'**
  String get authCreateTitle;

  /// No description provided for @authCreateBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to back up your streaks and progress.'**
  String get authCreateBody;

  /// No description provided for @benefitSync.
  ///
  /// In en, this message translates to:
  /// **'Sync across your devices'**
  String get benefitSync;

  /// No description provided for @benefitBackup.
  ///
  /// In en, this message translates to:
  /// **'Your streaks, safely backed up'**
  String get benefitBackup;

  /// No description provided for @benefitPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private by design. No ads, ever.'**
  String get benefitPrivate;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordWeak;

  /// No description provided for @passwordFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordFair;

  /// No description provided for @passwordGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get passwordGood;

  /// No description provided for @passwordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrong;

  /// No description provided for @passwordStrength.
  ///
  /// In en, this message translates to:
  /// **'Password strength: {level}'**
  String passwordStrength(String level);

  /// No description provided for @otpBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time code. No password needed.'**
  String get otpBody;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {destination}'**
  String codeSentTo(String destination);

  /// No description provided for @codeExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {time}'**
  String codeExpiresIn(String time);

  /// No description provided for @codeExpiredHint.
  ///
  /// In en, this message translates to:
  /// **'This code expired. Send a new one.'**
  String get codeExpiredHint;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @changeDestination.
  ///
  /// In en, this message translates to:
  /// **'Use a different address'**
  String get changeDestination;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'You can sign in with your new password now.'**
  String get passwordUpdatedBody;

  /// No description provided for @changePasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with a mix of letters, numbers, and symbols.'**
  String get changePasswordBody;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @unlockedOf.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} unlocked'**
  String unlockedOf(int count, int total);

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{title}, unlocked'**
  String achievementUnlocked(String title);

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'{title}, locked, {current} of {target}'**
  String achievementLocked(String title, int current, int target);

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @progressOf.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String progressOf(int current, int target);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} XP'**
  String xpProgress(int current, int total);

  /// No description provided for @levelSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get levelSeed;

  /// No description provided for @levelSprout.
  ///
  /// In en, this message translates to:
  /// **'Sprout'**
  String get levelSprout;

  /// No description provided for @levelSapling.
  ///
  /// In en, this message translates to:
  /// **'Sapling'**
  String get levelSapling;

  /// No description provided for @levelBloom.
  ///
  /// In en, this message translates to:
  /// **'Bloom'**
  String get levelBloom;

  /// No description provided for @levelTree.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get levelTree;

  /// No description provided for @levelForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get levelForest;

  /// No description provided for @achFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First step'**
  String get achFirstStep;

  /// No description provided for @achFirstStepBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your first habit.'**
  String get achFirstStepBody;

  /// No description provided for @achStreak3.
  ///
  /// In en, this message translates to:
  /// **'Warming up'**
  String get achStreak3;

  /// No description provided for @achStreak7.
  ///
  /// In en, this message translates to:
  /// **'One week strong'**
  String get achStreak7;

  /// No description provided for @achStreak30.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get achStreak30;

  /// No description provided for @achStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Reach a {count}-day streak.'**
  String achStreakBody(int count);

  /// No description provided for @achPerfectDay.
  ///
  /// In en, this message translates to:
  /// **'Perfect day'**
  String get achPerfectDay;

  /// No description provided for @achPerfectDayBody.
  ///
  /// In en, this message translates to:
  /// **'Finish every habit that was due in one day.'**
  String get achPerfectDayBody;

  /// No description provided for @achPerfectWeek.
  ///
  /// In en, this message translates to:
  /// **'Perfect week'**
  String get achPerfectWeek;

  /// No description provided for @achPerfectWeekBody.
  ///
  /// In en, this message translates to:
  /// **'Seven perfect days in a row.'**
  String get achPerfectWeekBody;

  /// No description provided for @achCheckIns50.
  ///
  /// In en, this message translates to:
  /// **'Half century'**
  String get achCheckIns50;

  /// No description provided for @achCheckIns100.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get achCheckIns100;

  /// No description provided for @achCheckInsBody.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} check-ins.'**
  String achCheckInsBody(int count);

  /// No description provided for @achHabitBuilder.
  ///
  /// In en, this message translates to:
  /// **'Habit builder'**
  String get achHabitBuilder;

  /// No description provided for @achHabitBuilderBody.
  ///
  /// In en, this message translates to:
  /// **'Keep five habits going at once.'**
  String get achHabitBuilderBody;

  /// No description provided for @achReflective.
  ///
  /// In en, this message translates to:
  /// **'Reflective'**
  String get achReflective;

  /// No description provided for @achReflectiveBody.
  ///
  /// In en, this message translates to:
  /// **'Write ten notes or moods.'**
  String get achReflectiveBody;

  /// No description provided for @achEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early bird'**
  String get achEarlyBird;

  /// No description provided for @achEarlyBirdBody.
  ///
  /// In en, this message translates to:
  /// **'Check in before 8 in the morning.'**
  String get achEarlyBirdBody;

  /// No description provided for @achNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night owl'**
  String get achNightOwl;

  /// No description provided for @achNightOwlBody.
  ///
  /// In en, this message translates to:
  /// **'Check in after 10 at night.'**
  String get achNightOwlBody;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTitle;

  /// No description provided for @focusShort.
  ///
  /// In en, this message translates to:
  /// **'A calm timer'**
  String get focusShort;

  /// No description provided for @focusBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a length, put the phone down, and settle in.'**
  String get focusBody;

  /// No description provided for @focusDone.
  ///
  /// In en, this message translates to:
  /// **'Session complete. Well done.'**
  String get focusDone;

  /// No description provided for @focusLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged {minutes} min to {habit}'**
  String focusLogged(int minutes, String habit);

  /// No description provided for @focusRemaining.
  ///
  /// In en, this message translates to:
  /// **'{time} remaining'**
  String focusRemaining(String time);

  /// No description provided for @focusInProgress.
  ///
  /// In en, this message translates to:
  /// **'Focusing'**
  String get focusInProgress;

  /// No description provided for @focusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get focusPaused;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @startFocus.
  ///
  /// In en, this message translates to:
  /// **'Start a focus session'**
  String get startFocus;

  /// No description provided for @breatheTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get breatheTitle;

  /// No description provided for @breatheShort.
  ///
  /// In en, this message translates to:
  /// **'One calm minute'**
  String get breatheShort;

  /// No description provided for @breatheBody.
  ///
  /// In en, this message translates to:
  /// **'Follow the circle: in for 4, hold for 4, out for 6.'**
  String get breatheBody;

  /// No description provided for @breatheReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get breatheReady;

  /// No description provided for @breatheIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get breatheIn;

  /// No description provided for @breatheHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get breatheHold;

  /// No description provided for @breatheOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get breatheOut;

  /// No description provided for @breathCycles.
  ///
  /// In en, this message translates to:
  /// **'Breaths: {count}'**
  String breathCycles(int count);

  /// No description provided for @weeklyTrend.
  ///
  /// In en, this message translates to:
  /// **'Compared with last week'**
  String get weeklyTrend;

  /// No description provided for @trendUp.
  ///
  /// In en, this message translates to:
  /// **'{points} points ahead of last week'**
  String trendUp(int points);

  /// No description provided for @trendDown.
  ///
  /// In en, this message translates to:
  /// **'{points} points behind last week'**
  String trendDown(int points);

  /// No description provided for @trendSame.
  ///
  /// In en, this message translates to:
  /// **'Same pace as last week'**
  String get trendSame;

  /// No description provided for @sessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String sessionMinutes(int count);

  /// No description provided for @breatheComplete.
  ///
  /// In en, this message translates to:
  /// **'That\'s enough'**
  String get breatheComplete;

  /// No description provided for @breatheCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'A quiet minute, done.'**
  String get breatheCompleteBody;

  /// No description provided for @breatheAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get breatheAgain;

  /// No description provided for @breathCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get breathCalm;

  /// No description provided for @breathBox.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get breathBox;

  /// No description provided for @breathFourSevenEight.
  ///
  /// In en, this message translates to:
  /// **'4-7-8'**
  String get breathFourSevenEight;

  /// No description provided for @breathCoherent.
  ///
  /// In en, this message translates to:
  /// **'Coherent'**
  String get breathCoherent;

  /// No description provided for @breathStepIn.
  ///
  /// In en, this message translates to:
  /// **'In {seconds}'**
  String breathStepIn(int seconds);

  /// No description provided for @breathStepHold.
  ///
  /// In en, this message translates to:
  /// **'Hold {seconds}'**
  String breathStepHold(int seconds);

  /// No description provided for @breathStepOut.
  ///
  /// In en, this message translates to:
  /// **'Out {seconds}'**
  String breathStepOut(int seconds);

  /// No description provided for @greetingNamed.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingNamed(String greeting, String name);

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @namePrompt.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get namePrompt;

  /// No description provided for @partOfDay.
  ///
  /// In en, this message translates to:
  /// **'Part of day'**
  String get partOfDay;

  /// No description provided for @partAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get partAll;

  /// No description provided for @partMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get partMorning;

  /// No description provided for @partAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get partAfternoon;

  /// No description provided for @partEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get partEvening;

  /// No description provided for @partAnytime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get partAnytime;

  /// No description provided for @partEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this part of the day.'**
  String get partEmpty;

  /// No description provided for @dataChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we keep?'**
  String get dataChoiceTitle;

  /// No description provided for @dataChoiceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get dataChoiceConfirm;

  /// No description provided for @dataChoiceGoBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get dataChoiceGoBack;

  /// No description provided for @dataChoiceMerge.
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get dataChoiceMerge;

  /// No description provided for @dataChoiceMergeBody.
  ///
  /// In en, this message translates to:
  /// **'Bring this device\'s habits into the account.'**
  String get dataChoiceMergeBody;

  /// No description provided for @dataChoiceKeepAccount.
  ///
  /// In en, this message translates to:
  /// **'Use the account'**
  String get dataChoiceKeepAccount;

  /// No description provided for @dataChoiceKeepAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Leave this device\'s habits behind.'**
  String get dataChoiceKeepAccountBody;

  /// No description provided for @dataChoiceKeepDevice.
  ///
  /// In en, this message translates to:
  /// **'Use this device'**
  String get dataChoiceKeepDevice;

  /// No description provided for @dataChoiceKeepDeviceBody.
  ///
  /// In en, this message translates to:
  /// **'Replace the account with what is on this device.'**
  String get dataChoiceKeepDeviceBody;

  /// No description provided for @dataChoiceFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get dataChoiceFresh;

  /// No description provided for @dataChoiceFreshBody.
  ///
  /// In en, this message translates to:
  /// **'Clear both and begin with an empty day.'**
  String get dataChoiceFreshBody;

  /// No description provided for @scopeCounts.
  ///
  /// In en, this message translates to:
  /// **'On this device: {habits} habits, {checkIns} check-ins'**
  String scopeCounts(int habits, int checkIns);

  /// No description provided for @accountScopeCounts.
  ///
  /// In en, this message translates to:
  /// **'In the account: {habits} habits, {checkIns} check-ins'**
  String accountScopeCounts(int habits, int checkIns);

  /// No description provided for @gardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get gardenTitle;

  /// No description provided for @gardenShort.
  ///
  /// In en, this message translates to:
  /// **'Your plants'**
  String get gardenShort;

  /// No description provided for @gardenEmpty.
  ///
  /// In en, this message translates to:
  /// **'Each habit you keep becomes a plant.'**
  String get gardenEmpty;

  /// No description provided for @rarePlants.
  ///
  /// In en, this message translates to:
  /// **'Rare plants'**
  String get rarePlants;

  /// No description provided for @stageSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get stageSeed;

  /// No description provided for @stageSprout.
  ///
  /// In en, this message translates to:
  /// **'Sprout'**
  String get stageSprout;

  /// No description provided for @stageBud.
  ///
  /// In en, this message translates to:
  /// **'Bud'**
  String get stageBud;

  /// No description provided for @stageBloom.
  ///
  /// In en, this message translates to:
  /// **'In bloom'**
  String get stageBloom;

  /// No description provided for @stageTree.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get stageTree;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalShort.
  ///
  /// In en, this message translates to:
  /// **'How the day felt'**
  String get journalShort;

  /// No description provided for @noReflections.
  ///
  /// In en, this message translates to:
  /// **'Evenings are a good time for one quiet line.'**
  String get noReflections;

  /// No description provided for @reflectionPrompt.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get reflectionPrompt;

  /// No description provided for @reflectionBody.
  ///
  /// In en, this message translates to:
  /// **'A mood, one thing you\'re glad for, and a note if you want.'**
  String get reflectionBody;

  /// No description provided for @reflectionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved for today. Tap to change it.'**
  String get reflectionSaved;

  /// No description provided for @gratitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Glad for'**
  String get gratitudeLabel;

  /// No description provided for @gratitudeHint.
  ///
  /// In en, this message translates to:
  /// **'One small thing'**
  String get gratitudeHint;

  /// No description provided for @reflectionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get reflectionNote;

  /// No description provided for @recapTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get recapTitle;

  /// No description provided for @recapBanner.
  ///
  /// In en, this message translates to:
  /// **'Your week, told in a few cards.'**
  String get recapBanner;

  /// No description provided for @recapEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A quiet week. Next week is a fresh page.'**
  String get recapEmptyBody;

  /// No description provided for @recapNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get recapNextTitle;

  /// No description provided for @recapNextBody.
  ///
  /// In en, this message translates to:
  /// **'Same habits, a new stretch of days.'**
  String get recapNextBody;

  /// No description provided for @recapBestDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No standout day yet.'**
  String get recapBestDayEmpty;

  /// No description provided for @recapBestDayBody.
  ///
  /// In en, this message translates to:
  /// **'{day} was the fullest, with {count} check-ins.'**
  String recapBestDayBody(String day, int count);

  /// No description provided for @recapCheckInsTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get recapCheckInsTitle;

  /// No description provided for @recapCheckInsBody.
  ///
  /// In en, this message translates to:
  /// **'{count} habits finished over the last seven days.'**
  String recapCheckInsBody(int count);

  /// No description provided for @recapBestDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get recapBestDayTitle;

  /// No description provided for @recapTopHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Top habit'**
  String get recapTopHabitTitle;

  /// No description provided for @recapTopHabitEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habit led the week.'**
  String get recapTopHabitEmpty;

  /// No description provided for @recapTopHabitBody.
  ///
  /// In en, this message translates to:
  /// **'{habit} showed up {count} times.'**
  String recapTopHabitBody(String habit, int count);

  /// No description provided for @recapPerfectTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect days'**
  String get recapPerfectTitle;

  /// No description provided for @recapPerfectBody.
  ///
  /// In en, this message translates to:
  /// **'{count} days where everything due was done.'**
  String recapPerfectBody(int count);

  /// No description provided for @recapMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get recapMoodTitle;

  /// No description provided for @recapMoodEmpty.
  ///
  /// In en, this message translates to:
  /// **'No mood written down this week.'**
  String get recapMoodEmpty;

  /// No description provided for @recapGardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get recapGardenTitle;

  /// No description provided for @recapGardenBody.
  ///
  /// In en, this message translates to:
  /// **'{count} plants grew this week.'**
  String recapGardenBody(int count);

  /// No description provided for @filterToDo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get filterToDo;

  /// No description provided for @filterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get filterDone;

  /// No description provided for @filterNothingOpen.
  ///
  /// In en, this message translates to:
  /// **'Nothing left in this view.'**
  String get filterNothingOpen;

  /// No description provided for @filterNothingDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing finished yet.'**
  String get filterNothingDone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
