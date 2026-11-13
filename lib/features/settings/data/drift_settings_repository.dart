import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/domain/settings_repository.dart';
import 'package:uuid/uuid.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  static const localeKey = 'locale';
  static const themeKey = 'themeId';
  static const appearanceKey = 'appearance';
  static const weekStartKey = 'weekStart';
  static const analyticsKey = 'analyticsEnabled';

  @override
  Stream<AppPreferences> watch() {
    final query = _db.select(_db.appSettings)
      ..where((row) => row.deletedAt.isNull());
    return query.watch().map(_preferencesFrom);
  }

  @override
  Future<void> setLocale(String? languageCode) {
    return _set(localeKey, languageCode ?? '');
  }

  @override
  Future<void> setTheme(AppThemeId themeId) => _set(themeKey, themeId.name);

  @override
  Future<void> setAppearance(Appearance appearance) {
    return _set(appearanceKey, appearance.name);
  }

  @override
  Future<void> setWeekStart(int weekStart) {
    if (weekStart < DateTime.monday || weekStart > DateTime.sunday) {
      throw ArgumentError.value(
        weekStart,
        'weekStart',
        'Use 1 (Monday) through 7 (Sunday).',
      );
    }
    return _set(weekStartKey, '$weekStart');
  }

  @override
  Future<void> setAnalyticsEnabled(bool enabled) {
    return _set(analyticsKey, enabled ? 'true' : 'false');
  }

  AppPreferences _preferencesFrom(List<SettingRow> rows) {
    final values = {for (final row in rows) row.settingKey: row.settingValue};
    final locale = values[localeKey];
    return AppPreferences(
      localeCode: locale == null || locale.isEmpty ? null : locale,
      themeId:
          AppThemeId.values.asNameMap()[values[themeKey] ?? ''] ??
          AppThemeId.hayati,
      appearance:
          Appearance.values.asNameMap()[values[appearanceKey] ?? ''] ??
          Appearance.system,
      weekStart: int.tryParse(values[weekStartKey] ?? '') ?? DateTime.monday,
      analyticsEnabled: values[analyticsKey] == 'true',
    );
  }

  Future<void> _set(String key, String value) async {
    final now = DateTime.now().toUtc();
    final existing =
        await (_db.select(_db.appSettings)..where(
              (row) => row.settingKey.equals(key) & row.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              id: _uuid.v4(),
              createdAt: now,
              updatedAt: now,
              settingKey: key,
              settingValue: value,
            ),
          );
      return;
    }
    await (_db.update(
      _db.appSettings,
    )..where((row) => row.id.equals(existing.id))).write(
      AppSettingsCompanion(settingValue: Value(value), updatedAt: Value(now)),
    );
  }
}
