import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';

/// Whether the introduction is finished, updated before the database write
/// so navigation does not bounce back to the welcome screen.
class OnboardingFlag extends Notifier<bool?> {
  @override
  bool? build() {
    ref.listen<AsyncValue<AppPreferences>>(preferencesControllerProvider, (
      previous,
      next,
    ) {
      final value = next.value?.onboardingDone;
      if (value == null || value == state) return;
      state = value;
    });
    return ref.read(preferencesControllerProvider).value?.onboardingDone;
  }

  void markFinished() => state = true;

  void markReplay() => state = false;
}

final onboardingFlagProvider = NotifierProvider<OnboardingFlag, bool?>(
  OnboardingFlag.new,
);
