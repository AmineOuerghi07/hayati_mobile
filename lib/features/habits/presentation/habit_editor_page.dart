import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/platform/reminder_picker.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class HabitEditorPage extends ConsumerStatefulWidget {
  const HabitEditorPage({super.key, this.habitId});

  final String? habitId;

  @override
  ConsumerState<HabitEditorPage> createState() => _HabitEditorPageState();
}

class _HabitEditorPageState extends ConsumerState<HabitEditorPage> {
  final _name = TextEditingController();
  String _icon = 'check';
  String _color = 'hayati';
  HabitType _type = HabitType.boolean;
  FrequencyType _frequency = FrequencyType.daily;
  final _weekdays = <int>{DateTime.monday, DateTime.wednesday, DateTime.friday};
  double _timesPerWeek = 3;
  int? _reminder;
  String _startDate = CalendarDate.today().iso;
  var _loaded = false;
  var _showNameError = false;
  var _showDayError = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _load(Habit habit) {
    if (_loaded) return;
    _loaded = true;
    _name.text = habit.name;
    _icon = habit.icon;
    _color = habit.colorKey;
    _type = habit.type;
    _frequency = habit.frequencyType;
    _weekdays
      ..clear()
      ..addAll(habit.weekdays);
    _timesPerWeek = habit.timesPerWeek.toDouble();
    _reminder = habit.reminderTime;
    _startDate = habit.startDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editing = widget.habitId != null;
    if (editing) {
      final existing = ref.watch(habitByIdProvider(widget.habitId!));
      existing.whenData((habit) {
        if (habit != null) _load(habit);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(editing ? l10n.editHabit : l10n.addHabit)),
      body: ListView(
        key: const Key('habit-editor'),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        children: [
          TextField(
            controller: _name,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.habitName,
              errorText: _showNameError ? l10n.nameRequired : null,
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.icon, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in habitIcons.entries)
                _Choice(
                  selected: _icon == entry.key,
                  tooltip: entry.key,
                  onTap: () => setState(() => _icon = entry.key),
                  child: Icon(entry.value),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.color, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in habitColorKeys)
                _Choice(
                  selected: _color == key,
                  tooltip: habitColorLabel(l10n, key),
                  color: habitColor(key),
                  onTap: () => setState(() => _color = key),
                  child: const SizedBox.square(dimension: 28),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.frequency, style: Theme.of(context).textTheme.titleMedium),
          RadioGroup<FrequencyType>(
            groupValue: _frequency,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _frequency = value);
            },
            child: Column(
              children: [
                RadioListTile<FrequencyType>(
                  contentPadding: EdgeInsetsDirectional.zero,
                  value: FrequencyType.daily,
                  title: Text(l10n.frequencyDaily),
                ),
                RadioListTile<FrequencyType>(
                  contentPadding: EdgeInsetsDirectional.zero,
                  value: FrequencyType.weekdays,
                  title: Text(l10n.frequencyWeekdays),
                ),
                RadioListTile<FrequencyType>(
                  contentPadding: EdgeInsetsDirectional.zero,
                  value: FrequencyType.timesPerWeek,
                  title: Text(l10n.frequencyTimesPerWeek),
                ),
              ],
            ),
          ),
          if (_frequency == FrequencyType.weekdays) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                  FilterChip(
                    label: Text(_weekdayLabel(context, day)),
                    selected: _weekdays.contains(day),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _weekdays.add(day);
                        } else {
                          _weekdays.remove(day);
                        }
                      });
                    },
                  ),
              ],
            ),
            if (_showDayError)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(
                  l10n.chooseDays,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
          if (_frequency == FrequencyType.timesPerWeek) ...[
            const SizedBox(height: 12),
            Text('${l10n.timesEachWeek}: ${_timesPerWeek.round()}'),
            Slider(
              value: _timesPerWeek,
              min: 1,
              max: 7,
              divisions: 6,
              label: '${_timesPerWeek.round()}',
              onChanged: (value) => setState(() => _timesPerWeek = value),
            ),
          ],
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            title: Text(l10n.reminder),
            subtitle: Text(formatReminder(context, _reminder)),
            onTap: () async {
              final picked = await showReminderPicker(
                context,
                currentMinutes: _reminder,
              );
              if (picked == null) return;
              setState(() => _reminder = picked);
            },
          ),
          if (_reminder != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => setState(() => _reminder = null),
                child: Text(l10n.clearReminder),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
    );
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final monday = DateTime(2026, 1, 5);
    final date = monday.add(Duration(days: weekday - DateTime.monday));
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.E(locale).format(date);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final missingDays =
        _frequency == FrequencyType.weekdays && _weekdays.isEmpty;
    setState(() {
      _showNameError = name.isEmpty;
      _showDayError = missingDays;
    });
    if (name.isEmpty || missingDays) return;

    final draft = HabitDraft(
      name: name,
      icon: _icon,
      colorKey: _color,
      type: _type,
      frequencyType: _frequency,
      weekdays: _weekdays.toList()..sort(),
      timesPerWeek: _timesPerWeek.round(),
      reminderTime: _reminder,
      startDate: _startDate,
    );
    final repository = ref.read(habitRepositoryProvider);
    if (widget.habitId == null) {
      await repository.create(draft);
    } else {
      final current = await ref.read(habitByIdProvider(widget.habitId!).future);
      if (current == null) return;
      await repository.update(
        current.copyWith(
          name: draft.name,
          icon: draft.icon,
          colorKey: draft.colorKey,
          type: draft.type,
          frequencyType: draft.frequencyType,
          weekdays: draft.weekdays,
          timesPerWeek: draft.timesPerWeek,
          reminderTime: draft.reminderTime,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    }
    if (!mounted) return;
    context.pop();
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.tooltip,
    required this.onTap,
    required this.child,
    this.color,
  });

  final bool selected;
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.primary;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? outline : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox.square(dimension: 48, child: Center(child: child)),
        ),
      ),
    );
  }
}
