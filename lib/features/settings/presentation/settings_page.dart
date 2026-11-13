import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum _LanguageChoice { system, english, arabic, french }

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final preferences =
        ref.watch(preferencesControllerProvider).value ??
        AppPreferences.fallback;
    final choice = _choiceFor(preferences.localeCode);
    final config = ref.watch(appConfigProvider);
    final flavorLabel = config.isDev ? l10n.flavorDev : l10n.flavorProd;
    final controller = ref.read(preferencesControllerProvider.notifier);

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
              if (value == null) return;
              controller.setLocale(_localeFor(value));
            },
            child: Column(
              children: [
                for (final option in _LanguageChoice.values)
                  RadioListTile<_LanguageChoice>(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                    value: option,
                    title: Text(_languageLabel(l10n, option)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.appearance, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<Appearance>(
            groupValue: preferences.appearance,
            onChanged: (value) {
              if (value == null) return;
              controller.setAppearance(value);
            },
            child: Column(
              children: [
                for (final option in Appearance.values)
                  RadioListTile<Appearance>(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                    value: option,
                    title: Text(_appearanceLabel(l10n, option)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.colorTheme, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final preset in appThemes)
                _ThemeSwatch(
                  label: themeLabel(l10n, preset.id),
                  color: preset.seed,
                  selected: preferences.themeId == preset.id,
                  onTap: () => controller.setTheme(preset.id),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.weekStartsOn, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<int>(
            groupValue: _weekChoice(preferences.weekStart),
            onChanged: (value) {
              if (value == null) return;
              controller.setWeekStart(value);
            },
            child: Column(
              children: [
                for (final day in [
                  DateTime.monday,
                  DateTime.saturday,
                  DateTime.sunday,
                ])
                  RadioListTile<int>(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                    value: day,
                    title: Text(_weekLabel(l10n, day)),
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

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: color,
          shape: CircleBorder(
            side: BorderSide(
              color: selected ? outline : Colors.transparent,
              width: 3,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: const SizedBox.square(dimension: 48),
          ),
        ),
      ),
    );
  }
}

_LanguageChoice _choiceFor(String? localeCode) {
  return switch (localeCode) {
    'en' => _LanguageChoice.english,
    'ar' => _LanguageChoice.arabic,
    'fr' => _LanguageChoice.french,
    _ => _LanguageChoice.system,
  };
}

String? _localeFor(_LanguageChoice choice) {
  return switch (choice) {
    _LanguageChoice.system => null,
    _LanguageChoice.english => 'en',
    _LanguageChoice.arabic => 'ar',
    _LanguageChoice.french => 'fr',
  };
}

String _languageLabel(AppLocalizations l10n, _LanguageChoice choice) {
  return switch (choice) {
    _LanguageChoice.system => l10n.languageSystem,
    _LanguageChoice.english => l10n.languageEnglish,
    _LanguageChoice.arabic => l10n.languageArabic,
    _LanguageChoice.french => l10n.languageFrench,
  };
}

String _appearanceLabel(AppLocalizations l10n, Appearance appearance) {
  return switch (appearance) {
    Appearance.system => l10n.appearanceSystem,
    Appearance.light => l10n.appearanceLight,
    Appearance.dark => l10n.appearanceDark,
  };
}

int _weekChoice(int weekStart) {
  return switch (weekStart) {
    DateTime.saturday => DateTime.saturday,
    DateTime.sunday => DateTime.sunday,
    _ => DateTime.monday,
  };
}

String _weekLabel(AppLocalizations l10n, int day) {
  return switch (day) {
    DateTime.saturday => l10n.weekDaySaturday,
    DateTime.sunday => l10n.weekDaySunday,
    _ => l10n.weekDayMonday,
  };
}
