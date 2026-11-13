import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_controller.g.dart';

/// Locale override chosen in Settings.
///
/// Null follows the device. Nothing is persisted yet; the Drift settings
/// table arrives with the habit flows. keepAlive so the choice survives
/// leaving Settings, instead of resetting when the page is no longer watched.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale? build() => null;

  void setLocale(Locale? locale) => state = locale;
}
