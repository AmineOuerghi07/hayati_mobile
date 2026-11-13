import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/core/widgets/progress_ring.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const AsyncErrorView(),
      data: (habitList) {
        return completions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
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
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
        children: [
          Text(l10n.stats, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          if (habits.isEmpty)
            EmptyState(
              icon: Icons.insights_outlined,
              title: l10n.stats,
              body: l10n.noInsightsYet,
            ),
          _Hero(counts: todayCounts, rate: rates.today),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SmallRing(caption: l10n.thisWeek, rate: rates.week),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SmallRing(caption: l10n.thisMonth, rate: rates.month),
              ),
            ],
          ),
          if (habits.isNotEmpty) ...[
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
                  weekStart: weekStart,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.counts, required this.rate});

  final DayCounts counts;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = rate == null ? null : (rate! * 100).round();
    return SoftCard(
      child: Row(
        children: [
          ProgressRing(
            value: rate,
            centerLabel: percent == null
                ? l10n.noRate
                : l10n.percentValue(percent),
            semanticsLabel: percent == null
                ? l10n.ringEmpty(l10n.today)
                : l10n.ringSemantics(l10n.today, '$percent'),
            size: 112,
            strokeWidth: 10,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.today,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  counts.due == 0
                      ? l10n.noInsightsYet
                      : l10n.doneOfTotal(counts.done, counts.due),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallRing extends StatelessWidget {
  const _SmallRing({required this.caption, required this.rate});

  final String caption;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = rate == null ? null : (rate! * 100).round();
    return SoftCard(
      child: LabeledRing(
        caption: caption,
        value: rate,
        centerLabel: percent == null ? l10n.noRate : l10n.percentValue(percent),
        semanticsLabel: percent == null
            ? l10n.ringEmpty(caption)
            : l10n.ringSemantics(caption, '$percent'),
        size: 84,
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
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: reduce ? Duration.zero : const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) {
          return SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < days.length; index++)
                  Expanded(
                    child: _Bar(
                      rate: days[index].rate,
                      label: DateFormat.E(locale).format(
                        DateTime(
                          start.addDays(index).year,
                          start.addDays(index).month,
                          start.addDays(index).day,
                        ),
                      ),
                      growth: t,
                      color: scheme.primary,
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
    required this.label,
    required this.growth,
    required this.color,
    required this.track,
  });

  final double? rate;
  final String label;
  final double growth;
  final Color color;
  final Color track;

  @override
  Widget build(BuildContext context) {
    final height = 8 + ((rate ?? 0) * 72 * growth);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: Duration.zero,
            height: height,
            decoration: BoxDecoration(
              color: rate == null
                  ? track
                  : color.withValues(alpha: 0.35 + (rate! * 0.65)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 16,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: Theme.of(context).textTheme.labelSmall),
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
    required this.weekStart,
  });

  final Habit habit;
  final List<HabitCompletion> completions;
  final CalendarDate today;
  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final streak = const StreakCalculator().calculate(
      habit: habit.schedule,
      completions: {
        for (final item in completions)
          if (item.habitId == habit.id) item.date: item.value,
      },
      today: today.iso,
      weekStart: weekStart,
    );
    final rate = habitCompletionRate(
      habit: habit,
      completions: completions,
      today: today,
    );
    final percent = rate == null ? null : (rate * 100).round();
    final weeks = habit.frequencyType == FrequencyType.timesPerWeek;
    final color = habitColor(habit.colorKey);
    return SoftCard(
      onTap: () => context.push('/habits/${habit.id}'),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
      child: Row(
        children: [
          ProgressRing(
            value: rate,
            centerLabel: percent == null
                ? l10n.noRate
                : l10n.percentValue(percent),
            semanticsLabel: percent == null
                ? l10n.ringEmpty(habit.name)
                : l10n.ringSemantics(habit.name, '$percent'),
            size: 52,
            strokeWidth: 5,
            color: color,
          ),
          const SizedBox(width: 12),
          Icon(habitIcon(habit.icon), color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  weeks
                      ? l10n.streakWeeks(streak.current)
                      : l10n.streakDays(streak.current),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            weeks
                ? l10n.streakWeeks(streak.best)
                : l10n.streakDays(streak.best),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
