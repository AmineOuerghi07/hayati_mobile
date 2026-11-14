import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/skeleton.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
import 'package:hayati/features/achievements/domain/achievements.dart';
import 'package:hayati/features/achievements/presentation/achievement_providers.dart';
import 'package:hayati/features/achievements/presentation/achievement_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(achievementSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievements)),
      body: summary == null
          ? const SkeletonList()
          : ResponsiveListView(
              maxWidth: 960,
              side: 16,
              top: 8,
              bottom: 32,
              children: [
                LevelCard(summary: summary),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: Text(
                    l10n.unlockedOf(
                      summary.unlockedCount,
                      summary.achievements.length,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: summary.achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = summary.achievements[index];
                    return StaggeredItem(
                      index: index,
                      child: _AchievementTile(achievement: achievement),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final title = achievementTitle(l10n, achievement.id);
    return Semantics(
      button: true,
      label: achievement.unlocked
          ? l10n.achievementUnlocked(title)
          : l10n.achievementLocked(
              title,
              achievement.current,
              achievement.target,
            ),
      excludeSemantics: true,
      child: Material(
        color: tokens.cardTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
          side: BorderSide(
            color: achievement.unlocked
                ? achievementColor(achievement.id).withValues(alpha: 0.4)
                : Theme.of(context).colorScheme.outlineVariant
                      .withValues(alpha: 0.45),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
          onTap: () => showAchievementSheet(context, achievement),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Column(
              children: [
                Hero(
                  tag: 'achievement-${achievement.id.name}',
                  child: AchievementMedal(achievement: achievement, size: 64),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showAchievementSheet(
  BuildContext context,
  Achievement achievement,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final theme = Theme.of(context);
      final color = achievementColor(achievement.id);
      final reduce = MediaQuery.disableAnimationsOf(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: reduce ? 1 : 0, end: 1),
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (context, t, child) =>
                    Transform.scale(scale: 0.6 + 0.4 * t, child: child),
                child: AchievementMedal(achievement: achievement, size: 112),
              ),
              const SizedBox(height: 16),
              Text(
                achievementTitle(l10n, achievement.id),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                achievementBody(l10n, achievement.id),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              if (achievement.unlocked)
                Chip(
                  avatar: Icon(Icons.check_circle_rounded, color: color),
                  label: Text(l10n.unlocked),
                )
              else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: achievement.progress,
                    minHeight: 10,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.progressOf(achievement.current, achievement.target),
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

/// Level, a name for it, and the XP bar toward the next one.
class LevelCard extends StatelessWidget {
  const LevelCard({required this.summary, super.key});

  final AchievementSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = HayatiTokens.of(context);
    final level = summary.level;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final onHero = scheme.onPrimaryContainer;
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSheet),
      child: AuroraBackground(
        base: scheme.primaryContainer,
        colors: [
          scheme.primary.withValues(alpha: 0.5),
          scheme.tertiaryContainer,
        ],
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.tertiary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  '${level.level}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.levelLabel(level.level),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: onHero.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      levelName(l10n, level.level),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: onHero,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 10,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(color: onHero.withValues(alpha: 0.12)),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: level.progress),
                              duration: reduce
                                  ? Duration.zero
                                  : const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) =>
                                  FractionallySizedBox(
                                    alignment: AlignmentDirectional.centerStart,
                                    widthFactor: value.clamp(0, 1),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            scheme.primary,
                                            scheme.tertiary,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.xpProgress(level.intoLevel, level.levelSpan),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: onHero.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
