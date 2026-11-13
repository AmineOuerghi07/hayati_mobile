import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/config/app_config.dart';

void main() {
  test('a missing flavor name means production', () {
    expect(parseAppFlavor(null), AppFlavor.prod);
    expect(parseAppFlavor(''), AppFlavor.prod);
    expect(parseAppFlavor('prod'), AppFlavor.prod);
    expect(parseAppFlavor('dev'), AppFlavor.dev);
  });

  test('unknown flavor names fail fast', () {
    expect(() => parseAppFlavor('staging'), throwsArgumentError);
  });

  test('supabase values come from dart-define and start empty', () {
    final dev = AppConfig.fromEnvironment(flavorName: 'dev');
    final prod = AppConfig.fromEnvironment(flavorName: 'prod');

    expect(dev.flavor, AppFlavor.dev);
    expect(dev.isDev, isTrue);
    expect(prod.flavor, AppFlavor.prod);
    expect(prod.isDev, isFalse);
    expect(dev.supabaseUrl, isEmpty);
    expect(dev.supabaseAnonKey, isEmpty);
    expect(prod.supabaseUrl, isEmpty);
    expect(prod.supabaseAnonKey, isEmpty);
  });
}
