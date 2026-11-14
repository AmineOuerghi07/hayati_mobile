import 'package:flutter_test/flutter_test.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/achievements/domain/achievements.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_completion.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/tools/presentation/breathe_page.dart';

void main() {
  test('each level costs 100 XP more than the last', () {
    expect(levelFor(0).level, 1);
    expect(levelFor(99).level, 1);
    expect(levelFor(100).level, 2);
    expect(levelFor(299).level, 2);
    final third = levelFor(300);
    expect(third.level, 3);
    expect(third.levelStart, 300);
    expect(third.nextLevel, 600);
    expect(levelFor(450).progress, closeTo(0.5, 0.001));
  });

  test('achievements unlock from streaks and check-ins', () {
    final habit = Habit(
      id: 'read',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      name: 'Read',
      icon: 'book',
      colorKey: 'dusk',
      type: HabitType.boolean,
      frequencyType: FrequencyType.daily,
      startDate: '2026-01-01',
    );
    final today = CalendarDate(2026, 1, 10);
    final logged = [
      for (var back = 0; back < 3; back++)
        HabitCompletion(
          id: '$back',
          createdAt: DateTime(2026, 1, 10, 12),
          updatedAt: DateTime(2026, 1, 10, 12),
          habitId: habit.id,
          date: today.addDays(-back).iso,
          value: 1,
        ),
    ];

    final summary = evaluateAchievements(
      habits: [habit],
      completions: logged,
      today: today,
      weekStart: DateTime.monday,
    );
    bool unlocked(AchievementId id) =>
        summary.achievements.firstWhere((item) => item.id == id).unlocked;

    expect(summary.checkIns, 3);
    expect(summary.bestStreak, 3);
    expect(unlocked(AchievementId.firstStep), isTrue);
    expect(unlocked(AchievementId.streak3), isTrue);
    expect(unlocked(AchievementId.perfectDay), isTrue);
    expect(unlocked(AchievementId.streak7), isFalse);
    expect(unlocked(AchievementId.earlyBird), isFalse);
    expect(summary.level.xp, 3 * 10 + summary.unlockedCount * 50);

    final empty = evaluateAchievements(
      habits: const [],
      completions: const [],
      today: today,
      weekStart: DateTime.monday,
    );
    expect(empty.unlockedCount, 0);
    expect(empty.level.level, 1);
  });

  test('the breathing cycle moves through inhale, hold, and exhale', () {
    final calm = breathPatterns.first;
    expect(calm.seconds, 14);
    expect(breathPhaseAt(calm, 0).phase, BreathPhase.inhale);
    expect(breathPhaseAt(calm, 2 / 14).within, closeTo(0.5, 0.001));
    expect(breathPhaseAt(calm, 5 / 14).phase, BreathPhase.hold);
    expect(breathPhaseAt(calm, 11 / 14).phase, BreathPhase.exhale);
    expect(breathPhaseAt(calm, 1).within, 1);
    expect(breathPatterns[1].seconds, 16);
    expect(breathPhaseAt(breathPatterns[1], 0.9).phase, BreathPhase.hold);
  });
}
