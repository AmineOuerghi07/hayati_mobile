import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

/// Which set of habits is on screen. Guest data moves onto the account
/// at sign-in. Sign-out opens a fresh empty guest scope so the previous
/// account stays private on this device.
class DataScope {
  DataScope(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  static const guest = 'guest';
  static const activeKey = 'activeScopeId';

  final AppDatabase _db;
  final Uuid _uuid;

  Future<String> current() async {
    final row =
        await (_db.select(_db.appSettings)..where(
              (item) =>
                  item.settingKey.equals(activeKey) & item.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    final value = row?.settingValue;
    if (value == null || value.isEmpty) return guest;
    return value;
  }

  Future<void> setCurrent(String scopeId) => _write(activeKey, scopeId);

  Future<void> attachCurrentGuestTo(String userId) async {
    final scope = await current();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await (_db.update(
        _db.habits,
      )..where((row) => row.scopeId.equals(scope))).write(
        HabitsCompanion(scopeId: Value(userId), updatedAt: Value(now)),
      );
      await (_db.update(
        _db.habitCompletions,
      )..where((row) => row.scopeId.equals(scope))).write(
        HabitCompletionsCompanion(
          scopeId: Value(userId),
          updatedAt: Value(now),
        ),
      );
    });
    await setCurrent(userId);
  }

  Future<void> openFreshGuest() => setCurrent('guest-${_uuid.v4()}');

  Future<void> _write(String key, String value) async {
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
