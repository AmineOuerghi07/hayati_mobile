import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/features/settings/presentation/locale_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum _LanguageChoice { system, english, arabic, french }

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final choice = _choiceFor(ref.watch(localeControllerProvider));
    final config = ref.watch(appConfigProvider);
    final flavorLabel = config.isDev ? l10n.flavorDev : l10n.flavorProd;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        children: [
          Text(l10n.settings, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          Text(l10n.language, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<_LanguageChoice>(
            groupValue: choice,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref
                  .read(localeControllerProvider.notifier)
                  .setLocale(_localeFor(value));
            },
            child: Column(
              children: [
                for (final option in _LanguageChoice.values)
                  RadioListTile<_LanguageChoice>(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                    value: option,
                    title: Text(_label(l10n, option)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
            ),
            title: Text(l10n.environment),
            subtitle: Text(flavorLabel),
          ),
        ],
      ),
    );
  }
}

_LanguageChoice _choiceFor(Locale? locale) {
  return switch (locale?.languageCode) {
    'en' => _LanguageChoice.english,
    'ar' => _LanguageChoice.arabic,
    'fr' => _LanguageChoice.french,
    _ => _LanguageChoice.system,
  };
}

Locale? _localeFor(_LanguageChoice choice) {
  return switch (choice) {
    _LanguageChoice.system => null,
    _LanguageChoice.english => const Locale('en'),
    _LanguageChoice.arabic => const Locale('ar'),
    _LanguageChoice.french => const Locale('fr'),
  };
}

String _label(AppLocalizations l10n, _LanguageChoice choice) {
  return switch (choice) {
    _LanguageChoice.system => l10n.languageSystem,
    _LanguageChoice.english => l10n.languageEnglish,
    _LanguageChoice.arabic => l10n.languageArabic,
    _LanguageChoice.french => l10n.languageFrench,
  };
}
