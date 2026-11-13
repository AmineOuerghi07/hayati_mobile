// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Hayati';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get stats => 'Statistiques';

  @override
  String get settings => 'Réglages';

  @override
  String get todayPlaceholder =>
      'Les habitudes sur lesquelles vous travaillez apparaîtront ici.';

  @override
  String get statsPlaceholder =>
      'Les statistiques arriveront dans une prochaine mise à jour.';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageFrench => 'Français';

  @override
  String get environment => 'Environnement';

  @override
  String get flavorDev => 'Développement';

  @override
  String get flavorProd => 'Production';
}
