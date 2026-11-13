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
}
