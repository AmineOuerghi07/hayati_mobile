import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/core/widgets/animated_count.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
import 'package:hayati/features/achievements/presentation/achievement_providers.dart';
import 'package:hayati/features/auth/presentation/name_sheet.dart';
import 'package:hayati/features/garden/presentation/garden_page.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/achievements/presentation/achievement_style.dart';
import 'package:hayati/features/achievements/presentation/achievements_page.dart';
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
      child: ResponsiveListView(
        side: 16,
        top: 16,
        bottom: 32,
        children: [
          Text(l10n.profile, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          const _ProfileCard(),
          SectionHeader(
            l10n.achievements,
            icon: Icons.emoji_events_outlined,
            trailing: TextButton(
              onPressed: () => context.push('/achievements'),
              child: Text(l10n.seeAll),
            ),
          ),
          const _AchievementStrip(),
          SectionHeader(l10n.tools, icon: Icons.self_improvement_rounded),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const _TileIcon(
                    Icons.yard_outlined,
                    Color(0xFF15803D),
                  ),
                  title: Text(l10n.gardenTitle),
                  subtitle: Text(l10n.gardenShort),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/garden'),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.menu_book_outlined,
                    Color(0xFF6D28D9),
                  ),
                  title: Text(l10n.journalTitle),
                  subtitle: Text(l10n.journalShort),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/journal'),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.air_rounded,
                    Color(0xFF0F766E),
                  ),
                  title: Text(l10n.breatheTitle),
                  subtitle: Text(l10n.breatheShort),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/breathe'),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.timer_outlined,
                    Color(0xFFEA580C),
                  ),
                  title: Text(l10n.focusTitle),
                  subtitle: Text(l10n.focusShort),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/focus'),
                ),
              ],
            ),
          ),
          SectionHeader(l10n.appearance, icon: Icons.palette_outlined),
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
                  child: SegmentedButton<Appearance>(
                    segments: [
                      for (final option in Appearance.values)
                        ButtonSegment(
                          value: option,
                          label: Text(_appearanceLabel(l10n, option)),
                        ),
                    ],
                    selected: {preferences.appearance},
                    onSelectionChanged: (values) {
                      controller.setAppearance(values.first);
                    },
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
          SectionHeader(l10n.habits, icon: Icons.checklist_rounded),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const _TileIcon(
                    Icons.inventory_2_outlined,
                    Color(0xFF64748B),
                  ),
                  title: Text(l10n.archivedHabits),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/archived'),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.replay_rounded,
                    Color(0xFF0EA5E9),
                  ),
                  title: Text(l10n.replayOnboarding),
                  trailing: const Icon(Icons.chevron_right_rounded),
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
          SectionHeader(l10n.privacy, icon: Icons.shield_outlined),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const _TileIcon(
                    Icons.analytics_outlined,
                    Color(0xFF8B5CF6),
                  ),
                  title: Text(l10n.usageReports),
                  subtitle: Text(l10n.usageReportsBody),
                  value: preferences.analyticsEnabled,
                  onChanged: controller.setAnalyticsEnabled,
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.privacy_tip_outlined,
                    Color(0xFF10B981),
                  ),
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
          SectionHeader(l10n.sectionAbout, icon: Icons.info_outline_rounded),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const _TileIcon(
                    Icons.developer_board_outlined,
                    Color(0xFFF59E0B),
                  ),
                  title: Text(l10n.environment),
                  subtitle: Text(flavorLabel),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.spa_outlined,
                    Color(0xFF14B8A6),
                  ),
                  title: Text(l10n.versionLabel(hayatiVersion)),
                ),
                ListTile(
                  leading: const _TileIcon(
                    Icons.description_outlined,
                    Color(0xFF6366F1),
                  ),
                  title: Text(l10n.licenses),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion: hayatiVersion,
                  ),
                ),
              ],
            ),
          ),
          const _DangerZone(),
        ],
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon(this.icon, this.color);

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _DangerZone extends ConsumerWidget {
  const _DangerZone();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(authSessionProvider).value?.user != null;
    if (!signedIn) return const SizedBox.shrink();
    final error = Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20),
      child: SoftCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          leading: _TileIcon(Icons.delete_outline_rounded, error),
          title: Text(l10n.deleteAccount, style: TextStyle(color: error)),
          onTap: () => _deleteAccount(context, ref),
        ),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = HayatiTokens.of(context);
    final session =
        ref.watch(authSessionProvider).value ?? const AuthSession.guest();
    final user = session.user;
    final shownName =
        preferredName(
          session,
          ref.watch(preferencesControllerProvider).value,
        ) ??
        l10n.onThisDevice;
    final summary = ref.watch(achievementSummaryProvider);
    final syncing = ref.watch(syncControllerProvider) == 'syncing';
    final onHero = scheme.onPrimaryContainer;
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSheet),
      child: AuroraBackground(
        base: scheme.primaryContainer,
        colors: [
          scheme.primary.withValues(alpha: 0.5),
          scheme.tertiaryContainer,
          scheme.secondary.withValues(alpha: 0.35),
        ],
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          scheme.primary,
                          scheme.tertiary,
                          scheme.primary,
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: tokens.cardTint,
                      foregroundColor: scheme.primary,
                      child: user == null
                          ? const Icon(Icons.person_rounded, size: 34)
                          : Text(
                              user.initials,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shownName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: onHero,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          user?.email ?? user?.phone ?? l10n.guestStatus,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onHero.withValues(alpha: 0.8),
                          ),
                        ),
                        if (summary != null) ...[
                          const SizedBox(height: 6),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: scheme.surface.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                8,
                                3,
                                10,
                                3,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    size: 16,
                                    color: scheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${l10n.levelLabel(summary.level.level)} · '
                                      '${levelName(l10n, summary.level.level)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.yourName,
                    onPressed: () => showNameSheet(context, ref),
                    icon: Icon(Icons.edit_outlined, color: onHero),
                  ),
                ],
              ),
              if (summary != null) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    _MiniStat(
                      icon: Icons.task_alt_rounded,
                      value: summary.checkIns,
                      label: l10n.checkIns,
                    ),
                    _MiniStat(
                      icon: Icons.local_fire_department_rounded,
                      value: summary.bestStreak,
                      label: l10n.bestStreak,
                    ),
                    _MiniStat(
                      icon: Icons.emoji_events_outlined,
                      value: summary.unlockedCount,
                      label: l10n.achievements,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push('/garden'),
                child: const GardenStrip(),
              ),
              const SizedBox(height: 18),
              if (user == null)
                FilledButton.icon(
                  onPressed: () => context.push('/auth/sign-in'),
                  icon: const Icon(Icons.login_rounded),
                  label: Text(l10n.signIn),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: syncing
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_rounded, size: 18),
                      label: Text(syncing ? l10n.syncing : l10n.syncNow),
                      onPressed: () =>
                          ref.read(syncControllerProvider.notifier).syncNow(),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.password_rounded, size: 18),
                      label: Text(l10n.changePassword),
                      onPressed: () => context.push('/auth/change-password'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(l10n.signOut),
                      onPressed: () =>
                          ref.read(authRepositoryProvider).signOut(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onHero = theme.colorScheme.onPrimaryContainer;
    return Expanded(
      child: Semantics(
        label: '$label: $value',
        excludeSemantics: true,
        child: Column(
          children: [
            Icon(icon, size: 20, color: onHero.withValues(alpha: 0.8)),
            const SizedBox(height: 2),
            AnimatedCount(
              value: value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: onHero,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: onHero.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementStrip extends ConsumerWidget {
  const _AchievementStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(achievementSummaryProvider);
    if (summary == null) return const SizedBox(height: 96);
    final sorted = [
      ...summary.achievements.where((item) => item.unlocked),
      ...summary.achievements.where((item) => !item.unlocked),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
        itemCount: sorted.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final achievement = sorted[index];
          return StaggeredItem(
            index: index,
            child: Tooltip(
              message: achievementTitle(
                AppLocalizations.of(context),
                achievement.id,
              ),
              child: InkResponse(
                radius: 44,
                onTap: () => showAchievementSheet(context, achievement),
                child: Hero(
                  tag: 'achievement-${achievement.id.name}',
                  child: AchievementMedal(achievement: achievement, size: 76),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final password = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded),
        title: Text(l10n.deleteAccount),
        content: TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.password,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
          ),
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
