import 'package:hayati/features/settings/domain/app_preferences.dart';

abstract class SettingsRepository {
  Stream<AppPreferences> watch();

  Future<void> setLocale(String? languageCode);

  Future<void> setTheme(AppThemeId themeId);

  Future<void> setAppearance(Appearance appearance);

  Future<void> setWeekStart(int weekStart);

  Future<void> setAnalyticsEnabled(bool enabled);

  Future<void> setOnboardingDone(bool done);

  Future<void> setDisplayName(String name);
}
