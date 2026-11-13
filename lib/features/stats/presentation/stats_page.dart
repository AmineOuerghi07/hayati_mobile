import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/animated_count.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/concentric_rings.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
import 'package:hayati/core/widgets/streak_flame.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/skeleton.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/features/habits/presentation/note_sheet.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsProvider);
    final completions = ref.watch(allCompletionsProvider);
    final weekStart =
        ref.watch(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;

    return habits.when(
      loading: () => const SkeletonList(),
      error: (error, stack) => const AsyncErrorView(),
      data: (habitList) {
        return completions.when(
          loading: () => const SkeletonList(),
          error: (error, stack) => const AsyncErrorView(),
          data: (logged) {
            final today = CalendarDate.today();
            return _StatsBody(
              habits: habitList,
              completions: logged,
              rates: computeInsightRates(
                habits: habitList,
                completions: logged,
                today: today,
                weekStart: weekStart,
              ),
              levels: heatmapLevels(
                habits: habitList,
                completions: logged,
                today: today,
              ),
              days: recentDayCounts(
                habits: habitList,
                completions: logged,
                today: today,
              ),
              today: today,
              weekStart: weekStart,
            );
          },
        );
      },
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({
    required this.habits,
    required this.completions,
    required this.rates,
    required this.levels,
    required this.days,
    required this.today,
    required this.weekStart,
  });

  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final InsightRates rates;
  final List<int> levels;
  final List<DayCounts> days;
  final CalendarDate today;
  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final todayCounts = dayCounts(
      habits: habits,
      completions: completions,
      day: today,
    );
    final streaks = {
      for (final habit in habits)
        habit.id: const StreakCalculator().calculate(
          habit: habit.schedule,
          completions: {
            for (final item in completions)
              if (item.habitId == habit.id) item.date: item.value,
          },
          today: today.iso,
          weekStart: weekStart,
        ),
    };
    final bestStreak = streaks.values.fold(
      0,
      (best, streak) => streak.best > best ? streak.best : best,
    );
    final weekAgo = today.addDays(-6).iso;
    final mood = averageMood([
      for (final item in completions)
        if (item.date.compareTo(weekAgo) >= 0)
          ?CompletionNote.decode(item.note).mood,
    ]);
    final sections = <Widget>[
      _RingsHero(counts: todayCounts, rates: rates),
      if (habits.isEmpty)
        EmptyState(
          icon: Icons.insights_outlined,
          title: l10n.stats,
          body: l10n.noInsightsYet,
        ),
      if (habits.isNotEmpty) ...[
        const SizedBox(height: 12),
        _SummaryGrid(
          perfect: perfectDays(
            habits: habits,
            completions: completions,
            today: today,
          ),
          checkIns: totalCheckIns(habits: habits, completions: completions),
          bestStreak: bestStreak,
          mood: mood,
        ),
        SectionHeader(l10n.lastSevenDays),
        _WeekBars(days: days, today: today),
        SectionHeader(l10n.heatmap),
        _Heatmap(levels: levels, today: today),
        SectionHeader(l10n.habits),
        for (final habit in habits)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: _HabitRate(
              habit: habit,
              completions: completions,
              today: today,
              streak: streaks[habit.id]!,
            ),
          ),
      ],
    ];
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 32),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            child: Text(l10n.stats, style: theme.textTheme.headlineMedium),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < sections.length; index++)
            StaggeredItem(index: index, child: sections[index]),
        ],
      ),
    );
  }
}

class _RingsHero extends StatelessWidget {
  const _RingsHero({required this.counts, required this.rates});

