import 'package:hayati/features/habits/domain/completion_note.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<CompletionNote?> showNoteSheet(
  BuildContext context, {
  required CompletionNote initial,
}) {
  return showModalBottomSheet<CompletionNote>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _NoteSheet(initial: initial),
  );
}

class _NoteSheet extends StatefulWidget {
  const _NoteSheet({required this.initial});

  final CompletionNote initial;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final TextEditingController _text;
  late int? _mood;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.initial.text);
    _mood = widget.initial.mood;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.noteTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(l10n.moodLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var mood = 1; mood <= 5; mood++)
                Expanded(
                  child: IconButton(
                    tooltip: moodLabel(l10n, mood),
                    isSelected: _mood == mood,
                    onPressed: () => setState(() {
                      _mood = _mood == mood ? null : mood;
                    }),
                    icon: Icon(
                      _moodIcon(mood),
                      color: _mood == mood
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.noteTitle),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  CompletionNote(mood: _mood, text: _text.text),
                );
              },
              child: Text(l10n.saveNote),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _moodIcon(int mood) {
  return switch (mood) {
    1 => Icons.sentiment_very_dissatisfied_outlined,
    2 => Icons.sentiment_dissatisfied_outlined,
    3 => Icons.sentiment_neutral_outlined,
    4 => Icons.sentiment_satisfied_outlined,
    _ => Icons.sentiment_very_satisfied_outlined,
  };
}

IconData moodIconFor(int mood) => _moodIcon(mood);
