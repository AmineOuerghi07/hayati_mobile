import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/platform/reminder_picker.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/section_header.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/domain/habit_templates.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
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
  final _customUnit = TextEditingController();
  String _icon = 'check';
  String _color = 'hayati';
  var _counting = false;
  double _target = 8;
  String _unitKey = 'times';
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
    _customUnit.dispose();
    super.dispose();
  }

  void _load(Habit habit) {
    if (_loaded) return;
    _loaded = true;
    _name.text = habit.name;
    _icon = habit.icon;
    _color = habit.colorKey;
    _counting = habit.tracksQuantity;
    _target = habit.targetValue < 1 ? 1 : habit.targetValue;
    final unit = habit.unit;
    if (unit != null && knownUnits.contains(unit)) {
      _unitKey = unit;
    } else if (unit != null && unit.isNotEmpty) {
      _customUnit.text = unit;
    }
    _frequency = habit.frequencyType;
    _weekdays
      ..clear()
      ..addAll(habit.weekdays);
    _timesPerWeek = habit.timesPerWeek.toDouble();
    _reminder = habit.reminderTime;
    _startDate = habit.startDate;
  }

  String get _resolvedUnit {
    final custom = _customUnit.text.trim();
    if (custom.isNotEmpty) return custom;
    return _unitKey;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final editing = widget.habitId != null;
    if (editing) {
      final existing = ref.watch(habitByIdProvider(widget.habitId!));
      existing.whenData((habit) {
        if (habit != null) _load(habit);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(editing ? l10n.editHabit : l10n.addHabit)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
          child: FilledButton(onPressed: _save, child: Text(l10n.save)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        children: [
          SectionHeader(l10n.preview),
          _Preview(
            name: _name.text.trim(),
            icon: _icon,
            colorKey: _color,
            counting: _counting,
            detail: _counting
                ? l10n
                      .quantityProgress(
                        0,
                        _target.round(),
                        unitLabel(l10n, _resolvedUnit),
                      )
                      .trim()
                : l10n.goalCheck,
          ),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _name,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.habitName,
                    errorText: _showNameError ? l10n.nameRequired : null,
                  ),
                ),
                if (_name.text.trim().isEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.suggestions,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final template in habitTemplates)
                        ActionChip(
                          label: Text(templateTitle(l10n, template.id)),
                          onPressed: () => _applyTemplate(template),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SectionHeader(l10n.icon),
          SoftCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in habitIcons.entries)
                  _Choice(
                    selected: _icon == entry.key,
                    tooltip: entry.key,
                    onTap: () => setState(() => _icon = entry.key),
                    child: Icon(
                      entry.value,
                      color: _icon == entry.key ? habitColor(_color) : null,
                    ),
                  ),
              ],
            ),
          ),
          SectionHeader(l10n.color),
          SoftCard(
            child: Wrap(
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
          ),
          SectionHeader(l10n.goal),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(
                      value: false,
                      label: Text(l10n.goalCheck),
                      icon: const Icon(Icons.check),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text(l10n.goalCount),
                      icon: const Icon(Icons.pin_outlined),
                    ),
                  ],
                  selected: {_counting},
                  onSelectionChanged: (value) {
                    setState(() => _counting = value.first);
                  },
                ),
                AnimatedSize(
                  duration: tokens.motion(context, tokens.motionMedium),
                  curve: tokens.easeOut,
                  alignment: AlignmentDirectional.topStart,
                  child: _counting
                      ? _CountFields(
                          target: _target,
                          unitKey: _unitKey,
                          customUnit: _customUnit,
                          onTarget: (value) => setState(() => _target = value),
                          onUnit: (value) => setState(() {
                            _unitKey = value;
                            _customUnit.clear();
                          }),
                          onCustom: () => setState(() {}),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
          SectionHeader(l10n.frequency),
          SoftCard(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup<FrequencyType>(
                  groupValue: _frequency,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _frequency = value);
                  },
                  child: Column(
                    children: [
                      RadioListTile<FrequencyType>(
                        value: FrequencyType.daily,
                        title: Text(l10n.frequencyDaily),
                      ),
                      RadioListTile<FrequencyType>(
                        value: FrequencyType.weekdays,
                        title: Text(l10n.frequencyWeekdays),
                      ),
                      RadioListTile<FrequencyType>(
                        value: FrequencyType.timesPerWeek,
                        title: Text(l10n.frequencyTimesPerWeek),
                      ),
                    ],
                  ),
                ),
                if (_frequency == FrequencyType.weekdays) ...[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      0,
                      16,
                      12,
                    ),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        for (
                          var day = DateTime.monday;
                          day <= DateTime.sunday;
                          day++
                        )
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
                  ),
                  if (_showDayError)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        0,
                        16,
                        12,
                      ),
                      child: Text(
                        l10n.chooseDays,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
                if (_frequency == FrequencyType.timesPerWeek)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.timesEachWeek}: ${_timesPerWeek.round()}'),
                        Slider(
                          value: _timesPerWeek,
                          min: 1,
                          max: 7,
                          divisions: 6,
                          label: '${_timesPerWeek.round()}',
                          onChanged: (value) =>
                              setState(() => _timesPerWeek = value),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SectionHeader(l10n.reminder),
          SoftCard(
            onTap: () async {
              final picked = await showReminderPicker(
                context,
                currentMinutes: _reminder,
              );
              if (picked == null) return;
              setState(() => _reminder = picked);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reminder,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(formatReminder(context, _reminder)),
                if (_reminder != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => setState(() => _reminder = null),
                      child: Text(l10n.clearReminder),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyTemplate(HabitTemplate template) {
    setState(() {
      _name.text = templateTitle(AppLocalizations.of(context), template.id);
      _icon = template.icon;
      _color = template.colorKey;
      _counting = template.type == HabitType.quantity;
      _target = template.targetValue;
      if (template.unit != null && knownUnits.contains(template.unit)) {
        _unitKey = template.unit!;
        _customUnit.clear();
      }
    });
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
      type: _counting ? HabitType.quantity : HabitType.boolean,
      targetValue: _counting ? _target : 1,
      unit: _counting ? _resolvedUnit : null,
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
          targetValue: draft.targetValue,
          unit: draft.unit,
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

class _Preview extends StatelessWidget {
  const _Preview({
    required this.name,
    required this.icon,
    required this.colorKey,
    required this.counting,
    required this.detail,
  });

  final String name;
  final String icon;
  final String colorKey;
  final bool counting;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final color = habitColor(colorKey);
    return SoftCard(
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: HayatiTokens.of(context)
                .motion(context, const Duration(milliseconds: 350)),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: child,
            ),
            child: HabitBadge(
              key: ValueKey('$icon-$colorKey'),
              icon: icon,
              colorKey: colorKey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? ' ' : name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (!counting)
            Icon(Icons.circle_outlined, color: color)
          else
            Icon(Icons.add_circle_outline, color: color),
        ],
      ),
    );
  }
}

class _CountFields extends StatelessWidget {
  const _CountFields({
    required this.target,
    required this.unitKey,
    required this.customUnit,
    required this.onTarget,
    required this.onUnit,
    required this.onCustom,
  });

  final double target;
  final String unitKey;
  final TextEditingController customUnit;
  final ValueChanged<double> onTarget;
  final ValueChanged<String> onUnit;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.target),
          Row(
            children: [
              IconButton(
                tooltip: l10n.decreaseHabit(l10n.target),
                onPressed: target <= 1 ? null : () => onTarget(target - 1),
                icon: const Icon(Icons.remove),
              ),
              Text(
                '${target.round()}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                tooltip: l10n.increaseHabit(l10n.target),
                onPressed: target >= 100 ? null : () => onTarget(target + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Text(l10n.unit),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final unit in knownUnits)
                ChoiceChip(
                  label: Text(unitLabel(l10n, unit)),
                  selected: customUnit.text.isEmpty && unitKey == unit,
                  onSelected: (_) => onUnit(unit),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: customUnit,
            onChanged: (_) => onCustom(),
            decoration: InputDecoration(labelText: l10n.customUnit),
          ),
        ],
      ),
    );
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
    final tokens = HayatiTokens.of(context);
    return Tooltip(
      message: tooltip,
      child: AnimatedScale(
        scale: selected ? 1.08 : 1,
        duration: tokens.motion(context, tokens.motionMedium),
        curve: tokens.checkOff,
        child: AnimatedContainer(
          duration: tokens.motion(context, tokens.motionFast),
          curve: tokens.easeOut,
          decoration: BoxDecoration(
            color: color == null
                ? Theme.of(context).colorScheme.surfaceContainerHigh
                : null,
            gradient: color == null ? null : habitGradient(color!),
            borderRadius: BorderRadius.circular(tokens.radiusChip),
            border: Border.all(
              color: selected ? outline : Colors.transparent,
              width: selected ? 2.5 : 0,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(tokens.radiusChip),
            child: SizedBox.square(dimension: 48, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
