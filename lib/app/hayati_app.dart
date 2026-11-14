import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/hayati_splash.dart';
import 'package:hayati/app/router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/core/telemetry/telemetry_providers.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/features/reminders/presentation/reminder_providers.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HayatiApp extends ConsumerStatefulWidget {
  const HayatiApp({super.key});

  @override
  ConsumerState<HayatiApp> createState() => _HayatiAppState();
}

class _HayatiAppState extends ConsumerState<HayatiApp> {
  /// Created once. A new [GoRouter] on a language change would mount a second
  /// navigator on the same global key and crash.
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = ref.read(appRouterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final preferencesAsync = ref.watch(preferencesControllerProvider);
    final preferences = preferencesAsync.value ?? AppPreferences.fallback;
    final waiting = preferencesAsync.value == null;
    ref.watch(reminderCoordinatorProvider);
    ref.watch(analyticsProvider);
    ref.watch(crashReporterProvider);
    final locale = preferences.localeCode == null
        ? null
        : Locale(preferences.localeCode!);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: config.isDev,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildHayatiTheme(preferences.themeId, Brightness.light),
      darkTheme: buildHayatiTheme(preferences.themeId, Brightness.dark),
      themeMode: themeModeFor(preferences.appearance),
      routerConfig: _router,
      builder: (context, child) {
        final page = preferencesAsync.hasError
            ? const Scaffold(body: Center(child: AsyncErrorView()))
            : waiting
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(key: Key('today-loading')),
                ),
              )
            : child ?? const SizedBox.shrink();
        return HayatiSplash(ready: !waiting, child: page);
      },
    );
  }
}
