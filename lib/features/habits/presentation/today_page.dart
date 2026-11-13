import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_due.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habits = ref.watch(activeHabitsProvider);
    final completions = ref.watch(allCompletionsProvider);
    final today = CalendarDate.today();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addHabit,
        onPressed: () => context.push('/habits/new'),
        child: const Icon(Icons.add),
      ),
      body: habits.when(
        loading: () => const Center(
          key: Key('today-loading'),
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => const AsyncErrorView(),
        data: (habitList) {
          return completions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const AsyncErrorView(),
            data: (logged) {
              final due = [
                for (final habit in habitList)
                  if (isHabitDueOn(habit, today)) habit,
              ];
              if (due.isEmpty) {
                return _EmptyToday(onAdd: () => context.push('/habits/new'));
              }
              final done = {
                for (final item in logged)
                  if (item.date == today.iso) item.habitId: item,
              };
              return _TodayList(
                habits: habitList,
                due: due,
                done: done,
                logged: logged,
                today: today,
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.today, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Text(
              l10n.emptyTodayTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.emptyTodayBody),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAdd, child: Text(l10n.addHabit)),
          ],
        ),
      ),
    );
  }
}

class _TodayList extends ConsumerWidget {
  const _TodayList({
    required this.habits,
    required this.due,
    required this.done,
    required this.logged,
    required this.today,
  });

  final List<Habit> habits;
  final List<Habit> due;
  final Map<String, HabitCompletion> done;
  final List<HabitCompletion> logged;
  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 88),
        child: ReorderableListView.builder(
          padding: EdgeInsets.zero,
          header: Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 16),
            child: Text(
              l10n.today,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          itemCount: due.length,
          onReorderItem: (oldIndex, newIndex) {
            final nextDue = [...due];
            final moved = nextDue.removeAt(oldIndex);
            nextDue.insert(newIndex, moved);
            final dueIds = nextDue.map((habit) => habit.id).toList();
            final dueSet = dueIds.toSet();
            final queue = List.of(dueIds);
            final ordered = [
              for (final habit in habits)
                if (dueSet.contains(habit.id)) queue.removeAt(0) else habit.id,
            ];
            ref.read(habitRepositoryProvider).reorder(ordered);
          },
          itemBuilder: (context, index) {
            final habit = due[index];
            final complete = done.containsKey(habit.id);
            return _HabitTile(
              key: ValueKey(habit.id),
              habit: habit,
              complete: complete,
              onOpen: () => context.push('/habits/${habit.id}'),
              onToggle: () => _toggle(context, ref, habit, complete),
            );
          },
        ),
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    bool complete,
  ) async {
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(completionRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (complete) {
      await repository.clear(habitId: habit.id, date: today.iso);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.clearedForToday),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () {
              repository.setValue(
                habitId: habit.id,
                date: today.iso,
                value: habit.targetValue,
              );
            },
          ),
        ),
      );
      return;
    }
    await repository.setValue(
      habitId: habit.id,
      date: today.iso,
      value: habit.targetValue,
    );
    if (!context.mounted) return;
    final milestone = _milestoneFor(ref, habit);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          milestone == null ? l10n.markedDone : l10n.streakMilestone(milestone),
        ),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => repository.clear(habitId: habit.id, date: today.iso),
        ),
      ),
    );
  }

  int? _milestoneFor(WidgetRef ref, Habit habit) {
    final weekStart =
        ref.read(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;
    final map = {
      for (final item in logged)
        if (item.habitId == habit.id) item.date: item.value,
    };
    const calculator = StreakCalculator();
    final before = calculator
        .calculate(
          habit: habit.schedule,
          completions: map,
          today: today.iso,
          weekStart: weekStart,
        )
        .current;
    map[today.iso] = habit.targetValue;
    final after = calculator
        .calculate(
          habit: habit.schedule,
          completions: map,
          today: today.iso,
          weekStart: weekStart,
        )
        .current;
    return crossedMilestone(before, after);
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required super.key,
    required this.habit,
    required this.complete,
    required this.onOpen,
    required this.onToggle,
  });

  final Habit habit;
  final bool complete;
  final VoidCallback onOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = habitColor(habit.colorKey);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
            child: Row(
              children: [
                Icon(habitIcon(habit.icon), color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    habit.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: habit.name,
                  onPressed: onToggle,
                  icon: AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: complete ? 1 : 0.92,
                    child: Icon(
                      complete ? Icons.check_circle : Icons.circle_outlined,
                      color: complete
                          ? color
                          : Theme.of(context).colorScheme.outline,
                      size: 32,
                    ),
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
