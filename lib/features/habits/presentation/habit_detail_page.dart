import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/animated_count.dart';
import 'package:hayati/core/widgets/async_error_view.dart';
import 'package:hayati/core/widgets/confirm_sheet.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/concentric_rings.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/core/widgets/streak_flame.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_due.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
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
        actions: [
          if (habitAsync.value != null)
            IconButton(
              tooltip: l10n.editHabit,
              onPressed: () => _menu(context, ref, habitAsync.value!),
              icon: const Icon(Icons.more_horiz),
            ),
        ],
      ),
      body: habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const AsyncErrorView(),
        data: (habit) {
          if (habit == null) {
            return Center(child: Text(l10n.emptyTodayTitle));
          }
          final logged = completionsAsync.value ?? const <HabitCompletion>[];
          final today = CalendarDate.today();
          final streak = const StreakCalculator().calculate(
            habit: habit.schedule,
            completions: {for (final item in logged) item.date: item.value},
            today: today.iso,
            weekStart: weekStart,
          );
          final rate = habitCompletionRate(
            habit: habit,
            completions: logged,
            today: today,
          );
          final weeks = habit.frequencyType == FrequencyType.timesPerWeek;
          return ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 32),
            children: [
              _HeroHeader(habit: habit, rate: rate),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StreakCard(
                      title: l10n.currentStreak,
                      value: streak.current,
                      leading: StreakFlame(active: streak.current > 0),
                      caption: weeks
                          ? l10n.streakWeeks(streak.current)
                          : l10n.streakDays(streak.current),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StreakCard(
                      title: l10n.bestStreak,
                      value: streak.best,
                      leading: const Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                      caption: weeks
                          ? l10n.streakWeeks(streak.best)
                          : l10n.streakDays(streak.best),
                    ),
                  ),
                ],
              ),
              SectionHeader(l10n.history),
              _MonthCalendar(
                habit: habit,
                completions: logged,
                weekStart: weekStart,
              ),
              SectionHeader(l10n.recentNotes),
              _Notes(completions: logged),
            ],
          );
        },
      ),
    );
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final choice = await _choose(context, habit, l10n);
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case 'edit':
        context.push('/habits/${habit.id}/edit');
      case 'archive':
        final confirmed = await confirmAction(
          context,
          title: habit.isArchived ? l10n.unarchive : l10n.archiveHabitTitle,
          message: l10n.archiveHabitMessage,
          confirmLabel: habit.isArchived ? l10n.unarchive : l10n.archive,
          cancelLabel: l10n.cancel,
        );
        if (!confirmed || !context.mounted) return;
        final repository = ref.read(habitRepositoryProvider);
        if (habit.isArchived) {
          await repository.unarchive(habit.id);
          if (!context.mounted) return;
          showUndoBar(
            context,
            message: l10n.restoredMessage,
            actionLabel: l10n.undo,
            onUndo: () => repository.archive(habit.id),
          );
        } else {
          await repository.archive(habit.id);
          if (!context.mounted) return;
          showUndoBar(
            context,
            message: l10n.archivedMessage,
            actionLabel: l10n.undo,
            onUndo: () => repository.unarchive(habit.id),
          );
        }
      case 'delete':
        final confirmed = await confirmAction(
          context,
          title: l10n.deleteHabitTitle,
          message: l10n.deleteHabitMessage,
          confirmLabel: l10n.delete,
          cancelLabel: l10n.cancel,
          destructive: true,
        );
        if (!confirmed || !context.mounted) return;
        await ref.read(habitRepositoryProvider).softDelete(habit.id);
        if (!context.mounted) return;
        context.pop();
    }
  }
}

