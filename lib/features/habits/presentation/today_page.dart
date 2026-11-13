import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/celebration_overlay.dart';
import 'package:hayati/core/widgets/confirm_sheet.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/core/widgets/progress_ring.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_due.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/habits/presentation/habit_card.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/note_sheet.dart';
import 'package:hayati/features/habits/presentation/selected_date.dart';
import 'package:hayati/features/habits/presentation/template_sheet.dart';
import 'package:hayati/features/habits/presentation/week_strip_bar.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  var _fabExtended = true;
  var _armed = false;
  String? _burst;
  Timer? _burstTimer;

  @override
  void dispose() {
    _burstTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final habits = ref.watch(activeHabitsProvider);
    final completions = ref.watch(allCompletionsProvider);
    final selected = ref.watch(selectedDateProvider);
    final today = CalendarDate.today();

    return Scaffold(
      floatingActionButton: habits.maybeWhen(
        data: (habitList) {
          if (habitList.isEmpty) {
            return FloatingActionButton(
              tooltip: l10n.addHabit,
              onPressed: () => context.push('/habits/new'),
              child: const Icon(Icons.add),
            );
          }
          return FloatingActionButton.extended(
            isExtended: _fabExtended,
            onPressed: () => context.push('/habits/new'),
            icon: const Icon(Icons.add),
            label: Text(l10n.addHabit),
          );
        },
        orElse: () => null,
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
              if (habitList.isEmpty) {
                return _FirstRun(onAdd: () => context.push('/habits/new'));
              }
              final due = [
                for (final habit in habitList)
                  if (isHabitDueOn(habit, selected)) habit,
              ];
              final done = {
                for (final item in logged)
                  if (item.date == selected.iso) item.habitId: item,
              };
              _watchCelebration(due, done, selected, today, l10n);
              return Stack(
                children: [
                  _TodayList(
                    habits: habitList,
                    due: due,
                    done: done,
                    logged: logged,
                    selected: selected,
                    today: today,
                    onScroll: (extended) {
                      if (extended == _fabExtended) return;
                      setState(() => _fabExtended = extended);
                    },
                    onBurst: _showBurst,
                  ),
                  if (_burst != null)
                    Positioned.fill(
                      child: CelebrationOverlay(message: _burst!),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _watchCelebration(
    List<Habit> due,
    Map<String, HabitCompletion> done,
    CalendarDate selected,
    CalendarDate today,
    AppLocalizations l10n,
  ) {
    final allDone =
        due.isNotEmpty &&
        due.every(
          (habit) => meetsTarget(done[habit.id]?.value ?? 0, habit.targetValue),
        );
    final watchingToday = selected == today;
    if (!allDone || !watchingToday) {
      _armed = true;
      return;
    }
    if (!_armed) return;
    _armed = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!ref.read(celebratedDaysProvider.notifier).claim(today.iso)) return;
      _showBurst(l10n.allDoneTitle);
      playHaptic(strong: true);
    });
  }

  void _showBurst(String message) {
    _burstTimer?.cancel();
    setState(() => _burst = message);
    _burstTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted && _burst == message) setState(() => _burst = null);
    });
  }
}

