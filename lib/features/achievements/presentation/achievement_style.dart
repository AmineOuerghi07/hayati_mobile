import 'dart:math' as math;

import 'package:hayati/features/achievements/domain/achievements.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

IconData achievementIcon(AchievementId id) {
  return switch (id) {
    AchievementId.firstStep => Icons.flag_rounded,
    AchievementId.streak3 => Icons.local_fire_department_rounded,
    AchievementId.streak7 => Icons.whatshot_rounded,
    AchievementId.streak30 => Icons.military_tech_rounded,
    AchievementId.perfectDay => Icons.wb_sunny_rounded,
    AchievementId.perfectWeek => Icons.auto_awesome_rounded,
    AchievementId.checkIns50 => Icons.task_alt_rounded,
    AchievementId.checkIns100 => Icons.workspace_premium_rounded,
    AchievementId.habitBuilder => Icons.construction_rounded,
    AchievementId.reflective => Icons.edit_note_rounded,
    AchievementId.earlyBird => Icons.wb_twilight_rounded,
    AchievementId.nightOwl => Icons.nightlight_round,
  };
}

Color achievementColor(AchievementId id) {
  return switch (id) {
    AchievementId.firstStep => const Color(0xFF10B981),
    AchievementId.streak3 => const Color(0xFFF97316),
    AchievementId.streak7 => const Color(0xFFEF4444),
    AchievementId.streak30 => const Color(0xFFB45309),
    AchievementId.perfectDay => const Color(0xFFF59E0B),
    AchievementId.perfectWeek => const Color(0xFF8B5CF6),
    AchievementId.checkIns50 => const Color(0xFF0EA5E9),
    AchievementId.checkIns100 => const Color(0xFF6366F1),
    AchievementId.habitBuilder => const Color(0xFF14B8A6),
    AchievementId.reflective => const Color(0xFFEC4899),
    AchievementId.earlyBird => const Color(0xFFFB923C),
    AchievementId.nightOwl => const Color(0xFF4338CA),
  };
}

String achievementTitle(AppLocalizations l10n, AchievementId id) {
  return switch (id) {
    AchievementId.firstStep => l10n.achFirstStep,
    AchievementId.streak3 => l10n.achStreak3,
    AchievementId.streak7 => l10n.achStreak7,
    AchievementId.streak30 => l10n.achStreak30,
    AchievementId.perfectDay => l10n.achPerfectDay,
    AchievementId.perfectWeek => l10n.achPerfectWeek,
    AchievementId.checkIns50 => l10n.achCheckIns50,
    AchievementId.checkIns100 => l10n.achCheckIns100,
    AchievementId.habitBuilder => l10n.achHabitBuilder,
    AchievementId.reflective => l10n.achReflective,
    AchievementId.earlyBird => l10n.achEarlyBird,
    AchievementId.nightOwl => l10n.achNightOwl,
  };
}

String achievementBody(AppLocalizations l10n, AchievementId id) {
  return switch (id) {
    AchievementId.firstStep => l10n.achFirstStepBody,
    AchievementId.streak3 => l10n.achStreakBody(3),
    AchievementId.streak7 => l10n.achStreakBody(7),
    AchievementId.streak30 => l10n.achStreakBody(30),
    AchievementId.perfectDay => l10n.achPerfectDayBody,
    AchievementId.perfectWeek => l10n.achPerfectWeekBody,
    AchievementId.checkIns50 => l10n.achCheckInsBody(50),
    AchievementId.checkIns100 => l10n.achCheckInsBody(100),
    AchievementId.habitBuilder => l10n.achHabitBuilderBody,
    AchievementId.reflective => l10n.achReflectiveBody,
    AchievementId.earlyBird => l10n.achEarlyBirdBody,
    AchievementId.nightOwl => l10n.achNightOwlBody,
  };
}

String levelName(AppLocalizations l10n, int level) {
  return switch (level) {
    1 => l10n.levelSeed,
    2 => l10n.levelSprout,
    3 || 4 => l10n.levelSapling,
    5 || 6 || 7 => l10n.levelBloom,
    8 || 9 || 10 || 11 => l10n.levelTree,
    _ => l10n.levelForest,
  };
}

/// A hexagon medal. Unlocked medals carry a slow shine, locked ones are
/// muted with a progress arc.
class AchievementMedal extends StatefulWidget {
  const AchievementMedal({
    required this.achievement,
    this.size = 72,
    super.key,
  });

  final Achievement achievement;
  final double size;

  @override
  State<AchievementMedal> createState() => _AchievementMedalState();
}

class _AchievementMedalState extends State<AchievementMedal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(AchievementMedal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final run =
        widget.achievement.unlocked && !MediaQuery.disableAnimationsOf(context);
    if (run && !_shine.isAnimating) {
      _shine.repeat();
    } else if (!run && _shine.isAnimating) {
      _shine.stop();
    }
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;
    final scheme = Theme.of(context).colorScheme;
    final color = achievementColor(achievement.id);
    final size = widget.size;
    final unlocked = achievement.unlocked;
    final light = HSLColor.fromColor(color);
    final top = light
        .withLightness((light.lightness + 0.15).clamp(0, 0.85))
        .toColor();
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!unlocked)
            CustomPaint(
              size: Size.square(size),
              painter: _ArcPainter(
                progress: achievement.progress,
                color: color,
                track: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ClipPath(
            clipper: _HexClipper(),
            child: SizedBox.square(
              dimension: size * (unlocked ? 1 : 0.78),
              child: AnimatedBuilder(
                animation: _shine,
                builder: (context, _) {
                  final x = _shine.value * 4 - 1.5;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: unlocked
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [top, color],
                            )
                          : null,
                      color: unlocked ? null : scheme.surfaceContainerHighest,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (unlocked)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(x - 0.4, -1),
                                end: Alignment(x + 0.4, 1),
                                colors: [
                                  Colors.white.withValues(alpha: 0),
                                  Colors.white.withValues(alpha: 0.35),
                                  Colors.white.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        Icon(
                          achievementIcon(achievement.id),
                          size: size * 0.38,
                          color: unlocked
                              ? Colors.white
                              : scheme.outline.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (!unlocked)
            PositionedDirectional(
              bottom: size * 0.04,
              end: size * 0.04,
              child: Container(
                padding: EdgeInsets.all(size * 0.04),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: size * 0.16,
                  color: scheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final path = Path();
    for (var index = 0; index < 6; index++) {
      final angle = math.pi / 3 * index - math.pi / 2;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldReclip(_HexClipper oldClipper) => false;
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.05;
    final arcRect = rect.deflate(stroke / 2);
    canvas.drawArc(
      arcRect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (progress <= 0) return;
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
