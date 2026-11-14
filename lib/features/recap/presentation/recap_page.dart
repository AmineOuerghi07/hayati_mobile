import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/animated_count.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/features/recap/domain/weekly_recap.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class RecapPage extends ConsumerWidget {
  const RecapPage({this.previousWeek = false, super.key});

  /// Last week's story, offered on the first day of a new week.
  final bool previousWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsProvider).value;
    final completions = ref.watch(allCompletionsProvider).value;
    if (habits == null || completions == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final today = CalendarDate.today();
    final end = previousWeek ? previousWeekEnd(today) : today;
    final weekStart =
        ref.watch(preferencesControllerProvider).value?.weekStart ??
        AppPreferences.fallback.weekStart;
    return RecapView(
      recap: weeklyRecap(habits: habits, completions: completions, today: end),
      rangeLabel: _rangeLabel(context, end),
      onDismiss: previousWeek
          ? () async {
              await ref
                  .read(preferencesControllerProvider.notifier)
                  .setRecapDismissedWeek(today.startOfWeek(weekStart).iso);
              if (context.mounted) context.pop();
            }
          : null,
    );
  }
}

String _rangeLabel(BuildContext context, CalendarDate end) {
  final start = end.addDays(-6);
  final format = DateFormat.MMMd(Localizations.localeOf(context).toString());
  String day(CalendarDate date) =>
      format.format(DateTime(date.year, date.month, date.day));
  return '${day(start)} – ${day(end)}';
}

class RecapView extends StatefulWidget {
  const RecapView({
    required this.recap,
    this.onDismiss,
    this.rangeLabel,
    super.key,
  });

  final WeeklyRecap recap;
  final Future<void> Function()? onDismiss;
  final String? rangeLabel;

  @override
  State<RecapView> createState() => _RecapViewState();
}

class _RecapViewState extends State<RecapView>
    with SingleTickerProviderStateMixin {
  late final PageController _pages = PageController();
  late final AnimationController _bar = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );
  var _index = 0;

  List<_Story> get _stories => _buildStories(
    AppLocalizations.of(context),
    widget.recap,
    Localizations.localeOf(context).toString(),
  );

  @override
  void initState() {
    super.initState();
    _bar.addStatusListener((status) {
      if (status == AnimationStatus.completed) _step(1);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _bar.stop();
    } else if (!_bar.isAnimating) {
      _bar.forward();
    }
  }

  @override
  void dispose() {
    _bar.dispose();
    _pages.dispose();
    super.dispose();
  }

  void _step(int delta) {
    final stories = _stories;
    final next = _index + delta;
    if (next < 0) return;
    if (next >= stories.length) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _index = next);
    _pages.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    if (!MediaQuery.disableAnimationsOf(context)) _bar.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final stories = _stories;
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: l10n.close,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                if (widget.onDismiss != null)
                  TextButton(
                    onPressed: widget.onDismiss,
                    child: Text(l10n.dismissRecap),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
              child: Row(
                children: [
                  for (var index = 0; index < stories.length; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 2,
                        ),
                        child: AnimatedBuilder(
                          animation: _bar,
                          builder: (context, _) {
                            final value = index < _index
                                ? 1.0
                                : index == _index
                                ? _bar.value
                                : 0.0;
                            return LinearProgressIndicator(value: value);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.rangeLabel != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(
                  widget.rangeLabel!,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pages,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final story in stories) _StoryCard(story: story),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _step(-1),
                          onLongPressStart: (_) => _bar.stop(),
                          onLongPressEnd: (_) => _bar.forward(),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => _step(1),
                          onLongPressStart: (_) => _bar.stop(),
                          onLongPressEnd: (_) => _bar.forward(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Story {
  const _Story({
    required this.title,
    required this.body,
    required this.icon,
    this.count,
  });

  final String title;
  final String body;
  final IconData icon;
  final int? count;
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story});

  final _Story story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onPrimaryContainer;
    return Padding(
      padding: const EdgeInsetsDirectional.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(story.icon, size: 72, color: on),
          const SizedBox(height: 24),
          if (story.count != null)
            AnimatedCount(
              value: story.count!,
              style: theme.textTheme.displayMedium?.copyWith(
                color: on,
                fontWeight: FontWeight.w700,
              ),
            ),
          Text(
            story.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(color: on),
          ),
          const SizedBox(height: 12),
          Text(
            story.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: on.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

List<_Story> _buildStories(
  AppLocalizations l10n,
  WeeklyRecap recap,
  String locale,
) {
  if (recap.isEmpty) {
    return [
      _Story(
        title: l10n.recapTitle,
        body: l10n.recapEmptyBody,
        icon: Icons.auto_stories_outlined,
      ),
      _Story(
        title: l10n.recapNextTitle,
        body: l10n.recapNextBody,
        icon: Icons.arrow_forward_rounded,
      ),
    ];
  }
  final bestDay = recap.bestDay == null
      ? l10n.recapBestDayEmpty
      : l10n.recapBestDayBody(
          DateFormat.EEEE(locale).format(
            DateTime(
              recap.bestDay!.year,
              recap.bestDay!.month,
              recap.bestDay!.day,
            ),
          ),
          recap.bestDayCount,
        );
  final mood = recap.averageMood?.round();
  return [
    _Story(
      title: l10n.recapCheckInsTitle,
      body: l10n.recapCheckInsBody(recap.checkIns),
      icon: Icons.task_alt_rounded,
      count: recap.checkIns,
    ),
    _Story(
      title: l10n.recapBestDayTitle,
      body: bestDay,
      icon: Icons.wb_sunny_outlined,
      count: recap.bestDayCount == 0 ? null : recap.bestDayCount,
    ),
    _Story(
      title: l10n.recapTopHabitTitle,
      body: recap.topHabitName == null
          ? l10n.recapTopHabitEmpty
          : l10n.recapTopHabitBody(recap.topHabitName!, recap.topHabitCount),
      icon: Icons.emoji_events_outlined,
    ),
    _Story(
      title: l10n.recapPerfectTitle,
      body: l10n.recapPerfectBody(recap.perfectDays),
      icon: Icons.auto_awesome_rounded,
      count: recap.perfectDays,
    ),
    _Story(
      title: l10n.recapMoodTitle,
      body: mood == null ? l10n.recapMoodEmpty : moodLabel(l10n, mood),
      icon: Icons.favorite_outline_rounded,
    ),
    _Story(
      title: l10n.recapGardenTitle,
      body: l10n.recapGardenBody(recap.grownPlants),
      icon: Icons.yard_outlined,
      count: recap.grownPlants,
    ),
    _Story(
      title: l10n.recapNextTitle,
      body: l10n.recapNextBody,
      icon: Icons.flag_outlined,
    ),
  ];
}