  final DayCounts counts;
  final InsightRates rates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final rings = [
      (l10n.today, rates.today, scheme.primary),
      (l10n.thisWeek, rates.week, scheme.tertiary),
      (l10n.thisMonth, rates.month, const Color(0xFFF59E0B)),
    ];
    final todayPercent = rates.today == null
        ? null
        : (rates.today! * 100).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSheet),
      child: AuroraBackground(
        base: tokens.cardTint,
        colors: [
          scheme.primary.withValues(alpha: 0.18),
          scheme.tertiary.withValues(alpha: 0.14),
        ],
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Row(
            children: [
              ConcentricRings(
                size: 136,
                strokeWidth: 13,
                semanticsLabel: [
                  for (final (label, rate, _) in rings)
                    rate == null
                        ? l10n.ringEmpty(label)
                        : l10n.ringSemantics(label, '${(rate * 100).round()}'),
                ].join(', '),
                rings: [
                  for (final (_, rate, color) in rings)
                    RingValue(value: rate, color: color),
                ],
                center: todayPercent == null
                    ? Icon(Icons.spa_outlined, color: scheme.primary)
                    : Text(
                        l10n.percentValue(todayPercent),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (label, rate, color) in rings)
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 6,
                        ),
                        child: _Legend(label: label, rate: rate, color: color),
                      ),
                    if (counts.due > 0)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 4),
                        child: Text(
                          l10n.doneOfTotal(counts.done, counts.due),
                          style: Theme.of(context).textTheme.bodySmall,
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

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.rate, required this.color});

  final String label;
  final double? rate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        if (rate == null)
          Text(l10n.noRate, style: theme.textTheme.titleSmall)
        else
          AnimatedCount(
            value: (rate! * 100).round(),
            suffix: '%',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.perfect,
    required this.checkIns,
    required this.bestStreak,
    required this.mood,
  });

  final int perfect;
  final int checkIns;
  final int bestStreak;
  final double? mood;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final roundedMood = mood?.round();
    final tiles = [
      _Tile(
        icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF8B5CF6)),
        tint: const Color(0xFF8B5CF6),
        value: AnimatedCount(value: perfect, style: _valueStyle(context)),
        label: l10n.perfectDays,
      ),
      _Tile(
        icon: const Icon(Icons.task_alt_rounded, color: Color(0xFF0EA5E9)),
        tint: const Color(0xFF0EA5E9),
        value: AnimatedCount(value: checkIns, style: _valueStyle(context)),
        label: l10n.checkIns,
      ),
      _Tile(
        icon: StreakFlame(active: bestStreak > 0, size: 24),
        tint: const Color(0xFFFF8A00),
        value: AnimatedCount(value: bestStreak, style: _valueStyle(context)),
        label: l10n.bestStreak,
      ),
      _Tile(
        icon: Icon(
          roundedMood == null
              ? Icons.sentiment_neutral_outlined
              : moodIconFor(roundedMood),
          color: const Color(0xFFEC4899),
        ),
        tint: const Color(0xFFEC4899),
        value: Text(
          roundedMood == null ? l10n.noRate : moodLabel(l10n, roundedMood),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _valueStyle(context),
        ),
        label: l10n.moodThisWeek,
      ),
    ];
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tiles[row * 2]),
                const SizedBox(width: 12),
                Expanded(child: tiles[row * 2 + 1]),
              ],
            ),
          ),
        ],
      ],
    );
  }

  TextStyle? _valueStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall
        ?.copyWith(fontWeight: FontWeight.w700);
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.tint,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final Color tint;
  final Widget value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    return SoftCard(
      tint: Color.alphaBlend(tint.withValues(alpha: 0.08), tokens.cardTint),
      padding: const EdgeInsetsDirectional.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: icon,
            ),
          ),
          const SizedBox(height: 10),
          value,
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.days, required this.today});

  final List<DayCounts> days;
  final CalendarDate today;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final start = today.addDays(1 - days.length);
    return SoftCard(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 12),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduce ? 1 : 0, end: 1),
        duration: reduce ? Duration.zero : const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) {
          return SizedBox(
            height: 156,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < days.length; index++)
                  Expanded(
                    child: _Bar(
                      rate: days[index].rate,
                      isToday: index == days.length - 1,
                      label: DateFormat.E(locale).format(
                        DateTime(
                          start.addDays(index).year,
                          start.addDays(index).month,
                          start.addDays(index).day,
                        ),
                      ),
                      growth: ((t * 1.3) - index * 0.05).clamp(0.0, 1.0),
                      color: scheme.primary,
                      accent: scheme.tertiary,
                      track: scheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.rate,
    required this.isToday,
    required this.label,
    required this.growth,
    required this.color,
    required this.accent,
    required this.track,
  });

  final double? rate;
  final bool isToday;
  final String label;
  final double growth;
  final Color color;
  final Color accent;
  final Color track;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final value = rate ?? 0;
    const maxBar = 96.0;
    final height = 6 + value * maxBar * Curves.easeOutBack.transform(growth);
    final full = value >= 1;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 16,
            child: Opacity(
              opacity: growth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: full
                    ? Icon(Icons.star_rounded, size: 16, color: accent)
                    : Text(
                        rate == null
                            ? ''
                            : l10n.percentValue((value * 100).round()),
                        style: theme.textTheme.labelSmall,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: maxBar + 6,
                decoration: BoxDecoration(
                  color: track.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: height.clamp(0.0, maxBar + 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: rate == null
                      ? null
                      : LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [color, Color.lerp(color, accent, 0.7)!],
                        ),
                  boxShadow: isToday && rate != null
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  color: isToday ? color : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.levels, required this.today});

  final List<int> levels;
  final CalendarDate today;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final color = Theme.of(context).colorScheme.primary;
    final locale = Localizations.localeOf(context).toString();
    final start = today.addDays(-83);
    return SoftCard(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduce ? 1 : 0, end: 1),
        duration: reduce ? Duration.zero : const Duration(milliseconds: 500),
        builder: (context, t, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              const labelWidth = 28.0;
              const gap = 3.0;
              final grid = constraints.maxWidth - labelWidth;
              final cell = (grid - gap * 11) / 12;
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: labelWidth),
                      for (var column = 0; column < 12; column++)
                        SizedBox(
                          width: cell,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: gap),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _monthLabel(start, column, locale),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  for (var row = 0; row < 7; row++)
                    SizedBox(
                      height: cell,
                      child: Row(
                        children: [
                          SizedBox(
                            width: labelWidth,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                DateFormat.E(locale).format(
                                  DateTime(
                                    start.addDays(row).year,
                                    start.addDays(row).month,
                                    start.addDays(row).day,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                          for (var column = 0; column < 12; column++)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: gap,
                                bottom: gap,
                              ),
                              child: Opacity(
                                opacity: ((t * 1.4) - column * 0.04).clamp(
                                  0.15,
                                  1,
                                ),
                                child: _cell(
                                  color,
                                  levels[column * 7 + row],
                                  cell - gap,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _monthLabel(CalendarDate start, int column, String locale) {
    final day = start.addDays(column * 7);
    if (column > 0) {
      final previous = start.addDays((column - 1) * 7);
      if (previous.month == day.month) return '';
    }
    return DateFormat.MMM(locale)
        .format(DateTime(day.year, day.month, day.day));
  }

  Widget _cell(Color color, int level, double size) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: level == 0
              ? color.withValues(alpha: 0.08)
              : color.withValues(alpha: 0.2 + (level * 0.2)),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _HabitRate extends StatelessWidget {
  const _HabitRate({
    required this.habit,
    required this.completions,
    required this.today,
    required this.streak,
  });

  final Habit habit;
  final List<HabitCompletion> completions;
  final CalendarDate today;
  final Streak streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rate = habitCompletionRate(
      habit: habit,
      completions: completions,
      today: today,
    );
    final percent = rate == null ? null : (rate * 100).round();
    final weeks = habit.frequencyType == FrequencyType.timesPerWeek;
    final color = habitColor(habit.colorKey);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return SoftCard(
      onTap: () => context.push('/habits/${habit.id}'),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 16, 12),
      child: Row(
        children: [
          HabitBadge(icon: habit.icon, colorKey: habit.colorKey, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        habit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    StreakChip(
                      count: streak.current,
                      label: weeks
                          ? l10n.streakWeeks(streak.current)
                          : l10n.streakDays(streak.current),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: percent == null
                      ? l10n.ringEmpty(habit.name)
                      : l10n.ringSemantics(habit.name, '$percent'),
                  excludeSemantics: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 8,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: color.withValues(alpha: 0.12)),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: rate ?? 0),
                            duration: reduce
                                ? Duration.zero
                                : const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) {
                              return FractionallySizedBox(
                                alignment: AlignmentDirectional.centerStart,
                                widthFactor: value.clamp(0, 1),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: habitGradient(color),
                                    borderRadius: BorderRadius.circular(6),
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n.bestStreak}: ${weeks ? l10n.streakWeeks(streak.best) : l10n.streakDays(streak.best)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      percent == null
                          ? l10n.noRate
                          : l10n.percentValue(percent),
                      style: theme.textTheme.labelLarge?.copyWith(color: color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
