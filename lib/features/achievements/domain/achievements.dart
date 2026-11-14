import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/streak_calculator.dart';
import 'package:hayati/features/stats/domain/insights.dart';

enum AchievementId {
  firstStep,
  streak3,
  streak7,
  streak30,
  perfectDay,
  perfectWeek,
  checkIns50,
  checkIns100,
  habitBuilder,
  reflective,
  earlyBird,
  nightOwl,
}

class Achievement {
  const Achievement({
    required this.id,
    required this.current,
    required this.target,
  });

  final AchievementId id;
  final int current;
  final int target;

  bool get unlocked => current >= target;
  double get progress => target <= 0 ? 1 : (current / target).clamp(0, 1);
}

class LevelInfo {
  const LevelInfo({
    required this.level,
    required this.xp,
    required this.levelStart,
    required this.nextLevel,
  });

  final int level;
  final int xp;
  final int levelStart;
  final int nextLevel;

  int get intoLevel => xp - levelStart;
  int get levelSpan => nextLevel - levelStart;
  double get progress => levelSpan <= 0 ? 1 : intoLevel / levelSpan;
}

class AchievementSummary {
  const AchievementSummary({
    required this.achievements,
    required this.level,
    required this.checkIns,
    required this.bestStreak,
    required this.perfectDays,
  });

  final List<Achievement> achievements;
  final LevelInfo level;
  final int checkIns;
  final int bestStreak;
  final int perfectDays;

  int get unlockedCount => achievements.where((item) => item.unlocked).length;
}

const _xpPerCheckIn = 10;
const _xpPerAchievement = 50;

/// Level 1 starts at 0 XP and each level costs 100 XP more than the last.
LevelInfo levelFor(int xp) {
  var level = 1;
  var start = 0;
  var cost = 100;
  while (xp >= start + cost) {
    start += cost;
    level += 1;
    cost += 100;
  }
  return LevelInfo(
    level: level,
    xp: xp,
    levelStart: start,
    nextLevel: start + cost,
  );
}

AchievementSummary evaluateAchievements({
  required List<Habit> habits,
  required List<HabitCompletion> completions,
  required CalendarDate today,
  required int weekStart,
  int reflections = 0,
}) {
  final checkIns = totalCheckIns(habits: habits, completions: completions);
  const calculator = StreakCalculator();
  var bestStreak = 0;
  for (final habit in habits) {
    final streak = calculator.calculate(
      habit: habit.schedule,
      completions: {
        for (final item in completions)
          if (item.habitId == habit.id) item.date: item.value,
      },
      today: today.iso,
      weekStart: weekStart,
    );
    if (streak.best > bestStreak) bestStreak = streak.best;
  }

  final year = recentDayCounts(
    habits: habits,
    completions: completions,
    today: today,
    days: 365,
  );
  var perfect = 0;
  var run = 0;
  var bestRun = 0;
  for (final counts in year) {
    if (counts.due > 0 && counts.done == counts.due) {
      perfect += 1;
      run += 1;
      if (run > bestRun) bestRun = run;
    } else if (counts.due > 0) {
      run = 0;
    }
  }

  final targets = {for (final habit in habits) habit.id: habit.targetValue};
  final counted = [
    for (final item in completions)
      if (targets[item.habitId] case final target? when item.value >= target)
        item,
  ];
  final notes =
      completions
          .where((item) => !CompletionNote.decode(item.note).isEmpty)
          .length +
      reflections;
  final early = counted.any((item) => item.createdAt.toLocal().hour < 8);
  final late = counted.any((item) => item.createdAt.toLocal().hour >= 22);

  final achievements = [
    Achievement(id: AchievementId.firstStep, current: checkIns, target: 1),
    Achievement(id: AchievementId.streak3, current: bestStreak, target: 3),
    Achievement(id: AchievementId.streak7, current: bestStreak, target: 7),
    Achievement(id: AchievementId.streak30, current: bestStreak, target: 30),
    Achievement(id: AchievementId.perfectDay, current: perfect, target: 1),
    Achievement(id: AchievementId.perfectWeek, current: bestRun, target: 7),
    Achievement(id: AchievementId.checkIns50, current: checkIns, target: 50),
    Achievement(id: AchievementId.checkIns100, current: checkIns, target: 100),
    Achievement(
      id: AchievementId.habitBuilder,
      current: habits.length,
      target: 5,
    ),
    Achievement(id: AchievementId.reflective, current: notes, target: 10),
    Achievement(id: AchievementId.earlyBird, current: early ? 1 : 0, target: 1),
    Achievement(id: AchievementId.nightOwl, current: late ? 1 : 0, target: 1),
  ];
  final unlocked = achievements.where((item) => item.unlocked).length;
  return AchievementSummary(
    achievements: achievements,
    level: levelFor(checkIns * _xpPerCheckIn + unlocked * _xpPerAchievement),
    checkIns: checkIns,
    bestStreak: bestStreak,
    perfectDays: perfect,
  );
}
