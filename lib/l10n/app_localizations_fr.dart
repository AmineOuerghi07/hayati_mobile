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
  String get profile => 'Profil';

  @override
  String get signIn => 'Connexion';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get displayName => 'Nom';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get usePhoneCode => 'Utiliser un code';

  @override
  String get emailOrPhone => 'E-mail ou téléphone';

  @override
  String get sendCode => 'Créer le code';

  @override
  String get verifyCode => 'Vérifier le code';

  @override
  String get localDemoCode => 'Code de démonstration local';

  @override
  String get resetHint =>
      'Si un compte existe, un code local est créé. Aucun e-mail n\'\'est envoyé.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get onThisDevice => 'Sur cet appareil';

  @override
  String get guestStatus => 'Enregistré seulement sur cet appareil';

  @override
  String get invalidCredentials => 'Ces informations ne correspondent pas.';

  @override
  String get emailInUse => 'Cet e-mail a déjà un compte.';

  @override
  String get invalidEmail => 'Saisissez un e-mail valide.';

  @override
  String get weakPassword => 'Utilisez au moins 8 caractères.';

  @override
  String get invalidCode => 'Ce code n\'est pas valide.';

  @override
  String get codeExpired => 'Ce code a expiré.';

  @override
  String get accountNotFound => 'Aucun compte trouvé.';

  @override
  String get syncNow => 'Synchroniser';

  @override
  String get syncing => 'Synchronisation';

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

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get heatmap => '12 dernières semaines';

  @override
  String get habits => 'Habitudes';

  @override
  String get noInsightsYet =>
      'Rien à mesurer pour l\'\'instant. Terminez une habitude et elle apparaîtra ici.';

  @override
  String get somethingWentWrong =>
      'Une erreur s\'\'est produite. Réessayez dans un instant.';

  @override
  String get usageReports => 'Rapports d\'\'utilisation';

  @override
  String get usageReportsBody =>
      'Désactivés par défaut. Cette version n\'\'envoie rien.';

  @override
  String streakMilestone(int count) {
    return 'Série de $count jours';
  }
}
