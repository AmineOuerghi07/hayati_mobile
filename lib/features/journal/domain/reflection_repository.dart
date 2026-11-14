import 'package:hayati/features/journal/domain/daily_reflection.dart';

abstract class ReflectionRepository {
  Stream<List<DailyReflection>> watchAll();

  Future<void> save({
    required String date,
    int? mood,
    String? gratitude,
    String? note,
  });
}
