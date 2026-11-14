import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/achievements/domain/achievements.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/journal/presentation/reflection_providers.dart';
import 'package:hayati/features/settings/domain/app_preferences.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';

/// Null until habits and completions have loaded.
final achievementSummaryProvider = Provider.autoDispose<AchievementSummary?>((
  ref,
) {
  final habits = ref.watch(activeHabitsProvider).value;
  final completions = ref.watch(allCompletionsProvider).value;
  final reflections = ref.watch(reflectionsProvider).value;
  if (habits == null || completions == null || reflections == null) return null;
  final weekStart =
      ref.watch(preferencesControllerProvider).value?.weekStart ??
      AppPreferences.fallback.weekStart;
  return evaluateAchievements(
    habits: habits,
    completions: completions,
    today: CalendarDate.today(),
    weekStart: weekStart,
    reflections: reflections.length,
    pauseStart: ref.watch(preferencesControllerProvider).value?.pauseStart,
    pauseEnd: ref.watch(preferencesControllerProvider).value?.pauseEnd,
  );
});
