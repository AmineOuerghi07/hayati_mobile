/// A mood and a few words stored in the existing completion note column.
///
/// The mood is a prefix (`mood:3|text`) so older plain notes still read back.
class CompletionNote {
  const CompletionNote({this.mood, this.text = '', this.skipped = false});

  /// 1 is the lowest mood and 5 is the highest.
  final int? mood;
  final String text;

  /// A planned pass for this day. The streak pauses instead of resetting.
  final bool skipped;

  static final _pattern = RegExp(r'^mood:([1-5])\|(.*)$', dotAll: true);
  static const _skipPrefix = 'skip:1|';

  factory CompletionNote.decode(String? raw) {
    if (raw == null || raw.isEmpty) return const CompletionNote();
    if (raw.startsWith(_skipPrefix)) {
      final rest = raw.substring(_skipPrefix.length);
      final inner = CompletionNote.decode(rest.isEmpty ? null : rest);
      return CompletionNote(mood: inner.mood, text: inner.text, skipped: true);
    }
    final match = _pattern.firstMatch(raw);
    if (match == null) return CompletionNote(text: raw);
    return CompletionNote(
      mood: int.parse(match.group(1)!),
      text: match.group(2)!,
    );
  }

  bool get isEmpty => !skipped && _validMood == null && text.trim().isEmpty;

  int? get _validMood {
    final value = mood;
    if (value == null || value < 1 || value > 5) return null;
    return value;
  }

  /// Null when there is nothing to store, so the column can be cleared.
  String? encode() {
    final body = text.trim();
    final storedMood = _validMood;
    String? core;
    if (storedMood == null && body.isEmpty) {
      core = null;
    } else if (storedMood == null) {
      core = body;
    } else {
      core = 'mood:$storedMood|$body';
    }
    if (!skipped) return core;
    return '$_skipPrefix${core ?? ''}';
  }

  @override
  bool operator ==(Object other) {
    return other is CompletionNote &&
        other.mood == mood &&
        other.text == text &&
        other.skipped == skipped;
  }

  @override
  int get hashCode => Object.hash(mood, text, skipped);
}
