import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A light tap for checks and tabs, or a firmer one when the day is complete.
///
/// Widget and integration tests have no haptic plugin, so the call is skipped
/// there instead of failing the suite.
void playHaptic({bool strong = false}) {
  final binding = WidgetsBinding.instance.runtimeType.toString();
  if (binding.contains('Test')) return;
  final future = strong
      ? HapticFeedback.mediumImpact()
      : HapticFeedback.lightImpact();
  future.catchError((Object _) {});
}
