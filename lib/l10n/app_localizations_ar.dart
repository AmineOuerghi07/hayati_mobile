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
}
