class DailyReflection {
  const DailyReflection({
    required this.id,
    required this.date,
    this.mood,
    this.gratitude,
    this.note,
  });

  final String id;
  final String date;
  final int? mood;
  final String? gratitude;
  final String? note;

  bool get isEmpty =>
      mood == null &&
      (gratitude == null || gratitude!.trim().isEmpty) &&
      (note == null || note!.trim().isEmpty);
}
