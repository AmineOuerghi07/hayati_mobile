/// A local calendar day, with no time and no timezone.
///
/// Completions belong to one of these, so a flight across timezones cannot
/// split or merge a streak. Arithmetic goes through UTC noon to avoid DST.
class CalendarDate implements Comparable<CalendarDate> {
  const CalendarDate(this.year, this.month, this.day);

  factory CalendarDate.parse(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) {
      throw FormatException('Expected yyyy-MM-dd, got $iso');
    }
    return CalendarDate(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  factory CalendarDate.fromDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return CalendarDate(local.year, local.month, local.day);
  }

  factory CalendarDate.today() => CalendarDate.fromDateTime(DateTime.now());

  final int year;
  final int month;
  final int day;

  /// Monday is 1 and Sunday is 7, matching [DateTime.weekday].
  int get weekday => _utc.weekday;

  String get iso =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  CalendarDate addDays(int days) {
    final shifted = _utc.add(Duration(days: days));
    return CalendarDate(shifted.year, shifted.month, shifted.day);
  }

  /// First day of the week that contains this date.
  ///
  /// [weekStart] uses the same 1–7 numbering as [weekday].
  CalendarDate startOfWeek(int weekStart) {
    final delta = (weekday - weekStart) % 7;
    final back = delta < 0 ? delta + 7 : delta;
    return addDays(-back);
  }

  DateTime get _utc => DateTime.utc(year, month, day, 12);

  @override
  int compareTo(CalendarDate other) => iso.compareTo(other.iso);

  bool operator <(CalendarDate other) => compareTo(other) < 0;
  bool operator <=(CalendarDate other) => compareTo(other) <= 0;
  bool operator >(CalendarDate other) => compareTo(other) > 0;
  bool operator >=(CalendarDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) => other is CalendarDate && other.iso == iso;

  @override
  int get hashCode => iso.hashCode;

  @override
  String toString() => iso;
}
