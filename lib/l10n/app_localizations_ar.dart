// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حياتي';

  @override
  String get today => 'اليوم';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get todayPlaceholder => 'ستظهر هنا العادات التي تعمل عليها.';

  @override
  String get statsPlaceholder => 'الإحصاءات ستصل في تحديث لاحق.';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة الجهاز';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get environment => 'البيئة';

  @override
  String get flavorDev => 'تطوير';

  @override
  String get flavorProd => 'إنتاج';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceSystem => 'الجهاز';

  @override
  String get appearanceLight => 'فاتح';

  @override
  String get appearanceDark => 'داكن';

  @override
  String get colorTheme => 'ألوان التطبيق';

  @override
  String get themeHayati => 'حياتي';

  @override
  String get themeOasis => 'واحة';

  @override
  String get themeDawn => 'فجر';

  @override
  String get themeDusk => 'غسق';

  @override
  String get themeBlossom => 'زهر';

  @override
  String get themeSea => 'بحر';

  @override
  String get themeInk => 'حبر';

  @override
  String get themeContrast => 'تباين';

  @override
  String get weekStartsOn => 'يبدأ الأسبوع يوم';

  @override
  String get weekDayMonday => 'الاثنين';

  @override
  String get weekDaySaturday => 'السبت';

  @override
  String get weekDaySunday => 'الأحد';

  @override
  String get profile => 'الملف';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get email => 'البريد';

  @override
  String get password => 'كلمة السر';

  @override
  String get displayName => 'الاسم';

  @override
  String get forgotPassword => 'نسيت كلمة السر';

  @override
  String get usePhoneCode => 'الدخول برمز';

  @override
  String get emailOrPhone => 'البريد أو الهاتف';

  @override
  String get sendCode => 'إنشاء الرمز';

  @override
  String get verifyCode => 'تأكيد الرمز';

  @override
  String get localDemoCode => 'رمز تجريبي محلي';

  @override
  String get resetHint =>
      'إذا وُجد حساب، يُنشأ رمز تجريبي على هذا الجهاز. لا يُرسل بريد.';

  @override
  String get newPassword => 'كلمة سر جديدة';

  @override
  String get currentPassword => 'كلمة السر الحالية';

  @override
  String get changePassword => 'تغيير كلمة السر';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get onThisDevice => 'على هذا الجهاز';

  @override
  String get guestStatus => 'محفوظ على هذا الجهاز فقط';

  @override
  String get invalidCredentials => 'البيانات غير مطابقة.';

  @override
  String get emailInUse => 'هذا البريد مستخدم.';

  @override
  String get invalidEmail => 'اكتب بريدًا صالحًا.';

  @override
  String get weakPassword => 'استخدم 8 أحرف على الأقل.';

  @override
  String get invalidCode => 'الرمز غير صالح.';

  @override
  String get codeExpired => 'انتهت صلاحية الرمز.';

  @override
  String get accountNotFound => 'لا يوجد حساب.';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get syncing => 'جار المزامنة';

  @override
  String get addHabit => 'عادة جديدة';

  @override
  String get editHabit => 'تعديل العادة';

  @override
  String get habitName => 'الاسم';

  @override
  String get nameRequired => 'اكتب اسمًا';

  @override
  String get save => 'حفظ';

  @override
  String get archive => 'أرشفة';

  @override
  String get unarchive => 'إلغاء الأرشفة';

  @override
  String get delete => 'حذف';

  @override
  String get deleteHabitTitle => 'حذف هذه العادة؟';

  @override
  String get deleteHabitMessage =>
      'ستختفي العادة من قائمتك. يبقى سجلها على هذا الجهاز.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get frequency => 'التكرار';

  @override
  String get frequencyDaily => 'كل يوم';

  @override
  String get frequencyWeekdays => 'أيام محددة';

  @override
  String get frequencyTimesPerWeek => 'مرات في الأسبوع';

  @override
  String get timesEachWeek => 'المرات في كل أسبوع';

  @override
  String get reminder => 'تذكير';

  @override
  String get reminderNone => 'بدون تذكير';

  @override
  String get clearReminder => 'إزالة التذكير';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String streakDays(int count) {
    return '$count يوم';
  }

  @override
  String streakWeeks(int count) {
    return '$count أسبوع';
  }

  @override
  String get markedDone => 'تم التسجيل';

  @override
  String get clearedForToday => 'أُلغي تسجيل اليوم';

  @override
  String get undo => 'تراجع';

  @override
  String get emptyTodayTitle => 'لا شيء مستحق اليوم';

  @override
  String get emptyTodayBody => 'أضف عادة وستظهر هنا.';

  @override
  String get chooseDays => 'اختر يومًا واحدًا على الأقل';

  @override
  String get history => 'السجل';

  @override
  String get icon => 'الأيقونة';

  @override
  String get color => 'اللون';

  @override
  String get loading => 'جار التحميل';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get heatmap => 'آخر 12 أسبوعًا';

  @override
  String get habits => 'العادات';

  @override
  String get noInsightsYet => 'لا يوجد ما يُقاس بعد. أكمل عادة وستظهر هنا.';

  @override
  String get somethingWentWrong => 'حدث خطأ. حاول مرة أخرى بعد لحظات.';

  @override
  String get usageReports => 'تقارير الاستخدام';

  @override
  String get usageReportsBody => 'متوقفة افتراضيًا. هذا الإصدار لا يرسل شيئًا.';

  @override
  String streakMilestone(int count) {
    return 'سلسلة من $count يوم';
  }

  @override
  String get allDoneTitle => 'اكتمل اليوم';

  @override
  String get allDoneBody => 'كل عادات اليوم تمت.';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'طاب نهارك';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String doneOfTotal(int done, int total) {
    return 'تم $done من $total';
  }

  @override
  String backfillBanner(String date) {
    return 'تسجيل $date';
  }

  @override
  String get loggingPastBody => 'يبقى هذا اليوم في سجلك.';

  @override
  String get backToToday => 'العودة إلى اليوم';

  @override
  String get browseTemplates => 'قوالب جاهزة';

  @override
  String get skip => 'تخطي';

  @override
  String get continueAction => 'متابعة';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get welcomeTitle => 'حياتي';

  @override
  String get welcomeSubtitle => 'حياتي';

  @override
  String get welcomeBody => 'مكان هادئ للعادات التي يتكون منها يومك.';

  @override
  String get onboardingHabitsTitle => 'ابدأ بعدد قليل';

  @override
  String get onboardingHabitsBody => 'اختر ما يناسبك. يمكنك تغييره لاحقًا.';

  @override
  String get onboardingReminderTitle => 'تذكير لطيف';

  @override
  String get onboardingReminderBody =>
      'اختياري. تذكير واحد للعادات التي اخترتها.';

  @override
  String get templateWater => 'اشرب ماء';

  @override
  String get templateRead => 'قراءة';

  @override
  String get templateWalk => 'مشي';

  @override
  String get templatePray => 'صلاة';

  @override
  String get templateSleep => 'نوم مبكر';

  @override
  String get templateJournal => 'كتابة';

  @override
  String get unitGlasses => 'أكواب';

  @override
  String get unitPages => 'صفحات';

  @override
  String get unitMinutes => 'دقائق';

  @override
  String get unitTimes => 'مرات';

  @override
  String get goal => 'الهدف';

  @override
  String get goalCheck => 'إنجاز';

  @override
  String get goalCount => 'عدّ';

  @override
  String get target => 'المقدار';

  @override
  String get unit => 'الوحدة';

  @override
  String get preview => 'معاينة';

  @override
  String get suggestions => 'اقتراحات';

  @override
  String get customUnit => 'أو اكتب وحدة';

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
    return '$label، $value بالمئة';
  }

  @override
  String ringEmpty(String label) {
    return '$label، لا شيء مستحق';
  }

  @override
  String increaseHabit(String name) {
    return 'زيادة $name';
  }

  @override
  String decreaseHabit(String name) {
    return 'إنقاص $name';
  }

  @override
  String get noteTitle => 'ملاحظة';

  @override
  String get saveNote => 'حفظ الملاحظة';

  @override
  String get moodLabel => 'كيف كان الشعور؟';

  @override
  String get moodAwful => 'صعب';

  @override
  String get moodLow => 'منخفض';

  @override
  String get moodOkay => 'عادي';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodGreat => 'رائع';

  @override
  String get recentNotes => 'ملاحظات';

  @override
  String get noNotesYet => 'لا ملاحظات بعد.';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyBody =>
      'عاداتك محفوظة على هذا الجهاز. هذا الإصدار لا يرسل شيئًا حتى لو فعّلت التقارير.';

  @override
  String get archivedHabits => 'المؤرشفة';

  @override
  String get noArchivedHabits => 'لا توجد عادات مؤرشفة.';

  @override
  String get replayOnboarding => 'إعادة المقدمة';

  @override
  String get licenses => 'التراخيص';

  @override
  String versionLabel(String version) {
    return 'الإصدار $version';
  }

  @override
  String get sectionAbout => 'حول';

  @override
  String get archiveHabitTitle => 'أرشفة هذه العادة؟';

  @override
  String get archiveHabitMessage => 'ستختفي من اليوم. يمكنك إرجاعها من الملف.';

  @override
  String get archivedMessage => 'تمت الأرشفة';

  @override
  String get restoredMessage => 'تمت الاستعادة';

  @override
  String get lastSevenDays => 'آخر 7 أيام';

  @override
  String get completionRate => 'الإنجاز';

  @override
  String get addNote => 'أضف ملاحظة';

  @override
  String get dragToReorder => 'اسحب للترتيب';

  @override
  String get nothingDueOnDay => 'لا شيء مستحق في هذا اليوم';

  @override
  String get cleared => 'تم المسح';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get previousWeek => 'الأسبوع السابق';

  @override
  String get nextWeek => 'الأسبوع التالي';

  @override
  String get heroStart => 'يوم جديد. خطوة صغيرة تكفي للبداية.';

  @override
  String get heroProgress => 'إيقاع جميل. واصل.';

  @override
  String plantGrowth(int percent) {
    return 'نبتتك نمت بنسبة $percent بالمئة';
  }

  @override
  String get perfectDays => 'أيام مثالية، آخر 30 يومًا';

  @override
  String get checkIns => 'مرات الإنجاز';

  @override
  String get moodThisWeek => 'المزاج هذا الأسبوع';

  @override
  String get quote1 => 'الخطوات الصغيرة كل يوم تصنع حياة تحبها.';

  @override
  String get quote2 => 'لا يلزمك الكمال، يكفيك الاستمرار.';

  @override
  String get quote3 => 'اسقِ النبتة التي تريدها أن تنمو.';

  @override
  String get quote4 => 'التقدم، لا الكمال.';

  @override
  String get quote5 => 'كن لطيفًا مع نفسك. أنت تنمو.';

  @override
  String get quote6 => 'ما تفعله كل يوم أهم مما تفعله من حين لآخر.';

  @override
  String get quote7 => 'ابدأ من حيث أنت، بما لديك.';

  @override
  String get quote8 => 'العقل الهادئ يبني حياة قوية.';

  @override
  String get authSignInTitle => 'أهلًا بعودتك';

  @override
  String get authSignInBody => 'سجّل الدخول لمزامنة عاداتك على كل أجهزتك.';

  @override
  String get authCreateTitle => 'ابدأ رحلتك';

  @override
  String get authCreateBody => 'أنشئ حسابًا لحفظ سلاسلك وتقدّمك.';

  @override
  String get benefitSync => 'مزامنة على كل أجهزتك';

  @override
  String get benefitBackup => 'سلاسلك محفوظة بأمان';

  @override
  String get benefitPrivate => 'خاص منذ البداية. بلا إعلانات أبدًا.';

  @override
  String get orDivider => 'أو';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get passwordWeak => 'ضعيفة';

  @override
  String get passwordFair => 'مقبولة';

  @override
  String get passwordGood => 'جيدة';

  @override
  String get passwordStrong => 'قوية';

  @override
  String passwordStrength(String level) {
    return 'قوة كلمة المرور: $level';
  }

  @override
  String get otpBody => 'سنرسل لك رمزًا لمرة واحدة. لا حاجة لكلمة مرور.';

  @override
  String codeSentTo(String destination) {
    return 'أدخل الرمز المرسل إلى $destination';
  }

  @override
  String codeExpiresIn(String time) {
    return 'ينتهي خلال $time';
  }

  @override
  String get codeExpiredHint => 'انتهت صلاحية الرمز. أرسل رمزًا جديدًا.';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get changeDestination => 'استخدام عنوان آخر';

  @override
  String stepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور';

  @override
  String get passwordUpdatedBody =>
      'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get changePasswordBody =>
      'استخدم 8 أحرف على الأقل تمزج بين الحروف والأرقام والرموز.';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get tools => 'أدوات';

  @override
  String unlockedOf(int count, int total) {
    return '$count من $total مفتوحة';
  }

  @override
  String achievementUnlocked(String title) {
    return '$title، مفتوح';
  }

  @override
  String achievementLocked(String title, int current, int target) {
    return '$title، مقفل، $current من $target';
  }

  @override
  String get unlocked => 'مفتوح';

  @override
  String progressOf(int current, int target) {
    return '$current / $target';
  }

  @override
  String levelLabel(int level) {
    return 'المستوى $level';
  }

  @override
  String xpProgress(int current, int total) {
    return '$current / $total نقطة';
  }

  @override
  String get levelSeed => 'بذرة';

  @override
  String get levelSprout => 'برعم';

  @override
  String get levelSapling => 'شتلة';

  @override
  String get levelBloom => 'زهرة';

  @override
  String get levelTree => 'شجرة';

  @override
  String get levelForest => 'غابة';

  @override
  String get achFirstStep => 'الخطوة الأولى';

  @override
  String get achFirstStepBody => 'أكمل عادتك الأولى.';

  @override
  String get achStreak3 => 'بداية الحماس';

  @override
  String get achStreak7 => 'أسبوع كامل';

  @override
  String get achStreak30 => 'لا يمكن إيقافك';

  @override
  String achStreakBody(int count) {
    return 'حقّق سلسلة من $count أيام.';
  }

  @override
  String get achPerfectDay => 'يوم مثالي';

  @override
  String get achPerfectDayBody => 'أنجز كل العادات المطلوبة في يوم واحد.';

  @override
  String get achPerfectWeek => 'أسبوع مثالي';

  @override
  String get achPerfectWeekBody => 'سبعة أيام مثالية متتالية.';

  @override
  String get achCheckIns50 => 'نصف المئة';

  @override
  String get achCheckIns100 => 'المئوي';

  @override
  String achCheckInsBody(int count) {
    return 'أكمل $count مرة إنجاز.';
  }

  @override
  String get achHabitBuilder => 'باني العادات';

  @override
  String get achHabitBuilderBody => 'حافظ على خمس عادات في وقت واحد.';

  @override
  String get achReflective => 'متأمّل';

  @override
  String get achReflectiveBody => 'اكتب عشر ملاحظات أو حالات مزاجية.';

  @override
  String get achEarlyBird => 'طائر الصباح';

  @override
  String get achEarlyBirdBody => 'سجّل إنجازًا قبل الثامنة صباحًا.';

  @override
  String get achNightOwl => 'بومة الليل';

  @override
  String get achNightOwlBody => 'سجّل إنجازًا بعد العاشرة ليلًا.';

  @override
  String get focusTitle => 'تركيز';

  @override
  String get focusShort => 'مؤقت هادئ';

  @override
  String get focusBody => 'اختر المدة، ضع الهاتف جانبًا، واستقر.';

  @override
  String get focusDone => 'انتهت الجلسة. أحسنت.';

  @override
  String focusLogged(int minutes, String habit) {
    return 'تم تسجيل $minutes دقيقة في $habit';
  }

  @override
  String focusRemaining(String time) {
    return 'متبقٍ $time';
  }

  @override
  String get focusInProgress => 'جارٍ التركيز';

  @override
  String get focusPaused => 'متوقف مؤقتًا';

  @override
  String minutesShort(int count) {
    return '$count د';
  }

  @override
  String get start => 'ابدأ';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'استئناف';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get startFocus => 'ابدأ جلسة تركيز';

  @override
  String get breatheTitle => 'تنفّس';

  @override
  String get breatheShort => 'دقيقة هادئة';

  @override
  String get breatheBody => 'اتبع الدائرة: شهيق 4، احبس 4، زفير 6.';

  @override
  String get breatheReady => 'جاهز';

  @override
  String get breatheIn => 'شهيق';

  @override
  String get breatheHold => 'احبس';

  @override
  String get breatheOut => 'زفير';

  @override
  String breathCycles(int count) {
    return 'الأنفاس: $count';
  }

  @override
  String get weeklyTrend => 'مقارنة بالأسبوع الماضي';

  @override
  String trendUp(int points) {
    return 'متقدّم بـ $points نقطة عن الأسبوع الماضي';
  }

  @override
  String trendDown(int points) {
    return 'متأخر بـ $points نقطة عن الأسبوع الماضي';
  }

  @override
  String get trendSame => 'نفس وتيرة الأسبوع الماضي';

  @override
  String sessionMinutes(int count) {
    return '$count د';
  }

  @override
  String get breatheComplete => 'يكفي هذا';

  @override
  String get breatheCompleteBody => 'دقيقة هادئة، وانتهت.';

  @override
  String get breatheAgain => 'مرة أخرى';

  @override
  String get breathCalm => 'هدوء';

  @override
  String get breathBox => 'مربع';

  @override
  String get breathFourSevenEight => '4-7-8';

  @override
  String get breathCoherent => 'متّزن';

  @override
  String breathStepIn(int seconds) {
    return 'شهيق $seconds';
  }

  @override
  String breathStepHold(int seconds) {
    return 'احبس $seconds';
  }

  @override
  String breathStepOut(int seconds) {
    return 'زفير $seconds';
  }

  @override
  String greetingNamed(String greeting, String name) {
    return '$greeting، $name';
  }

  @override
  String get yourName => 'اسمك';

  @override
  String get namePrompt => 'بماذا نناديك؟';

  @override
  String get partOfDay => 'وقت اليوم';

  @override
  String get partAll => 'الكل';

  @override
  String get partMorning => 'الصباح';

  @override
  String get partAfternoon => 'بعد الظهر';

  @override
  String get partEvening => 'المساء';

  @override
  String get partAnytime => 'في أي وقت';

  @override
  String get partEmpty => 'لا شيء في هذا الوقت من اليوم.';

  @override
  String get dataChoiceTitle => 'ماذا نبقي؟';

  @override
  String get dataChoiceConfirm => 'متابعة';

  @override
  String get dataChoiceGoBack => 'رجوع';

  @override
  String get dataChoiceMerge => 'الإبقاء على الاثنين';

  @override
  String get dataChoiceMergeBody => 'نقل عادات هذا الجهاز إلى الحساب.';

  @override
  String get dataChoiceKeepAccount => 'استخدام الحساب';

  @override
  String get dataChoiceKeepAccountBody => 'ترك عادات هذا الجهاز جانبًا.';

  @override
  String get dataChoiceKeepDevice => 'استخدام هذا الجهاز';

  @override
  String get dataChoiceKeepDeviceBody =>
      'استبدال الحساب بما هو على هذا الجهاز.';

  @override
  String get dataChoiceFresh => 'بداية جديدة';

  @override
  String get dataChoiceFreshBody => 'مسح الاثنين والبدء بيوم فارغ.';

  @override
  String scopeCounts(int habits, int checkIns) {
    return 'على هذا الجهاز: $habits عادات، $checkIns تسجيلات';
  }

  @override
  String accountScopeCounts(int habits, int checkIns) {
    return 'في الحساب: $habits عادات، $checkIns تسجيلات';
  }

  @override
  String get gardenTitle => 'الحديقة';

  @override
  String get gardenShort => 'نباتاتك';

  @override
  String get gardenEmpty => 'كل عادة تحافظ عليها تصبح نبتة.';

  @override
  String get rarePlants => 'نباتات نادرة';

  @override
  String get stageSeed => 'بذرة';

  @override
  String get stageSprout => 'برعم';

  @override
  String get stageBud => 'برعم مغلق';

  @override
  String get stageBloom => 'مزهرة';

  @override
  String get stageTree => 'شجرة';

  @override
  String get journalTitle => 'اليوميات';

  @override
  String get journalShort => 'شعور اليوم';

  @override
  String get noReflections => 'المساء وقت مناسب لسطر هادئ.';

  @override
  String get reflectionPrompt => 'كيف كان يومك؟';

  @override
  String get reflectionBody => 'مزاج، وشيء واحد تسعد به، وملاحظة إن أردت.';

  @override
  String get reflectionSaved => 'حُفظ لليوم. المس للتعديل.';

  @override
  String get gratitudeLabel => 'أفرح بـ';

  @override
  String get gratitudeHint => 'شيء صغير';

  @override
  String get reflectionNote => 'ملاحظة';

  @override
  String get recapTitle => 'هذا الأسبوع';

  @override
  String get recapBanner => 'أسبوعك في بضع بطاقات.';

  @override
  String get recapEmptyBody => 'أسبوع هادئ. الأسبوع القادم صفحة جديدة.';

  @override
  String get recapNextTitle => 'الأسبوع القادم';

  @override
  String get recapNextBody => 'العادات نفسها، وسلسلة أيام جديدة.';

  @override
  String get recapBestDayEmpty => 'لا يوم بارز بعد.';

  @override
  String recapBestDayBody(String day, int count) {
    return 'كان $day الأكثر امتلاءً، بـ $count تسجيلات.';
  }

  @override
  String get recapCheckInsTitle => 'التسجيلات';

  @override
  String recapCheckInsBody(int count) {
    return 'أُنجزت $count عادات خلال الأيام السبعة الأخيرة.';
  }

  @override
  String get recapBestDayTitle => 'أفضل يوم';

  @override
  String get recapTopHabitTitle => 'العادة الأبرز';

  @override
  String get recapTopHabitEmpty => 'لم تتصدر أي عادة الأسبوع.';

  @override
  String recapTopHabitBody(String habit, int count) {
    return 'ظهرت $habit $count مرات.';
  }

  @override
  String get recapPerfectTitle => 'أيام كاملة';

  @override
  String recapPerfectBody(int count) {
    return '$count أيام أُنجز فيها كل ما كان مستحقًا.';
  }

  @override
  String get recapMoodTitle => 'المزاج';

  @override
  String get recapMoodEmpty => 'لم يُكتب مزاج هذا الأسبوع.';

  @override
  String get recapGardenTitle => 'الحديقة';

  @override
  String recapGardenBody(int count) {
    return 'نمت $count نباتات هذا الأسبوع.';
  }

  @override
  String get filterToDo => 'للإنجاز';

  @override
  String get filterDone => 'المكتملة';

  @override
  String get filterNothingOpen => 'لا شيء متبقٍ في هذا العرض.';

  @override
  String get filterNothingDone => 'لم يُنجز شيء بعد.';

  @override
  String get close => 'إغلاق';

  @override
  String get dismissRecap => 'إخفاء';

  @override
  String get recapLastWeek => 'أسبوعك الماضي جاهز';

  @override
  String get skipToday => 'تخطَّ اليوم';

  @override
  String get undoSkip => 'تراجع عن التخطي';

  @override
  String get skippedToday => 'تم التخطي';

  @override
  String get timeOff => 'استراحة';

  @override
  String get timeOffBody =>
      'تحمي كل السلاسل وتوقف التذكيرات أثناء سفر أو يوم راحة.';

  @override
  String timeOffUntil(String date) {
    return 'السلاسل محمية حتى $date';
  }

  @override
  String get clearTimeOff => 'إلغاء الاستراحة';
}
