import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
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
            final rates = computeInsightRates(
              habits: habitList,
              completions: logged,
              today: today,
              weekStart: weekStart,
            );
            final levels = heatmapLevels(
              habits: habitList,
              completions: logged,
              today: today,
            );
            return _StatsBody(
              habits: habitList,
              completions: logged,
              rates: rates,
              levels: levels,
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
    required this.today,
    required this.weekStart,
  });

  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final InsightRates rates;
  final List<int> levels;
  final CalendarDate today;
  final int weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
        children: [
          Text(l10n.stats, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          if (habits.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(l10n.noInsightsYet),
            ),
          Row(
            children: [
              Expanded(
                child: _Ring(label: l10n.today, rate: rates.today),
              ),
              Expanded(
                child: _Ring(label: l10n.thisWeek, rate: rates.week),
              ),
              Expanded(
                child: _Ring(label: l10n.thisMonth, rate: rates.month),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l10n.heatmap, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _Heatmap(levels: levels),
          const SizedBox(height: 28),
          Text(l10n.habits, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final habit in habits)
            _HabitRate(
              habit: habit,
              completions: completions,
              today: today,
              weekStart: weekStart,
            ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.label, required this.rate});

  final String label;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = rate ?? 0;
    final percent = rate == null ? '—' : '${(rate! * 100).round()}%';
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              Text(percent, style: theme.textTheme.labelLarge),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.levels});

  final List<int> levels;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final cells = List<int>.generate(84, (index) {
      final column = index % 12;
      final row = index ~/ 12;
      return levels[column * 7 + row];
    });
    return GridView.count(
      crossAxisCount: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      children: [
        for (final level in cells)
          DecoratedBox(
            decoration: BoxDecoration(
              color: level == 0
                  ? color.withValues(alpha: 0.08)
                  : color.withValues(alpha: 0.2 + (level * 0.2)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
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
    final label = habit.frequencyType == FrequencyType.timesPerWeek
        ? l10n.streakWeeks(streak.current)
        : l10n.streakDays(streak.current);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(habitIcon(habit.icon), color: habitColor(habit.colorKey)),
      title: Text(habit.name),
      trailing: Text(label),
    );
  }
}
