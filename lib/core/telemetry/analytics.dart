/// Usage events. The app ships a no-op so a later reporter can replace the
/// provider without touching screens.
abstract class Analytics {
  Future<void> track(String name, [Map<String, Object?> properties]);
}

class NoopAnalytics implements Analytics {
  const NoopAnalytics();

  @override
  Future<void> track(
    String name, [
    Map<String, Object?> properties = const {},
  ]) {
    return Future.value();
  }
}
