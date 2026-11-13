import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/celebration_overlay.dart';
import 'package:hayati/core/widgets/confirm_sheet.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/skeleton.dart';
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
import 'package:hayati/features/habits/presentation/today_hero.dart';
import 'package:hayati/features/habits/presentation/week_strip_bar.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/features/tools/presentation/tool_cards.dart';
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
        loading: () => const SkeletonList(key: Key('today-loading')),
        error: (error, stack) => const AsyncErrorView(),
        data: (habitList) {
          return completions.when(
            loading: () => const SkeletonList(),
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
    _burstTimer = Timer(celebrationDuration, () {
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
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: responsiveInsets(constraints.maxWidth, top: 12, bottom: 24),
          children: [
            TodayHero(
              greeting: greetingFor(l10n, now),
              dateLabel: DateFormat.MMMMEEEEd(locale).format(now),
              quote: dailyQuote(l10n, now),
              counts: const DayCounts(done: 0, due: 0),
              bestStreak: 0,
            ),
            const SizedBox(height: 24),
            EmptyState(
              icon: Icons.spa_outlined,
              title: l10n.emptyTodayTitle,
              body: l10n.emptyTodayBody,
              actionLabel: l10n.addHabit,
              onAction: onAdd,
              secondaryLabel: l10n.browseTemplates,
              onSecondary: () => showTemplateSheet(context, ref),
            ),
            const SizedBox(height: 24),
            const ToolCards(),
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
    final selectedDay = DateTime(selected.year, selected.month, selected.day);
    final dateLabel = DateFormat.yMMMEd(locale).format(selectedDay);
    final streaks = _streaks(weekStart);
    final bestStreak = streaks.values.fold(0, (a, b) => a > b ? a : b);
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TodayHero(
          greeting: greetingFor(l10n, DateTime.now()),
          dateLabel: DateFormat.MMMMEEEEd(locale).format(selectedDay),
          quote: dailyQuote(l10n, selectedDay),
          counts: counts,
          bestStreak: bestStreak,
        ),
        const SizedBox(height: 4),
        Row(
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
        if (selected != today)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 12),
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
      ],
    );

    Widget list({required Widget? top, required EdgeInsetsDirectional insets}) {
      final listInsets = insets
          .copyWith(top: 12, bottom: 96)
          .resolve(Directionality.of(context));
      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              notification.metrics.axis == Axis.vertical) {
            onScroll(notification.metrics.pixels < 24);
          }
          return false;
        },
        child: due.isEmpty
            ? ListView(
                padding: listInsets,
                children: [
                  ?top,
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selected == today
                                ? l10n.emptyTodayTitle
                                : l10n.nothingDueOnDay,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ToolCards(),
                ],
              )
            : ReorderableListView.builder(
                padding: listInsets,
                header: top,
                buildDefaultDragHandles: false,
                footer: const Padding(
                  padding: EdgeInsetsDirectional.only(top: 12),
                  child: ToolCards(),
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
                      padding: const EdgeInsetsDirectional.only(bottom: 8),
                      child: HabitCard(
                        index: index,
                        habit: habit,
                        value: loggedValue,
                        streak: streaks[habit.id] ?? 0,
                        onOpen: () => context.push('/habits/${habit.id}'),
                        onToggle: () => _toggle(
                          context,
                          ref,
                          habit,
                          meetsTarget(loggedValue, habit.targetValue),
                        ),
                        onStep: (delta) =>
                            _step(context, ref, habit, loggedValue, delta),
                        onNote: () => _note(context, ref, habit),
                        onEdit: () => context.push('/habits/${habit.id}/edit'),
                        onArchive: () => _archive(context, ref, habit),
                      ),
                    ),
                  );
                },
              ),
      );
    }

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= expandedMinWidth) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      24,
                      12,
                      8,
                      24,
                    ),
                    child: header,
                  ),
                ),
                Expanded(
                  child: list(
                    top: null,
                    insets: responsiveInsets(
                      constraints.maxWidth - 400,
                      maxWidth: 640,
                    ),
                  ),
                ),
              ],
            );
          }
          return list(
            top: header,
            insets: responsiveInsets(constraints.maxWidth),
          );
        },
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

  Map<String, int> _streaks(int weekStart) {
    final byHabit = <String, Map<String, double>>{};
    for (final item in logged) {
      (byHabit[item.habitId] ??= {})[item.date] = item.value;
    }
    const calculator = StreakCalculator();
    final realToday = CalendarDate.today().iso;
    return {
      for (final habit in due)
        habit.id: calculator
            .calculate(
              habit: habit.schedule,
              completions: byHabit[habit.id] ?? const {},
              today: realToday,
              weekStart: weekStart,
            )
            .current,
    };
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
