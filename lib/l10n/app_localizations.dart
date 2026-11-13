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
