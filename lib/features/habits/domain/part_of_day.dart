/// When a habit belongs in the day. Null on a habit means "any time",
/// unless a reminder hour implies a part.
enum PartOfDay { morning, afternoon, evening }

/// Morning is 5–11, afternoon is 12–16, and evening is everything else.
PartOfDay partOfDayAt(int hour) {
  if (hour >= 5 && hour < 12) return PartOfDay.morning;
  if (hour >= 12 && hour < 17) return PartOfDay.afternoon;
  return PartOfDay.evening;
}

/// The part the user picked, or the one implied by a reminder.
PartOfDay? resolvedPartOfDay({PartOfDay? chosen, int? reminderMinutes}) {
  if (chosen != null) return chosen;
  if (reminderMinutes == null) return null;
  return partOfDayAt((reminderMinutes ~/ 60) % 24);
}
