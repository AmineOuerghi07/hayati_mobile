import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

/// A habit stored on the device. Timestamps are UTC. [startDate] is a local
/// calendar day (`yyyy-MM-dd`), because that is what streaks are made of.
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String name,
    required String icon,
    required String colorKey,
    required HabitType type,
    @Default(1) double targetValue,
    String? unit,
    required FrequencyType frequencyType,
    @Default(<int>[]) List<int> weekdays,
    @Default(1) int timesPerWeek,
    int? reminderTime,
    required String startDate,
    DateTime? archivedAt,
    @Default(0) int sortOrder,
  }) = _Habit;

  const Habit._();

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  bool get isDeleted => deletedAt != null;

  bool get isArchived => archivedAt != null;

  /// A counter on Today, rather than a single check.
  ///
  /// Quantity is stored either as the habit type or as a target above one.
  bool get tracksQuantity =>
      type == HabitType.quantity ||
      targetValue > 1 ||
      (unit != null && unit!.trim().isNotEmpty);

  HabitSchedule get schedule => HabitSchedule(
    type: type,
    frequencyType: frequencyType,
    startDate: startDate,
    weekdays: weekdays,
    timesPerWeek: timesPerWeek,
    targetValue: targetValue,
    archivedOn: archivedAt == null
        ? null
        : CalendarDate.fromDateTime(archivedAt!).iso,
  );
}

/// Fields the user edits. The repository fills in the id and timestamps.
class HabitDraft {
  const HabitDraft({
    required this.name,
    required this.icon,
    required this.colorKey,
    required this.type,
    this.targetValue = 1,
    this.unit,
    required this.frequencyType,
    this.weekdays = const [],
    this.timesPerWeek = 1,
    this.reminderTime,
    required this.startDate,
  });

  final String name;
  final String icon;
  final String colorKey;
  final HabitType type;
  final double targetValue;
  final String? unit;
  final FrequencyType frequencyType;
  final List<int> weekdays;
  final int timesPerWeek;
  final int? reminderTime;
  final String startDate;

  String? get nameError => name.trim().isEmpty ? 'required' : null;
}
