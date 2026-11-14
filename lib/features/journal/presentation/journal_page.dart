import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/empty_state.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/note_sheet.dart';
import 'package:hayati/features/journal/domain/daily_reflection.dart';
import 'package:hayati/features/journal/presentation/reflection_providers.dart';
import 'package:hayati/features/journal/presentation/reflection_sheet.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reflections = ref.watch(reflectionsProvider).value ?? const [];
    final byDate = {for (final item in reflections) item.date: item};
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.journalTitle)),
      body: ResponsiveListView(
        side: 16,
        top: 8,
        bottom: 32,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.previousWeek,
                onPressed: () => setState(() {
                  _month = DateTime(_month.year, _month.month - 1);
                }),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(_month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: l10n.nextWeek,
                onPressed: () => setState(() {
                  _month = DateTime(_month.year, _month.month + 1);
                }),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          _MoodMonth(
            month: _month,
            byDate: byDate,
            onDay: (date, existing) => showReflectionSheet(
              context,
              ref,
              existing: existing,
              date: date.iso,
            ),
          ),
          const SizedBox(height: 16),
          if (reflections.isEmpty)
            EmptyState(
              icon: Icons.menu_book_outlined,
              title: l10n.journalTitle,
              body: l10n.noReflections,
            )
          else
            for (final item in reflections.take(12))
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: SoftCard(
                  onTap: () =>
                      showReflectionSheet(context, ref, existing: item),
                  child: _ReflectionTile(item: item, locale: locale),
                ),
              ),
        ],
      ),
    );
  }
}

class _MoodMonth extends StatelessWidget {
  const _MoodMonth({
    required this.month,
    required this.byDate,
    required this.onDay,
  });

  final DateTime month;
  final Map<String, DailyReflection> byDate;
  final void Function(CalendarDate date, DailyReflection? existing) onDay;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final days = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday - DateTime.monday;
    final cells = leading + days;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: cells,
      itemBuilder: (context, index) {
        if (index < leading) return const SizedBox.shrink();
        final day = index - leading + 1;
        final date = CalendarDate(month.year, month.month, day);
        final reflection = byDate[date.iso];
        final mood = reflection?.mood;
        final color = mood == null
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : _moodColor(mood);
        return Material(
          color: color.withValues(alpha: mood == null ? 0.5 : 0.85),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onDay(date, reflection),
            child: Center(
              child: mood == null
                  ? Text('$day')
                  : Icon(moodIconFor(mood), size: 18),
            ),
          ),
        );
      },
    );
  }
}

class _ReflectionTile extends StatelessWidget {
  const _ReflectionTile({required this.item, required this.locale});

  final DailyReflection item;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = CalendarDate.parse(item.date);
    final label = DateFormat.yMMMd(locale)
        .format(DateTime(date.year, date.month, date.day));
    final lines = [
      if (item.mood != null) moodLabel(l10n, item.mood!),
      if (item.gratitude != null && item.gratitude!.isNotEmpty) item.gratitude!,
      if (item.note != null && item.note!.isNotEmpty) item.note!,
    ];
    return Row(
      children: [
        if (item.mood != null)
          Icon(moodIconFor(item.mood!), color: _moodColor(item.mood!)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              if (lines.isNotEmpty)
                Text(
                  lines.join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Color _moodColor(int mood) => switch (mood) {
  1 => const Color(0xFFE11D48),
  2 => const Color(0xFFF97316),
  3 => const Color(0xFFEAB308),
  4 => const Color(0xFF22C55E),
  _ => const Color(0xFF14B8A6),
};
