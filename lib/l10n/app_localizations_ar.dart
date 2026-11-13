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
}
