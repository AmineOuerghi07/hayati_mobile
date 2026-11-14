// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Habit _$HabitFromJson(Map<String, dynamic> json) => _Habit(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  name: json['name'] as String,
  icon: json['icon'] as String,
  colorKey: json['colorKey'] as String,
  type: $enumDecode(_$HabitTypeEnumMap, json['type']),
  targetValue: (json['targetValue'] as num?)?.toDouble() ?? 1,
  unit: json['unit'] as String?,
  frequencyType: $enumDecode(_$FrequencyTypeEnumMap, json['frequencyType']),
  weekdays:
      (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  timesPerWeek: (json['timesPerWeek'] as num?)?.toInt() ?? 1,
  reminderTime: (json['reminderTime'] as num?)?.toInt(),
  partOfDay: $enumDecodeNullable(_$PartOfDayEnumMap, json['partOfDay']),
  startDate: json['startDate'] as String,
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HabitToJson(_Habit instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'name': instance.name,
  'icon': instance.icon,
  'colorKey': instance.colorKey,
  'type': _$HabitTypeEnumMap[instance.type]!,
  'targetValue': instance.targetValue,
  'unit': instance.unit,
  'frequencyType': _$FrequencyTypeEnumMap[instance.frequencyType]!,
  'weekdays': instance.weekdays,
  'timesPerWeek': instance.timesPerWeek,
  'reminderTime': instance.reminderTime,
  'partOfDay': _$PartOfDayEnumMap[instance.partOfDay],
  'startDate': instance.startDate,
  'archivedAt': instance.archivedAt?.toIso8601String(),
  'sortOrder': instance.sortOrder,
};

const _$HabitTypeEnumMap = {
  HabitType.boolean: 'boolean',
  HabitType.quantity: 'quantity',
};

const _$FrequencyTypeEnumMap = {
  FrequencyType.daily: 'daily',
  FrequencyType.weekdays: 'weekdays',
  FrequencyType.timesPerWeek: 'timesPerWeek',
};

const _$PartOfDayEnumMap = {
  PartOfDay.morning: 'morning',
  PartOfDay.afternoon: 'afternoon',
  PartOfDay.evening: 'evening',
};
