import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({required this.habitId, super.key});

  final String habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habitAsync = ref.watch(habitByIdProvider(habitId));
    final completionsAsync = ref.watch(completionsForHabitProvider(habitId));
    final weekStart =
        ref.watch(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;

    return Scaffold(
      appBar: AppBar(
        title: Text(habitAsync.value?.name ?? l10n.loading),
        actions: [
          if (habitAsync.value != null)
            IconButton(
              tooltip: l10n.editHabit,
              onPressed: () => context.push('/habits/$habitId/edit'),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (habit) {
          if (habit == null) {
            return Center(child: Text(l10n.emptyTodayTitle));
          }
          final logged = completionsAsync.value ?? const [];
          final streak = const StreakCalculator().calculate(
            habit: habit.schedule,
            completions: {for (final item in logged) item.date: item.value},
            today: CalendarDate.today().iso,
            weekStart: weekStart,
          );
          final unit = habit.frequencyType == FrequencyType.timesPerWeek
              ? l10n.streakWeeks(streak.current)
              : l10n.streakDays(streak.current);
          final best = habit.frequencyType == FrequencyType.timesPerWeek
              ? l10n.streakWeeks(streak.best)
              : l10n.streakDays(streak.best);
          return ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StreakCard(title: l10n.currentStreak, value: unit),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StreakCard(title: l10n.bestStreak, value: best),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.history,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _HistoryGrid(
                habit: habit,
                completed: {for (final item in logged) item.date},
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () async {
                  final repository = ref.read(habitRepositoryProvider);
                  if (habit.isArchived) {
                    await repository.unarchive(habit.id);
                  } else {
                    await repository.archive(habit.id);
                  }
                },
                child: Text(habit.isArchived ? l10n.unarchive : l10n.archive),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _delete(context, ref, habit),
                child: Text(l10n.delete),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDelete(context, l10n);
    if (!confirmed) return;
    await ref.read(habitRepositoryProvider).softDelete(habit.id);
    if (!context.mounted) return;
    context.pop();
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _HistoryGrid extends StatelessWidget {
  const _HistoryGrid({required this.habit, required this.completed});

  final Habit habit;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final today = CalendarDate.today();
    final start = today.startOfWeek(DateTime.monday).addDays(-7 * 11);
    final color = habitColor(habit.colorKey);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var index = 0; index < 12 * 7; index++)
          _dayDot(start.addDays(index), today, color, context),
      ],
    );
  }

  Widget _dayDot(
    CalendarDate day,
    CalendarDate today,
    Color color,
    BuildContext context,
  ) {
    final done = completed.contains(day.iso);
    final future = day > today;
    return Tooltip(
      message: day.iso,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: done
              ? color
              : future
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context, AppLocalizations l10n) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(l10n.deleteHabitTitle),
          message: Text(l10n.deleteHabitMessage),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
        );
      },
    );
    return result ?? false;
  }
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.deleteHabitTitle),
        content: Text(l10n.deleteHabitMessage),
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
  return result ?? false;
}
