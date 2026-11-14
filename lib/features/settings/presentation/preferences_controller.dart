import 'package:hayati/core/database/database_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hayati/features/settings/data/drift_settings_repository.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/domain/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_controller.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return DriftSettingsRepository(ref.watch(appDatabaseProvider));
}

/// The saved language, palette, brightness, and week start.
///
/// keepAlive so a route change cannot drop the choice back to the defaults
/// while the settings screen is off stage. The stream comes from Drift, so
/// a write shows up on the next frame.
@Riverpod(keepAlive: true)
class PreferencesController extends _$PreferencesController {
  @override
  Stream<AppPreferences> build() {
    return ref.watch(settingsRepositoryProvider).watch();
  }

  Future<void> setLocale(String? languageCode) {
    final platform = WidgetsBinding.instance.platformDispatcher;
    platform.setApplicationLocale(
      languageCode == null ? platform.locale : Locale(languageCode),
    );
    return ref.read(settingsRepositoryProvider).setLocale(languageCode);
  }

  Future<void> setTheme(AppThemeId themeId) {
    return ref.read(settingsRepositoryProvider).setTheme(themeId);
  }

  Future<void> setAppearance(Appearance appearance) {
    return ref.read(settingsRepositoryProvider).setAppearance(appearance);
  }

  Future<void> setWeekStart(int weekStart) {
    return ref.read(settingsRepositoryProvider).setWeekStart(weekStart);
  }

  Future<void> setAnalyticsEnabled(bool enabled) {
    return ref.read(settingsRepositoryProvider).setAnalyticsEnabled(enabled);
  }

  Future<void> setOnboardingDone(bool done) {
    return ref.read(settingsRepositoryProvider).setOnboardingDone(done);
  }

  Future<void> setDisplayName(String name) {
    return ref.read(settingsRepositoryProvider).setDisplayName(name);
  }
}
