import 'dart:async';

import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/domain/settings_repository.dart';

/// In-memory settings used by widget tests so they do not open SQLite.
class MemorySettingsRepository implements SettingsRepository {
  /// Widget tests open the app after the introduction. Pass [initial] with
  /// [AppPreferences.fallback] to cover the first-run flow.
  MemorySettingsRepository({AppPreferences? initial})
    : _current =
          initial ?? AppPreferences.fallback.copyWith(onboardingDone: true);

  AppPreferences _current;
  final _updates = StreamController<AppPreferences>.broadcast();

  @override
  Stream<AppPreferences> watch() async* {
    yield _current;
    yield* _updates.stream;
  }

  @override
  Future<void> setLocale(String? languageCode) {
    return _update(
      _current.copyWith(
        localeCode: languageCode,
        clearLocale: languageCode == null,
      ),
    );
  }

  @override
  Future<void> setTheme(AppThemeId themeId) {
    return _update(_current.copyWith(themeId: themeId));
  }

  @override
  Future<void> setAppearance(Appearance appearance) {
    return _update(_current.copyWith(appearance: appearance));
  }

  @override
  Future<void> setWeekStart(int weekStart) {
    return _update(_current.copyWith(weekStart: weekStart));
  }

  @override
  Future<void> setAnalyticsEnabled(bool enabled) {
    return _update(_current.copyWith(analyticsEnabled: enabled));
  }

  @override
  Future<void> setOnboardingDone(bool done) {
    return _update(_current.copyWith(onboardingDone: done));
  }

  @override
  Future<void> setDisplayName(String name) {
    return _update(_current.copyWith(displayName: name.trim()));
  }

  @override
  Future<void> setRecapDismissedWeek(String? weekStartIso) {
    return _update(
      _current.copyWith(
        recapDismissedWeek: weekStartIso,
        clearRecapDismissedWeek: weekStartIso == null,
      ),
    );
  }

  @override
  Future<void> setPause({String? start, String? end}) {
    if (start == null || end == null) {
      return _update(_current.copyWith(clearPause: true));
    }
    return _update(_current.copyWith(pauseStart: start, pauseEnd: end));
  }

  Future<void> _update(AppPreferences next) async {
    _current = next;
    _updates.add(next);
  }
}
