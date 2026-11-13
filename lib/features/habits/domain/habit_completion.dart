import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_completion.freezed.dart';
part 'habit_completion.g.dart';

/// One logged value for a habit on a local calendar [date] (`yyyy-MM-dd`).
@freezed
abstract class HabitCompletion with _$HabitCompletion {
  const factory HabitCompletion({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String habitId,
    required String date,
    @Default(1) double value,
    String? note,
    DateTime? completedAt,
  }) = _HabitCompletion;

  factory HabitCompletion.fromJson(Map<String, dynamic> json) =>
      _$HabitCompletionFromJson(json);
}
