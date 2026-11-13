import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/telemetry/analytics.dart';
import 'package:hayati/core/telemetry/crash_reporter.dart';
import 'package:hayati/features/settings/data/drift_settings_repository.dart';

void main() {
  test('usage reports stay off until the profile turns them on', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final settings = DriftSettingsRepository(database);

    expect((await settings.watch().first).analyticsEnabled, isFalse);
    await settings.setAnalyticsEnabled(true);
    expect((await settings.watch().first).analyticsEnabled, isTrue);
  });

  test('the shipped reporters do not throw', () async {
    await const NoopAnalytics().track('opened');
    await const NoopCrashReporter().record(StateError('x'), StackTrace.empty);
  });
}
