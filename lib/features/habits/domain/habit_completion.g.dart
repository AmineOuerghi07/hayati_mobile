// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_completion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitCompletion _$HabitCompletionFromJson(Map<String, dynamic> json) =>
    _HabitCompletion(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      habitId: json['habitId'] as String,
      date: json['date'] as String,
      value: (json['value'] as num?)?.toDouble() ?? 1,
      note: json['note'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$HabitCompletionToJson(_HabitCompletion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'habitId': instance.habitId,
      'date': instance.date,
      'value': instance.value,
      'note': instance.note,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
