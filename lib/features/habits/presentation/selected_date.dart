import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';

class SelectedDateController extends Notifier<CalendarDate> {
  @override
  CalendarDate build() => CalendarDate.today();

  void select(CalendarDate date) {
    if (date > CalendarDate.today()) return;
    state = date;
  }

  void jumpToToday() => state = CalendarDate.today();
}

final selectedDateProvider =
    NotifierProvider<SelectedDateController, CalendarDate>(
      SelectedDateController.new,
    );

/// Days that already played the "everything is done" burst this session.
class CelebratedDays extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    ref.keepAlive();
    return const {};
  }

  bool claim(String iso) {
    if (state.contains(iso)) return false;
    state = {...state, iso};
    return true;
  }
}

final celebratedDaysProvider = NotifierProvider<CelebratedDays, Set<String>>(
  CelebratedDays.new,
);
