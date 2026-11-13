import 'package:flutter/services.dart';
import 'package:hayati/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

/// Flavor and dart-define values for this process.
///
/// keepAlive because the values are fixed at compile time. Recreating the
/// provider when a screen is disposed would suggest they can change.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  return AppConfig.fromEnvironment(flavorName: appFlavor);
}
