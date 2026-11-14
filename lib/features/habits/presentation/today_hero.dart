import 'dart:math' as math;

import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/growing_plant.dart';
import 'package:hayati/core/widgets/streak_flame.dart';
import 'package:hayati/features/habits/domain/part_of_day.dart';
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
    required this.period,
    super.key,
  });

  final String greeting;
  final String dateLabel;
  final String quote;
  final DayCounts counts;
  final int bestStreak;
  final PartOfDay period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = HayatiTokens.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final rate = counts.rate ?? 0;
    final percent = (rate * 100).round();
    final sky = switch (period) {
      PartOfDay.morning => (
        base: const Color(0xFFFFF3E8),
        glows: [
          const Color(0xFFFFB74D).withValues(alpha: 0.55),
          scheme.primary.withValues(alpha: 0.2),
        ],
        on: const Color(0xFF4A2C1A),
      ),
      PartOfDay.afternoon => (
        base: scheme.primaryContainer,
        glows: [
          scheme.primary.withValues(alpha: 0.45),
          scheme.tertiaryContainer,
        ],
        on: scheme.onPrimaryContainer,
      ),
      PartOfDay.evening => (
        base: const Color(0xFF1E1B4B),
        glows: [
          const Color(0xFF4338CA).withValues(alpha: 0.45),
          const Color(0xFF0F172A).withValues(alpha: 0.35),
        ],
        on: Colors.white,
      ),
    };
    final onHero = sky.on;
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
        base: sky.base,
        colors: sky.glows,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 12, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _SkyMotif(period: period, color: onHero),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            dateLabel.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: onHero.withValues(alpha: 0.75),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
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

class _SkyMotif extends StatefulWidget {
  const _SkyMotif({required this.period, required this.color});

  final PartOfDay period;
  final Color color;

  @override
  State<_SkyMotif> createState() => _SkyMotifState();
}

class _SkyMotifState extends State<_SkyMotif>
    with SingleTickerProviderStateMixin {
  late final AnimationController _twinkle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _twinkle.stop();
    } else if (!_twinkle.isAnimating) {
      _twinkle.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: AnimatedBuilder(
        animation: _twinkle,
        builder: (context, _) => CustomPaint(
          painter: _SkyPainter(
            period: widget.period,
            color: widget.color,
            pulse: _twinkle.value,
          ),
        ),
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter({required this.period, required this.color, required this.pulse});

  final PartOfDay period;
  final Color color;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = size.center(Offset.zero);
    if (period == PartOfDay.evening) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width * 0.28),
        0.6,
        4.4,
        false,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      for (final star in const [Offset(4, 4), Offset(20, 6), Offset(16, 20)]) {
        canvas.drawCircle(
          star,
          1.2 + pulse,
          Paint()..color = color.withValues(alpha: 0.45 + pulse * 0.4),
        );
      }
      return;
    }
    canvas.drawCircle(
      center.translate(0, period == PartOfDay.morning ? 4 : 0),
      size.width * (period == PartOfDay.morning ? 0.22 : 0.28),
      paint,
    );
    if (period == PartOfDay.morning) {
      final ray = Paint()
        ..color = color
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      for (var index = 0; index < 6; index++) {
        final angle = index * 3.14159 / 3 - 0.6;
        final inner = Offset(math.cos(angle), math.sin(angle)) * 9;
        final outer =
            Offset(math.cos(angle), math.sin(angle)) * (12 + pulse * 2);
        canvas.drawLine(center + inner, center + outer, ray);
      }
    }
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => oldDelegate.pulse != pulse;
}
