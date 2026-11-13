import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/onboarding/presentation/onboarding_gate.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/sync/presentation/sync_providers.dart';
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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
        children: [
          Text(l10n.profile, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          const _ProfileCard(),
          SectionHeader(l10n.appearance),
          SoftCard(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                  child: Text(l10n.language, style: theme.textTheme.titleSmall),
                ),
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
                          value: option,
                          title: Text(_languageLabel(l10n, option)),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                  child: Text(
                    l10n.appearance,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
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
                          value: option,
                          title: Text(_appearanceLabel(l10n, option)),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                  child: Text(
                    l10n.colorTheme,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                  ),
                  child: Wrap(
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
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                  child: Text(
                    l10n.weekStartsOn,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
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
                          value: day,
                          title: Text(_weekLabel(l10n, day)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SectionHeader(l10n.habits),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.archivedHabits),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => context.push('/archived'),
                ),
                ListTile(
                  title: Text(l10n.replayOnboarding),
                  onTap: () async {
                    ref.read(onboardingFlagProvider.notifier).markReplay();
                    await controller.setOnboardingDone(false);
                    if (!context.mounted) return;
                    context.go('/onboarding');
                  },
                ),
              ],
            ),
          ),
          SectionHeader(l10n.privacy),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.usageReports),
                  subtitle: Text(l10n.usageReportsBody),
                  value: preferences.analyticsEnabled,
                  onChanged: controller.setAnalyticsEnabled,
                ),
                ListTile(
                  title: Text(l10n.privacy),
                  subtitle: Text(l10n.privacyBody),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(l10n.privacy),
                          content: Text(l10n.privacyBody),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.cancel),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SectionHeader(l10n.sectionAbout),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.environment),
                  subtitle: Text(flavorLabel),
                ),
                ListTile(title: Text(l10n.versionLabel(hayatiVersion))),
                ListTile(
                  title: Text(l10n.licenses),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion: hayatiVersion,
                  ),
                ),
              ],
            ),
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
    final tokens = HayatiTokens.of(context);
    final outline = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: Column(
          children: [
            AnimatedContainer(
              duration: tokens.motion(context, tokens.motionFast),
              curve: tokens.easeOut,
              width: selected ? 52 : 48,
              height: selected ? 52 : 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? outline : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
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

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session =
        ref.watch(authSessionProvider).value ?? const AuthSession.guest();
    final user = session.user;
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      tint: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                child: Text(user?.initials ?? '?'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? l10n.onThisDevice,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      user?.email ?? user?.phone ?? l10n.guestStatus,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (user == null)
            FilledButton(
              onPressed: () => context.push('/auth/sign-in'),
              child: Text(l10n.signIn),
            )
          else ...[
            OutlinedButton(
              onPressed: () => context.push('/auth/change-password'),
              child: Text(l10n.changePassword),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(syncControllerProvider.notifier).syncNow(),
              child: Text(
                ref.watch(syncControllerProvider) == 'syncing'
                    ? l10n.syncing
                    : l10n.syncNow,
              ),
            ),
            TextButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: Text(l10n.signOut),
            ),
            TextButton(
              onPressed: () => _delete(context, ref),
              child: Text(l10n.deleteAccount),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final password = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteAccount),
          content: TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.password),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(authRepositoryProvider)
          .deleteAccount(password: password.text);
    } on AuthFailure {
      // The profile stays signed in when the password is wrong.
    }
    password.dispose();
  }
}