class _FirstRun extends ConsumerWidget {
  const _FirstRun({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 0),
            child: Text(
              greetingFor(l10n, DateTime.now()),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: Center(
              child: EmptyState(
                icon: Icons.spa_outlined,
                title: l10n.emptyTodayTitle,
                body: l10n.emptyTodayBody,
                actionLabel: l10n.addHabit,
                onAction: onAdd,
                secondaryLabel: l10n.browseTemplates,
                onSecondary: () => showTemplateSheet(context, ref),
              ),
            ),
          ),
        ],
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
    required this.selected,
    required this.today,
    required this.onScroll,
    required this.onBurst,
  });

  final List<Habit> habits;
  final List<Habit> due;
  final Map<String, HabitCompletion> done;
  final List<HabitCompletion> logged;
  final CalendarDate selected;
  final CalendarDate today;
  final ValueChanged<bool> onScroll;
  final ValueChanged<String> onBurst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final weekStart =
        ref.watch(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;
    final counts = dayCounts(
      habits: habits,
      completions: logged,
      day: selected,
    );
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.yMMMEd(locale)
        .format(DateTime(selected.year, selected.month, selected.day));
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
            child: _Header(
              greeting: greetingFor(l10n, DateTime.now()),
              dateLabel: dateLabel,
              counts: counts,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: l10n.previousWeek,
                  onPressed: () => ref
                      .read(selectedDateProvider.notifier)
                      .select(selected.addDays(-7)),
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: WeekStripBar(
                    selected: selected,
                    today: today,
                    weekStart: weekStart,
                    habits: habits,
                    completions: logged,
                    onSelect: (day) =>
                        ref.read(selectedDateProvider.notifier).select(day),
                  ),
                ),
                IconButton(
                  tooltip: l10n.nextWeek,
                  onPressed:
                      selected.startOfWeek(weekStart) ==
                          today.startOfWeek(weekStart)
                      ? null
                      : () {
                          final forward = selected.addDays(7);
                          ref
                              .read(selectedDateProvider.notifier)
                              .select(forward > today ? today : forward);
                        },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          if (selected != today)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: SoftCard(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.backfillBanner(dateLabel)),
                          Text(
                            l10n.loggingPastBody,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ref.read(selectedDateProvider.notifier).jumpToToday(),
                      child: Text(l10n.backToToday),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  onScroll(notification.metrics.pixels < 24);
                }
                return false;
              },
              child: due.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.all(24),
                          child: Text(
                            selected == today
                                ? l10n.emptyTodayTitle
                                : l10n.nothingDueOnDay,
                          ),
                        ),
                      ],
                    )
                  : ReorderableListView.builder(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        4,
                        16,
                        96,
                      ).resolve(Directionality.of(context)),
                      buildDefaultDragHandles: false,
                      itemCount: due.length,
                      onReorderItem: (oldIndex, newIndex) {
                        final nextDue = [...due];
                        final moved = nextDue.removeAt(oldIndex);
                        nextDue.insert(newIndex, moved);
                        final dueIds = nextDue
                            .map((habit) => habit.id)
                            .toList();
                        final dueSet = dueIds.toSet();
                        final queue = List.of(dueIds);
                        final ordered = [
                          for (final habit in habits)
                            if (dueSet.contains(habit.id))
                              queue.removeAt(0)
                            else
                              habit.id,
                        ];
                        ref.read(habitRepositoryProvider).reorder(ordered);
                      },
                      itemBuilder: (context, index) {
                        final habit = due[index];
                        final loggedValue = done[habit.id]?.value ?? 0;
                        return StaggeredItem(
                          key: ValueKey(habit.id),
                          index: index,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              bottom: 8,
                            ),
                            child: HabitCard(
                              index: index,
                              habit: habit,
                              value: loggedValue,
                              onOpen: () => context.push('/habits/${habit.id}'),
                              onToggle: () => _toggle(
                                context,
                                ref,
                                habit,
                                meetsTarget(loggedValue, habit.targetValue),
                              ),
                              onStep: (delta) => _step(
                                context,
                                ref,
                                habit,
                                loggedValue,
                                delta,
                              ),
                              onNote: () => _note(context, ref, habit),
                              onEdit: () =>
                                  context.push('/habits/${habit.id}/edit'),
                              onArchive: () => _archive(context, ref, habit),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
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
    final note = done[habit.id]?.note;
    if (complete) {
      await repository.clear(habitId: habit.id, date: selected.iso);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            selected == today ? l10n.clearedForToday : l10n.cleared,
          ),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: () {
              repository.setValue(
                habitId: habit.id,
                date: selected.iso,
                value: habit.targetValue,
                note: note,
              );
            },
          ),
        ),
      );
      return;
    }
    await repository.setValue(
      habitId: habit.id,
      date: selected.iso,
      value: habit.targetValue,
      note: note,
    );
    if (!context.mounted) return;
    playHaptic();
    final milestone = _milestoneFor(ref, habit);
    if (milestone != null) onBurst(l10n.streakMilestone(milestone));
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          milestone == null ? l10n.markedDone : l10n.streakMilestone(milestone),
        ),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () =>
              repository.clear(habitId: habit.id, date: selected.iso),
        ),
      ),
    );
  }

  Future<void> _step(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    double current,
    double delta,
  ) async {
    final next = stepQuantity(current, delta);
    final repository = ref.read(completionRepositoryProvider);
    final note = done[habit.id]?.note;
    if (next <= 0 && (note == null || note.isEmpty)) {
      await repository.clear(habitId: habit.id, date: selected.iso);
      return;
    }
    await repository.setValue(
      habitId: habit.id,
      date: selected.iso,
      value: next,
      note: note,
    );
    if (!context.mounted) return;
    if (!meetsTarget(current, habit.targetValue) &&
        meetsTarget(next, habit.targetValue)) {
      playHaptic();
      final milestone = _milestoneFor(ref, habit);
      if (milestone != null) {
        onBurst(AppLocalizations.of(context).streakMilestone(milestone));
      }
    }
  }

  Future<void> _note(BuildContext context, WidgetRef ref, Habit habit) async {
    final current = done[habit.id];
    final initial = CompletionNote.decode(current?.note);
    final result = await showNoteSheet(context, initial: initial);
    if (result == null || !context.mounted) return;
    final repository = ref.read(completionRepositoryProvider);
    final encoded = result.encode();
    final currentValue = current?.value ?? 0;
    if (encoded == null && currentValue <= 0) {
      if (current != null) {
        await repository.clear(habitId: habit.id, date: selected.iso);
      }
      return;
    }
    final value = encoded != null && currentValue < habit.targetValue
        ? habit.targetValue
        : currentValue;
    await repository.setValue(
      habitId: habit.id,
      date: selected.iso,
      value: value <= 0 ? habit.targetValue : value,
      note: encoded,
    );
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.archiveHabitTitle,
      message: l10n.archiveHabitMessage,
      confirmLabel: l10n.archive,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final repository = ref.read(habitRepositoryProvider);
    await repository.archive(habit.id);
    if (!context.mounted) return;
    showUndoBar(
      context,
      message: l10n.archivedMessage,
      actionLabel: l10n.undo,
      onUndo: () => repository.unarchive(habit.id),
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
    final realToday = CalendarDate.today().iso;
    final before = calculator
        .calculate(
          habit: habit.schedule,
          completions: map,
          today: realToday,
          weekStart: weekStart,
        )
        .current;
    map[selected.iso] = habit.targetValue;
    final after = calculator
        .calculate(
          habit: habit.schedule,
          completions: map,
          today: realToday,
          weekStart: weekStart,
        )
        .current;
    return crossedMilestone(before, after);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.dateLabel,
    required this.counts,
  });

  final String greeting;
  final String dateLabel;
  final DayCounts counts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = counts.rate == null ? null : (counts.rate! * 100).round();
    final center = percent == null ? l10n.noRate : l10n.percentValue(percent);
    final semantics = percent == null
        ? l10n.ringEmpty(l10n.today)
        : l10n.ringSemantics(l10n.today, '$percent');
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(dateLabel, style: Theme.of(context).textTheme.bodyMedium),
              if (counts.due > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.doneOfTotal(counts.done, counts.due),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ],
          ),
        ),
        ProgressRing(
          value: counts.rate,
          centerLabel: center,
          semanticsLabel: semantics,
          size: 76,
          strokeWidth: 7,
        ),
      ],
    );
  }
}
