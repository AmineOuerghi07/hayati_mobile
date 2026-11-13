import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/app/router.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/telemetry/telemetry_providers.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/features/reminders/presentation/reminder_providers.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HayatiApp extends ConsumerWidget {
  const HayatiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final preferencesAsync = ref.watch(preferencesControllerProvider);
    final preferences = preferencesAsync.value;
    if (preferences == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: config.isDev,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: preferencesAsync.hasError
                ? const AsyncErrorView()
                : const CircularProgressIndicator(key: Key('today-loading')),
          ),
        ),
      );
    }
    final router = ref.watch(appRouterProvider);
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
      routerConfig: router,
    );
  }
}
