import 'package:hayati/app/theme.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/week_strip.dart';
import 'package:hayati/features/stats/domain/insights.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class WeekStripBar extends StatelessWidget {
  const WeekStripBar({
    required this.selected,
    required this.today,
    required this.weekStart,
    required this.habits,
    required this.completions,
    required this.onSelect,
    super.key,
  });

  final CalendarDate selected;
  final CalendarDate today;
  final int weekStart;
  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final ValueChanged<CalendarDate> onSelect;

  @override
  Widget build(BuildContext context) {
    final days = weekContaining(selected, weekStart);
    final locale = Localizations.localeOf(context).toString();
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    return Row(
      children: [
        for (final day in days)
          Expanded(child: _day(context, day, locale, scheme, tokens)),
      ],
    );
  }

  Widget _day(
    BuildContext context,
    CalendarDate day,
    String locale,
    ColorScheme scheme,
    HayatiTokens tokens,
  ) {
    final enabled = canLogDay(day, today);
    final isSelected = day == selected;
    final isToday = day == today;
    final counts = dayCounts(
      habits: habits,
      completions: completions,
      day: day,
    );
    final weekday = DateFormat.E(locale)
        .format(DateTime(day.year, day.month, day.day));
    final rate = counts.rate;
    final dotColor = rate == null
        ? scheme.outlineVariant
        : rate >= 1
        ? scheme.primary
        : rate > 0
        ? scheme.primary.withValues(alpha: 0.45)
        : scheme.outlineVariant;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 2),
      child: Material(
        color: isSelected
            ? scheme.primaryContainer
            : isToday
            ? scheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        child: InkWell(
          key: ValueKey('day-${day.iso}'),
          borderRadius: BorderRadius.circular(tokens.radiusChip),
          onTap: enabled ? () => onSelect(day) : null,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      weekday,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: enabled
                            ? scheme.onSurfaceVariant
                            : scheme.outline,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: enabled ? scheme.onSurface : scheme.outline,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(dimension: 6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
