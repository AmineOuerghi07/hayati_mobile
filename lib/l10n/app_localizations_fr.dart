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

  @override
  String get heroStart =>
      'Une nouvelle journée. Un petit pas suffit pour commencer.';

  @override
  String get heroProgress => 'Joli rythme. Continuez.';

  @override
  String plantGrowth(int percent) {
    return 'Votre plante a poussé à $percent pour cent';
  }

  @override
  String get perfectDays => 'Jours parfaits, 30 derniers';

  @override
  String get checkIns => 'Validations';

  @override
  String get moodThisWeek => 'Humeur cette semaine';

  @override
  String get quote1 => 'De petits pas chaque jour font une vie que l\'on aime.';

  @override
  String get quote2 => 'Pas besoin d\'être parfait, juste régulier.';

  @override
  String get quote3 => 'Arrosez la plante que vous voulez voir grandir.';

  @override
  String get quote4 => 'Le progrès, pas la perfection.';

  @override
  String get quote5 => 'Soyez doux avec vous-même. Vous grandissez.';

  @override
  String get quote6 =>
      'Ce que vous faites chaque jour compte plus que ce que vous faites de temps en temps.';

  @override
  String get quote7 => 'Commencez là où vous êtes, avec ce que vous avez.';

  @override
  String get quote8 => 'Un esprit calme bâtit une vie solide.';

  @override
  String get authSignInTitle => 'Bon retour';

  @override
  String get authSignInBody =>
      'Connectez-vous pour synchroniser vos habitudes sur tous vos appareils.';

  @override
  String get authCreateTitle => 'Commencez votre parcours';

  @override
  String get authCreateBody =>
      'Créez un compte pour sauvegarder vos séries et vos progrès.';

  @override
  String get benefitSync => 'Synchronisé sur vos appareils';

  @override
  String get benefitBackup => 'Vos séries, sauvegardées en sécurité';

  @override
  String get benefitPrivate => 'Privé par conception. Jamais de publicité.';

  @override
  String get orDivider => 'ou';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get passwordWeak => 'Faible';

  @override
  String get passwordFair => 'Moyen';

  @override
  String get passwordGood => 'Bon';

  @override
  String get passwordStrong => 'Fort';

  @override
  String passwordStrength(String level) {
    return 'Force du mot de passe : $level';
  }

  @override
  String get otpBody =>
      'Nous enverrons un code à usage unique. Pas besoin de mot de passe.';

  @override
  String codeSentTo(String destination) {
    return 'Saisissez le code envoyé à $destination';
  }

  @override
  String codeExpiresIn(String time) {
    return 'Expire dans $time';
  }

  @override
  String get codeExpiredHint => 'Ce code a expiré. Envoyez-en un nouveau.';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get changeDestination => 'Utiliser une autre adresse';

  @override
  String stepOf(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get passwordUpdatedBody =>
      'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.';

  @override
  String get changePasswordBody =>
      'Utilisez au moins 8 caractères mêlant lettres, chiffres et symboles.';

  @override
  String get achievements => 'Succès';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get tools => 'Outils';

  @override
  String unlockedOf(int count, int total) {
    return '$count sur $total débloqués';
  }

  @override
  String achievementUnlocked(String title) {
    return '$title, débloqué';
  }

  @override
  String achievementLocked(String title, int current, int target) {
    return '$title, verrouillé, $current sur $target';
  }

  @override
  String get unlocked => 'Débloqué';

  @override
  String progressOf(int current, int target) {
    return '$current / $target';
  }

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String xpProgress(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String get levelSeed => 'Graine';

  @override
  String get levelSprout => 'Pousse';

  @override
  String get levelSapling => 'Jeune pousse';

  @override
  String get levelBloom => 'Floraison';

  @override
  String get levelTree => 'Arbre';

  @override
  String get levelForest => 'Forêt';

  @override
  String get achFirstStep => 'Premier pas';

  @override
  String get achFirstStepBody => 'Accomplissez votre première habitude.';

  @override
  String get achStreak3 => 'On s\'échauffe';

  @override
  String get achStreak7 => 'Une semaine solide';

  @override
  String get achStreak30 => 'Inarrêtable';

  @override
  String achStreakBody(int count) {
    return 'Atteignez une série de $count jours.';
  }

  @override
  String get achPerfectDay => 'Journée parfaite';

  @override
  String get achPerfectDayBody =>
      'Terminez toutes les habitudes prévues d\'une journée.';

  @override
  String get achPerfectWeek => 'Semaine parfaite';

  @override
  String get achPerfectWeekBody => 'Sept journées parfaites d\'affilée.';

  @override
  String get achCheckIns50 => 'Demi-centaine';

  @override
  String get achCheckIns100 => 'Centurion';

  @override
  String achCheckInsBody(int count) {
    return 'Validez $count fois.';
  }

  @override
  String get achHabitBuilder => 'Bâtisseur d\'habitudes';

  @override
  String get achHabitBuilderBody => 'Suivez cinq habitudes à la fois.';

  @override
  String get achReflective => 'Réfléchi';

  @override
  String get achReflectiveBody => 'Écrivez dix notes ou humeurs.';

  @override
  String get achEarlyBird => 'Lève-tôt';

  @override
  String get achEarlyBirdBody => 'Validez avant 8 h du matin.';

  @override
  String get achNightOwl => 'Oiseau de nuit';

  @override
  String get achNightOwlBody => 'Validez après 22 h.';

  @override
  String get focusTitle => 'Concentration';

  @override
  String get focusShort => 'Un minuteur calme';

  @override
  String get focusBody =>
      'Choisissez une durée, posez le téléphone et installez-vous.';

  @override
  String get focusDone => 'Séance terminée. Bravo.';

  @override
  String focusLogged(int minutes, String habit) {
    return '$minutes min ajoutées à $habit';
  }

  @override
  String focusRemaining(String time) {
    return '$time restantes';
  }

  @override
  String get focusInProgress => 'Concentration';

  @override
  String get focusPaused => 'En pause';

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String get start => 'Démarrer';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get startFocus => 'Lancer une séance de concentration';

  @override
  String get breatheTitle => 'Respirer';

  @override
  String get breatheShort => 'Une minute de calme';

  @override
  String get breatheBody =>
      'Suivez le cercle : inspirez 4, retenez 4, expirez 6.';

  @override
  String get breatheReady => 'Prêt';

  @override
  String get breatheIn => 'Inspirez';

  @override
  String get breatheHold => 'Retenez';

  @override
  String get breatheOut => 'Expirez';

  @override
  String breathCycles(int count) {
    return 'Respirations : $count';
  }

  @override
  String get weeklyTrend => 'Par rapport à la semaine dernière';

  @override
  String trendUp(int points) {
    return '$points points d\'avance sur la semaine dernière';
  }

  @override
  String trendDown(int points) {
    return '$points points de retard sur la semaine dernière';
  }

  @override
  String get trendSame => 'Même rythme que la semaine dernière';

  @override
  String sessionMinutes(int count) {
    return '$count min';
  }

  @override
  String get breatheComplete => 'C\'est assez';

  @override
  String get breatheCompleteBody => 'Une minute calme, terminée.';

  @override
  String get breatheAgain => 'Encore';

  @override
  String get breathCalm => 'Calme';

  @override
  String get breathBox => 'Carré';

  @override
  String get breathFourSevenEight => '4-7-8';

  @override
  String get breathCoherent => 'Cohérent';

  @override
  String breathStepIn(int seconds) {
    return 'Inspirez $seconds';
  }

  @override
  String breathStepHold(int seconds) {
    return 'Retenez $seconds';
  }

  @override
  String breathStepOut(int seconds) {
    return 'Expirez $seconds';
  }

  @override
  String greetingNamed(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get yourName => 'Votre nom';

  @override
  String get namePrompt => 'Comment devons-nous vous appeler ?';

  @override
  String get partOfDay => 'Moment de la journée';

  @override
  String get partAll => 'Tout';

  @override
  String get partMorning => 'Matin';

  @override
  String get partAfternoon => 'Après-midi';

  @override
  String get partEvening => 'Soir';

  @override
  String get partAnytime => 'N\'importe quand';

  @override
  String get partEmpty => 'Rien pour ce moment de la journée.';

  @override
  String get dataChoiceTitle => 'Que faut-il garder ?';

  @override
  String get dataChoiceConfirm => 'Continuer';

  @override
  String get dataChoiceGoBack => 'Retour';

  @override
  String get dataChoiceMerge => 'Garder les deux';

  @override
  String get dataChoiceMergeBody =>
      'Ajouter les habitudes de cet appareil au compte.';

  @override
  String get dataChoiceKeepAccount => 'Utiliser le compte';

  @override
  String get dataChoiceKeepAccountBody =>
      'Laisser les habitudes de cet appareil de côté.';

  @override
  String get dataChoiceKeepDevice => 'Utiliser cet appareil';

  @override
  String get dataChoiceKeepDeviceBody =>
      'Remplacer le compte par ce qui est sur cet appareil.';

  @override
  String get dataChoiceFresh => 'Repartir à zéro';

  @override
  String get dataChoiceFreshBody =>
      'Effacer les deux et commencer une journée vide.';

  @override
  String scopeCounts(int habits, int checkIns) {
    return 'Sur cet appareil : $habits habitudes, $checkIns suivis';
  }

  @override
  String accountScopeCounts(int habits, int checkIns) {
    return 'Dans le compte : $habits habitudes, $checkIns suivis';
  }

  @override
  String get gardenTitle => 'Jardin';

  @override
  String get gardenShort => 'Vos plantes';

  @override
  String get gardenEmpty =>
      'Chaque habitude que vous gardez devient une plante.';

  @override
  String get rarePlants => 'Plantes rares';

  @override
  String get stageSeed => 'Graine';

  @override
  String get stageSprout => 'Pousse';

  @override
  String get stageBud => 'Bourgeon';

  @override
  String get stageBloom => 'En fleur';

  @override
  String get stageTree => 'Arbre';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalShort => 'Le ressenti du jour';

  @override
  String get noReflections =>
      'Le soir est un bon moment pour une ligne tranquille.';

  @override
  String get reflectionPrompt => 'Comment s\'est passée votre journée ?';

  @override
  String get reflectionBody =>
      'Une humeur, une chose dont vous êtes content, et une note si vous voulez.';

  @override
  String get reflectionSaved =>
      'Enregistré pour aujourd\'hui. Touchez pour modifier.';

  @override
  String get gratitudeLabel => 'Content de';

  @override
  String get gratitudeHint => 'Une petite chose';

  @override
  String get reflectionNote => 'Note';

  @override
  String get recapTitle => 'Cette semaine';

  @override
  String get recapBanner => 'Votre semaine, en quelques cartes.';

  @override
  String get recapEmptyBody =>
      'Une semaine calme. La suivante est une page neuve.';

  @override
  String get recapNextTitle => 'Semaine prochaine';

  @override
  String get recapNextBody =>
      'Les mêmes habitudes, une nouvelle série de jours.';

  @override
  String get recapBestDayEmpty => 'Pas encore de jour marquant.';

  @override
  String recapBestDayBody(String day, int count) {
    return '$day a été le plus rempli, avec $count suivis.';
  }

  @override
  String get recapCheckInsTitle => 'Suivis';

  @override
  String recapCheckInsBody(int count) {
    return '$count habitudes terminées sur les sept derniers jours.';
  }

  @override
  String get recapBestDayTitle => 'Meilleur jour';

  @override
  String get recapTopHabitTitle => 'Habitude principale';

  @override
  String get recapTopHabitEmpty => 'Aucune habitude n\'a mené la semaine.';

  @override
  String recapTopHabitBody(String habit, int count) {
    return '$habit est revenue $count fois.';
  }

  @override
  String get recapPerfectTitle => 'Jours parfaits';

  @override
  String recapPerfectBody(int count) {
    return '$count jours où tout ce qui était dû a été fait.';
  }

  @override
  String get recapMoodTitle => 'Humeur';

  @override
  String get recapMoodEmpty => 'Aucune humeur notée cette semaine.';

  @override
  String get recapGardenTitle => 'Jardin';

  @override
  String recapGardenBody(int count) {
    return '$count plantes ont grandi cette semaine.';
  }
}
