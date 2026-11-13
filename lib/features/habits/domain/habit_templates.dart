import 'package:hayati/features/habits/domain/habit_schedule.dart';

/// A starter habit offered during the introduction and in the editor.
class HabitTemplate {
  const HabitTemplate({
    required this.id,
    required this.icon,
    required this.colorKey,
    required this.type,
    this.targetValue = 1,
    this.unit,
  });

  final String id;
  final String icon;
  final String colorKey;
  final HabitType type;
  final double targetValue;
  final String? unit;
}

const habitTemplates = <HabitTemplate>[
  HabitTemplate(
    id: 'water',
    icon: 'water',
    colorKey: 'sea',
    type: HabitType.quantity,
    targetValue: 8,
    unit: 'glasses',
  ),
  HabitTemplate(
    id: 'read',
    icon: 'book',
    colorKey: 'dusk',
    type: HabitType.quantity,
    targetValue: 10,
    unit: 'pages',
  ),
  HabitTemplate(
    id: 'walk',
    icon: 'walk',
    colorKey: 'dawn',
    type: HabitType.quantity,
    targetValue: 20,
    unit: 'minutes',
  ),
  HabitTemplate(
    id: 'pray',
    icon: 'heart',
    colorKey: 'hayati',
    type: HabitType.boolean,
  ),
  HabitTemplate(
    id: 'sleep',
    icon: 'sleep',
    colorKey: 'ink',
    type: HabitType.boolean,
  ),
  HabitTemplate(
    id: 'journal',
    icon: 'star',
    colorKey: 'blossom',
    type: HabitType.boolean,
  ),
];

HabitTemplate templateById(String id) {
  return habitTemplates.firstWhere((template) => template.id == id);
}
