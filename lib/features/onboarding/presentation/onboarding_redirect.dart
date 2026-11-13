/// Where to send the app while the introduction is unfinished.
///
/// Null means stay put. A missing flag means preferences are still loading.
String? onboardingRedirect({
  required bool? onboardingDone,
  required String location,
}) {
  if (onboardingDone == null) return null;
  final onboarding = location == '/onboarding';
  if (!onboardingDone && !onboarding) return '/onboarding';
  if (onboardingDone && onboarding) return '/today';
  return null;
}
