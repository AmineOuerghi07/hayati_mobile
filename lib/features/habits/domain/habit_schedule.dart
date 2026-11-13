/// How a habit is completed and on which days it is due.
enum HabitType { boolean, quantity }

enum FrequencyType { daily, weekdays, timesPerWeek }

/// The fields the streak calculator needs. Kept separate from the stored
/// habit so the rules can be tested without the database.
class HabitSchedule {
  const HabitSchedule({
    required this.type,
    required this.frequencyType,
    required this.startDate,
    this.weekdays = const [],
    this.timesPerWeek = 1,
    this.targetValue = 1,
    this.archivedOn,
  });

  final HabitType type;
  final FrequencyType frequencyType;

  /// ISO weekdays, 1 = Monday through 7 = Sunday. Used by [FrequencyType.weekdays].
  final List<int> weekdays;

  /// Completions required inside one week. Used by [FrequencyType.timesPerWeek].
  final int timesPerWeek;

  /// A day counts when the logged value reaches this. Boolean habits use 1.
  final double targetValue;

  final String startDate;

  /// Local calendar day the habit was archived, if it was.
  final String? archivedOn;
}

class Streak {
  const Streak({required this.current, required this.best});

  final int current;
  final int best;
}
