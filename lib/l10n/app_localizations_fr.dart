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

  @override
  String get allDoneTitle => 'La journée est faite';

  @override
  String get allDoneBody => 'Toutes les habitudes du jour sont terminées.';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String doneOfTotal(int done, int total) {
    return '$done sur $total faites';
  }

  @override
  String backfillBanner(String date) {
    return 'Saisie du $date';
  }

  @override
  String get loggingPastBody => 'Ce jour reste dans votre historique.';

  @override
  String get backToToday => 'Retour à aujourd\'\'hui';

  @override
  String get browseTemplates => 'Parcourir les modèles';

  @override
  String get skip => 'Passer';

  @override
  String get continueAction => 'Continuer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get welcomeTitle => 'Hayati';

  @override
  String get welcomeSubtitle => 'Ma vie';

  @override
  String get welcomeBody =>
      'Un endroit calme pour les habitudes qui font votre journée.';

  @override
  String get onboardingHabitsTitle => 'Commencez par quelques-unes';

  @override
  String get onboardingHabitsBody =>
      'Choisissez celles qui vous vont. Vous pourrez les changer.';

  @override
  String get onboardingReminderTitle => 'Un rappel doux';

  @override
  String get onboardingReminderBody =>
      'Facultatif. Une heure pour les habitudes choisies.';

  @override
  String get templateWater => 'Boire de l\'\'eau';

  @override
  String get templateRead => 'Lire';

  @override
  String get templateWalk => 'Marcher';

  @override
  String get templatePray => 'Prier';

  @override
  String get templateSleep => 'Se coucher tôt';

  @override
  String get templateJournal => 'Écrire';

  @override
  String get unitGlasses => 'verres';

  @override
  String get unitPages => 'pages';

  @override
  String get unitMinutes => 'minutes';

  @override
  String get unitTimes => 'fois';

  @override
  String get goal => 'Objectif';

  @override
  String get goalCheck => 'Cocher';

  @override
  String get goalCount => 'Compter';

  @override
  String get target => 'Quantité';

  @override
  String get unit => 'Unité';

  @override
  String get preview => 'Aperçu';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get customUnit => 'Ou saisir une unité';

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
    return '$label, $value pour cent';
  }

  @override
  String ringEmpty(String label) {
    return '$label, rien de prévu';
  }

  @override
  String increaseHabit(String name) {
    return 'Augmenter $name';
  }

  @override
  String decreaseHabit(String name) {
    return 'Diminuer $name';
  }

  @override
  String get noteTitle => 'Note';

  @override
  String get saveNote => 'Enregistrer la note';

  @override
  String get moodLabel => 'Comment ça s\'\'est passé ?';

  @override
  String get moodAwful => 'Difficile';

  @override
  String get moodLow => 'Bas';

  @override
  String get moodOkay => 'Correct';

  @override
  String get moodGood => 'Bien';

  @override
  String get moodGreat => 'Très bien';

  @override
  String get recentNotes => 'Notes';

  @override
  String get noNotesYet => 'Pas encore de note.';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyBody =>
      'Vos habitudes restent sur cet appareil. Rien n\'\'est envoyé, même si les rapports sont activés.';

  @override
  String get archivedHabits => 'Archivées';

  @override
  String get noArchivedHabits => 'Aucune habitude archivée.';

  @override
  String get replayOnboarding => 'Revoir l\'\'introduction';

  @override
  String get licenses => 'Licences';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get sectionAbout => 'À propos';

  @override
  String get archiveHabitTitle => 'Archiver cette habitude ?';

  @override
  String get archiveHabitMessage =>
      'Elle quitte Aujourd\'\'hui. Vous pouvez la restaurer depuis le profil.';

  @override
  String get archivedMessage => 'Archivée';

  @override
  String get restoredMessage => 'Restaurée';

  @override
  String get lastSevenDays => '7 derniers jours';

  @override
  String get completionRate => 'Réussite';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get dragToReorder => 'Glisser pour réordonner';

  @override
  String get nothingDueOnDay => 'Rien de prévu ce jour-là';

  @override
  String get cleared => 'Effacé';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get previousWeek => 'Semaine précédente';

  @override
  String get nextWeek => 'Semaine suivante';
}
