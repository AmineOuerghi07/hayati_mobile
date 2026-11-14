import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/core/widgets/growing_plant.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/features/achievements/domain/achievements.dart';
import 'package:hayati/features/achievements/presentation/achievement_providers.dart';
import 'package:hayati/features/achievements/presentation/achievement_style.dart';
import 'package:hayati/features/garden/domain/plant_stage.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class GardenPage extends ConsumerWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habits = ref.watch(activeHabitsProvider).value;
    final completions = ref.watch(allCompletionsProvider).value;
    final summary = ref.watch(achievementSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gardenTitle)),
      body: habits == null || completions == null
          ? const Center(child: CircularProgressIndicator())
          : _GardenBody(
              habits: habits,
              completions: completions,
              summary: summary,
              weekStart:
                  ref.watch(preferencesControllerProvider).value?.weekStart ??
                  AppPreferences.fallback.weekStart,
            ),
    );
  }
}

class _GardenBody extends StatelessWidget {
  const _GardenBody({
    required this.habits,
    required this.completions,
    required this.summary,
    required this.weekStart,
  });

  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final AchievementSummary? summary;
  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (habits.isEmpty) {
      return EmptyState(
        icon: Icons.yard_outlined,
        title: l10n.gardenTitle,
        body: l10n.gardenEmpty,
      );
    }
    final plants = _plants();
    return ResponsiveListView(
      side: 16,
      top: 8,
      bottom: 32,
      children: [
        _Meadow(plants: plants),
        const SizedBox(height: 16),
        for (final plant in plants) ...[
          _PlantRow(plant: plant),
          const SizedBox(height: 8),
        ],
        if (summary != null) ...[
          const SizedBox(height: 12),
          Text(l10n.rarePlants, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final achievement in summary!.achievements)
                _RarePlant(achievement: achievement),
            ],
          ),
        ],
      ],
    );
  }

  _Plant _plantFor(
    Habit habit,
    StreakCalculator calculator,
    CalendarDate today,
    int weekStart,
  ) {
    final logged = {
      for (final item in completions)
        if (item.habitId == habit.id) item.date: item.value,
    };
    final checkIns = logged.values
        .where((value) => value >= habit.targetValue)
        .length;
    final streak = calculator.calculate(
      habit: habit.schedule,
      completions: logged,
      today: today.iso,
      weekStart: weekStart,
    );
    return _Plant(
      habit: habit,
      stage: plantStage(checkIns: checkIns, bestStreak: streak.best),
    );
  }

  List<_Plant> _plants() {
    final today = CalendarDate.today();
    const calculator = StreakCalculator();
    return [
      for (final habit in habits)
        _plantFor(habit, calculator, today, weekStart),
    ];
  }
}

class _Plant {
  const _Plant({required this.habit, required this.stage});

  final Habit habit;
  final PlantStage stage;
}

class _Meadow extends StatefulWidget {
  const _Meadow({required this.plants});

  final List<_Plant> plants;

  @override
  State<_Meadow> createState() => _MeadowState();
}

class _MeadowState extends State<_Meadow> with SingleTickerProviderStateMixin {
  late final AnimationController _sway = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sway.stop();
    } else if (!_sway.isAnimating) {
      _sway.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _sway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final shown = widget.plants.take(6).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusCard),
      child: SizedBox(
        height: 210,
        child: AnimatedBuilder(
          animation: _sway,
          builder: (context, child) => CustomPaint(
            painter: _MeadowPainter(
              sway: _sway.value,
              ground: scheme.primaryContainer,
              grass: scheme.primary,
            ),
            child: child,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 24, 8, 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final plant in shown)
                  Expanded(
                    child: GrowingPlant(
                      progress: plantProgress(plant.stage),
                      size: 72,
                      semanticsLabel: plant.habit.name,
                      flowerColor: scheme.tertiary,
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

class _MeadowPainter extends CustomPainter {
  _MeadowPainter({
    required this.sway,
    required this.ground,
    required this.grass,
  });

  final double sway;
  final Color ground;
  final Color grass;

  @override
  void paint(Canvas canvas, Size size) {
    final hill = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * (0.42 + sway * 0.04),
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = ground);
    final blade = Paint()
      ..color = grass.withValues(alpha: 0.55)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 18; index++) {
      final x = (index + 0.5) * size.width / 18;
      final lean = math.sin(sway * math.pi + index) * 6;
      canvas.drawLine(
        Offset(x, size.height * 0.78),
        Offset(x + lean, size.height * 0.62),
        blade,
      );
    }
  }

  @override
  bool shouldRepaint(_MeadowPainter oldDelegate) => oldDelegate.sway != sway;
}

class _PlantRow extends StatelessWidget {
  const _PlantRow({required this.plant});

  final _Plant plant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        GrowingPlant(
          progress: plantProgress(plant.stage),
          size: 48,
          semanticsLabel: plant.habit.name,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.habit.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(stageLabel(l10n, plant.stage)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RarePlant extends StatelessWidget {
  const _RarePlant({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = achievementColor(achievement.id);
    final unlocked = achievement.unlocked;
    return Opacity(
      opacity: unlocked ? 1 : 0.4,
      child: SizedBox(
        width: 88,
        child: Column(
          children: [
            GrowingPlant(
              progress: unlocked ? 1 : 0.08,
              size: 64,
              semanticsLabel: achievementTitle(l10n, achievement.id),
              leafColor: color,
              flowerColor: color,
            ),
            const SizedBox(height: 4),
            Text(
              achievementTitle(l10n, achievement.id),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (!unlocked) const Icon(Icons.lock_outline_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}

String stageLabel(AppLocalizations l10n, PlantStage stage) => switch (stage) {
  PlantStage.seed => l10n.stageSeed,
  PlantStage.sprout => l10n.stageSprout,
  PlantStage.bud => l10n.stageBud,
  PlantStage.bloom => l10n.stageBloom,
  PlantStage.tree => l10n.stageTree,
};

/// A short row of plants for the profile card.
class GardenStrip extends ConsumerWidget {
  const GardenStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsProvider).value;
    final completions = ref.watch(allCompletionsProvider).value;
    if (habits == null || habits.isEmpty || completions == null) {
      return const SizedBox.shrink();
    }
    final weekStart =
        ref.watch(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;
    final today = CalendarDate.today();
    const calculator = StreakCalculator();
    final shown = habits.take(4);
    return Row(
      children: [
        for (final habit in shown)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: GrowingPlant(
              progress: plantProgress(
                plantStage(
                  checkIns: totalCheckIns(
                    habits: [habit],
                    completions: completions,
                  ),
                  bestStreak: calculator
                      .calculate(
                        habit: habit.schedule,
                        completions: {
                          for (final item in completions)
                            if (item.habitId == habit.id) item.date: item.value,
                        },
                        today: today.iso,
                        weekStart: weekStart,
                      )
                      .best,
                ),
              ),
              size: 44,
              semanticsLabel: habit.name,
            ),
          ),
      ],
    );
  }
}
