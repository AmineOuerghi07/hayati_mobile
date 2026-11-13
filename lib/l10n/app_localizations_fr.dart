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

  @override
  String get appearance => 'Apparence';

  @override
  String get appearanceSystem => 'Système';

  @override
  String get appearanceLight => 'Clair';

  @override
  String get appearanceDark => 'Sombre';

  @override
  String get colorTheme => 'Thème de couleur';

  @override
  String get themeHayati => 'Hayati';

  @override
  String get themeOasis => 'Oasis';

  @override
  String get themeDawn => 'Aube';

  @override
  String get themeDusk => 'Crépuscule';

  @override
  String get themeBlossom => 'Floraison';

  @override
  String get themeSea => 'Mer';

  @override
  String get themeInk => 'Encre';

  @override
  String get themeContrast => 'Contraste';

  @override
  String get weekStartsOn => 'La semaine commence le';

  @override
  String get weekDayMonday => 'Lundi';

  @override
  String get weekDaySaturday => 'Samedi';

  @override
  String get weekDaySunday => 'Dimanche';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get editHabit => 'Modifier l\'\'habitude';

  @override
  String get habitName => 'Nom';

  @override
  String get nameRequired => 'Saisissez un nom';

  @override
  String get save => 'Enregistrer';

  @override
  String get archive => 'Archiver';

  @override
  String get unarchive => 'Désarchiver';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteHabitTitle => 'Supprimer cette habitude ?';

  @override
  String get deleteHabitMessage =>
      'L\'\'habitude quitte la liste. Son historique reste sur cet appareil.';

  @override
  String get cancel => 'Annuler';

  @override
  String get frequency => 'Fréquence';

  @override
  String get frequencyDaily => 'Tous les jours';

  @override
  String get frequencyWeekdays => 'Jours précis';

  @override
  String get frequencyTimesPerWeek => 'Fois par semaine';

  @override
  String get timesEachWeek => 'Fois chaque semaine';

  @override
  String get reminder => 'Rappel';

  @override
  String get reminderNone => 'Aucun rappel';

  @override
  String get clearReminder => 'Effacer le rappel';

  @override
  String get currentStreak => 'Série en cours';

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String streakDays(int count) {
    return '$count jours';
  }

  @override
  String streakWeeks(int count) {
    return '$count semaines';
  }

  @override
  String get markedDone => 'Marqué comme fait';

  @override
  String get clearedForToday => 'Annulé pour aujourd\'\'hui';

  @override
  String get undo => 'Annuler';

  @override
  String get emptyTodayTitle => 'Rien de prévu aujourd\'hui';

  @override
  String get emptyTodayBody => 'Ajoutez une habitude et elle apparaîtra ici.';

  @override
  String get chooseDays => 'Choisissez au moins un jour';

  @override
  String get history => 'Historique';

  @override
  String get icon => 'Icône';

  @override
  String get color => 'Couleur';

  @override
  String get loading => 'Chargement';
}
