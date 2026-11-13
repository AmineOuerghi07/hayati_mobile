import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/app/router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/features/settings/presentation/locale_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';

class HayatiApp extends ConsumerWidget {
  const HayatiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: config.isDev,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildHayatiTheme(Brightness.light),
      darkTheme: buildHayatiTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
