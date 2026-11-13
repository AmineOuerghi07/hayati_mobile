import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/growing_plant.dart';
import 'package:hayati/core/widgets/streak_flame.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class TodayHero extends StatelessWidget {
  const TodayHero({
    required this.greeting,
    required this.dateLabel,
    required this.quote,
    required this.counts,
    required this.bestStreak,
    super.key,
  });

  final String greeting;
  final String dateLabel;
  final String quote;
  final DayCounts counts;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = HayatiTokens.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final rate = counts.rate ?? 0;
    final percent = (rate * 100).round();
    final onHero = scheme.onPrimaryContainer;
    final mood = counts.due == 0
        ? quote
        : counts.done == counts.due
        ? l10n.allDoneTitle
        : counts.done == 0
        ? l10n.heroStart
        : l10n.heroProgress;

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSheet),
      child: AuroraBackground(
        base: scheme.primaryContainer,
        colors: [
          scheme.primary.withValues(alpha: 0.55),
          scheme.tertiaryContainer,
          scheme.secondary.withValues(alpha: 0.45),
        ],
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 12, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: onHero.withValues(alpha: 0.75),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      greeting,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: onHero,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: tokens.motion(context, tokens.motionMedium),
                      child: Text(
                        mood,
                        key: ValueKey(mood),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onHero.withValues(alpha: 0.85),
                          fontStyle: counts.due == 0
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                    if (counts.due > 0) ...[
                      const SizedBox(height: 14),
                      Semantics(
                        label: l10n.ringSemantics(l10n.today, '$percent'),
                        excludeSemantics: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 10,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColoredBox(
                                  color: onHero.withValues(alpha: 0.12),
                                ),
                                TweenAnimationBuilder<double>(
                                  tween: Tween(end: rate),
                                  duration: reduce
                                      ? Duration.zero
                                      : const Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, _) {
                                    return FractionallySizedBox(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      widthFactor: value.clamp(0, 1),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              scheme.primary,
                                              scheme.tertiary,
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              l10n.doneOfTotal(counts.done, counts.due),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: onHero,
                              ),
                            ),
                          ),
                          if (bestStreak > 0) ...[
                            const SizedBox(width: 10),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.surface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  6,
                                  2,
                                  10,
                                  2,
                                ),
                                child: StreakChip(
                                  count: bestStreak,
                                  label: l10n.streakMilestone(bestStreak),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GrowingPlant(
                progress: counts.due == 0 ? 0.15 : rate,
                size: 104,
                semanticsLabel: l10n.plantGrowth(percent),
                leafColor: Color.lerp(
                  const Color(0xFF2F9E6E),
                  scheme.primary,
                  0.25,
                ),
                flowerColor: scheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
