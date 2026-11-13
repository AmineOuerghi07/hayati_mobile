/// Crash reports. The shipped reporter does nothing. A later one must stay
/// idle unless the profile opt-in is on.
abstract class CrashReporter {
  Future<void> record(Object error, StackTrace stack);
}

class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  Future<void> record(Object error, StackTrace stack) {
    return Future.value();
  }
}
