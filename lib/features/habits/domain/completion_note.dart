/// A mood and a few words stored in the existing completion note column.
///
/// The mood is a prefix (`mood:3|text`) so older plain notes still read back.
class CompletionNote {
  const CompletionNote({this.mood, this.text = ''});

  /// 1 is the lowest mood and 5 is the highest.
  final int? mood;
  final String text;

  static final _pattern = RegExp(r'^mood:([1-5])\|(.*)$', dotAll: true);

  factory CompletionNote.decode(String? raw) {
    if (raw == null || raw.isEmpty) return const CompletionNote();
    final match = _pattern.firstMatch(raw);
    if (match == null) return CompletionNote(text: raw);
    return CompletionNote(
      mood: int.parse(match.group(1)!),
      text: match.group(2)!,
    );
  }

  bool get isEmpty => _validMood == null && text.trim().isEmpty;

  int? get _validMood {
    final value = mood;
    if (value == null || value < 1 || value > 5) return null;
    return value;
  }

  /// Null when there is nothing to store, so the column can be cleared.
  String? encode() {
    final body = text.trim();
    final storedMood = _validMood;
    if (storedMood == null && body.isEmpty) return null;
    if (storedMood == null) return body;
    return 'mood:$storedMood|$body';
  }

  @override
  bool operator ==(Object other) {
    return other is CompletionNote && other.mood == mood && other.text == text;
  }

  @override
  int get hashCode => Object.hash(mood, text);
}
