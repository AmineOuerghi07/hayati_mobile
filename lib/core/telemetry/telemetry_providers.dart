import 'package:hayati/core/telemetry/analytics.dart';
import 'package:hayati/core/telemetry/crash_reporter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telemetry_providers.g.dart';

@Riverpod(keepAlive: true)
Analytics analytics(Ref ref) => const NoopAnalytics();

@Riverpod(keepAlive: true)
CrashReporter crashReporter(Ref ref) => const NoopCrashReporter();