Future<String?> _choose(
  BuildContext context,
  Habit habit,
  AppLocalizations l10n,
) async {
  final archiveLabel = habit.isArchived ? l10n.unarchive : l10n.archive;
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, 'edit'),
              child: Text(l10n.editHabit),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, 'archive'),
              child: Text(archiveLabel),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, 'delete'),
              child: Text(l10n.delete),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        );
      },
    );
  }
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.editHabit),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              title: Text(archiveLabel),
              onTap: () => Navigator.pop(context, 'archive'),
            ),
            ListTile(
              title: Text(l10n.delete),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      );
    },
  );
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.habit, required this.rate});

  final Habit habit;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = HayatiTokens.of(context);
    final color = habitColor(habit.colorKey);
    final percent = rate == null ? null : (rate! * 100).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusSheet),
      child: AuroraBackground(
        base: Color.lerp(color, Colors.black, 0.22)!,
        colors: [
          color,
          Colors.white.withValues(alpha: 0.14),
          Color.lerp(color, Colors.black, 0.4)!,
        ],
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Row(
            children: [
              Hero(
                tag: 'habit-${habit.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    habitIcon(habit.icon),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (habit.tracksQuantity)
                      Text(
                        l10n
                            .quantityProgress(
                              0,
                              habit.targetValue.round(),
                              unitLabel(l10n, habit.unit),
                            )
                            .trim()
                            .replaceFirst('0 / ', ''),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.completionRate,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              ConcentricRings(
                size: 80,
                strokeWidth: 9,
                semanticsLabel: percent == null
                    ? l10n.ringEmpty(l10n.completionRate)
                    : l10n.ringSemantics(l10n.completionRate, '$percent'),
                rings: [RingValue(value: rate, color: Colors.white)],
                center: Text(
                  percent == null ? l10n.noRate : l10n.percentValue(percent),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.leading,
  });

  final String title;
  final int value;
  final String caption;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leading,
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Semantics(
            label: caption,
            excludeSemantics: true,
            child: AnimatedCount(
              value: value,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthCalendar extends ConsumerStatefulWidget {
  const _MonthCalendar({
    required this.habit,
    required this.completions,
    required this.weekStart,
  });

  final Habit habit;
  final List<HabitCompletion> completions;
  final int weekStart;

  @override
  ConsumerState<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends ConsumerState<_MonthCalendar> {
  late CalendarDate _month;

  @override
  void initState() {
    super.initState();
    final today = CalendarDate.today();
    _month = CalendarDate(today.year, today.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final today = CalendarDate.today();
    final values = {for (final item in widget.completions) item.date: item};
    final cells = _cells(_month, widget.weekStart);
    final title = DateFormat.yMMM(locale)
        .format(DateTime(_month.year, _month.month));
    final atCurrent = _month.year == today.year && _month.month == today.month;
    final color = habitColor(widget.habit.colorKey);
    return SoftCard(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.previousMonth,
                onPressed: () =>
                    setState(() => _month = _shiftMonth(_month, -1)),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l10n.nextMonth,
                onPressed: atCurrent
                    ? null
                    : () => setState(() => _month = _shiftMonth(_month, 1)),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          Row(
            children: [
              for (final day in weekContainingLabels(context, widget.weekStart))
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [
              for (final day in cells)
                if (day == null)
                  const SizedBox.shrink()
                else
                  _DayCell(
                    day: day,
                    today: today,
                    habit: widget.habit,
                    completion: values[day.iso],
                    color: color,
                    onTap: () => _tap(day, values[day.iso]),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _tap(CalendarDate day, HabitCompletion? completion) async {
    final habit = widget.habit;
    final today = CalendarDate.today();
    final start = CalendarDate.parse(habit.startDate);
    if (day > today || day < start) return;
    final repository = ref.read(completionRepositoryProvider);
    if (habit.tracksQuantity) {
      final next = await showQuantityEditor(
        context,
        value: completion?.value ?? 0,
        target: habit.targetValue,
        unit: unitLabel(AppLocalizations.of(context), habit.unit),
      );
      if (next == null) return;
      if (next <= 0) {
        await repository.clear(habitId: habit.id, date: day.iso);
        return;
      }
      await repository.setValue(
        habitId: habit.id,
        date: day.iso,
        value: next,
        note: completion?.note,
      );
      return;
    }
    final done = meetsTarget(completion?.value ?? 0, habit.targetValue);
    if (done) {
      await repository.clear(habitId: habit.id, date: day.iso);
    } else {
      await repository.setValue(
        habitId: habit.id,
        date: day.iso,
        value: habit.targetValue,
        note: completion?.note,
      );
    }
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.today,
    required this.habit,
    required this.completion,
    required this.color,
    required this.onTap,
  });

  final CalendarDate day;
  final CalendarDate today;
  final Habit habit;
  final HabitCompletion? completion;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final start = CalendarDate.parse(habit.startDate);
    final enabled = day <= today && day >= start && isHabitDueOn(habit, day);
    final done = meetsTarget(completion?.value ?? 0, habit.targetValue);
    final partial = !done && (completion?.value ?? 0) > 0;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: done
          ? color
          : partial
          ? color.withValues(alpha: 0.28)
          : scheme.surfaceContainerHighest.withValues(alpha: enabled ? 1 : 0.4),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled ? onTap : null,
        child: Center(
          child: Text(
            '${day.day}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: done ? Colors.white : scheme.onSurface,
              fontWeight: day == today ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({required this.completions});

  final List<HabitCompletion> completions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notes = [
      for (final item in completions)
        if (item.note != null && item.note!.isNotEmpty) item,
    ]..sort((a, b) => b.date.compareTo(a.date));
    if (notes.isEmpty) {
      return Text(l10n.noNotesYet);
    }
    final locale = Localizations.localeOf(context).toString();
    return Column(
      children: [
        for (final item in notes.take(8))
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: SoftCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (CompletionNote.decode(item.note).mood != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Icon(
                        moodIconFor(CompletionNote.decode(item.note).mood!),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMd(locale)
                              .format(DateTime.parse(item.date)),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(CompletionNote.decode(item.note).text),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

CalendarDate _shiftMonth(CalendarDate month, int delta) {
  final shifted = DateTime.utc(month.year, month.month + delta, 1);
  return CalendarDate(shifted.year, shifted.month, 1);
}

List<CalendarDate?> _cells(CalendarDate month, int weekStart) {
  final first = CalendarDate(month.year, month.month, 1);
  final days = DateTime.utc(month.year, month.month + 1, 0).day;
  final leading = (first.weekday - weekStart) % 7;
  final blanks = leading < 0 ? leading + 7 : leading;
  return [
    for (var index = 0; index < blanks; index++) null,
    for (var day = 1; day <= days; day++)
      CalendarDate(month.year, month.month, day),
  ];
}

List<String> weekContainingLabels(BuildContext context, int weekStart) {
  final locale = Localizations.localeOf(context).toString();
  final monday = DateTime(2026, 1, 5);
  return [
    for (var index = 0; index < 7; index++)
      DateFormat.E(locale)
          .format(monday.add(Duration(days: (weekStart - 1 + index) % 7))),
  ];
}

Future<double?> showQuantityEditor(
  BuildContext context, {
  required double value,
  required double target,
  required String unit,
}) {
  return showDialog<double>(
    context: context,
    builder: (context) =>
        _QuantityDialog(value: value, target: target, unit: unit),
  );
}

class _QuantityDialog extends StatefulWidget {
  const _QuantityDialog({
    required this.value,
    required this.target,
    required this.unit,
  });

  final double value;
  final double target;
  final String unit;

  @override
  State<_QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<_QuantityDialog> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.goalCount),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: l10n.decreaseHabit(l10n.target),
            onPressed: _value <= 0
                ? null
                : () => setState(() => _value = stepQuantity(_value, -1)),
            icon: const Icon(Icons.remove),
          ),
          Flexible(
            child: FittedBox(
              child: Text(
                l10n
                    .quantityProgress(
                      _value.round(),
                      widget.target.round(),
                      widget.unit,
                    )
                    .trim(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.increaseHabit(l10n.target),
            onPressed: () => setState(() => _value = stepQuantity(_value, 1)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _value),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
