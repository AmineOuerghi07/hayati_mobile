enum DataChoice { merge, keepAccount, keepDevice, fresh }

class ScopeCounts {
  const ScopeCounts({required this.habits, required this.checkIns});

  final int habits;
  final int checkIns;

  bool get hasData => habits > 0 || checkIns > 0;

  static const empty = ScopeCounts(habits: 0, checkIns: 0);
}
