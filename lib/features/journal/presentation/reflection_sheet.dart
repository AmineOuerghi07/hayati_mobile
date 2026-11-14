import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/note_sheet.dart';
import 'package:hayati/features/journal/domain/daily_reflection.dart';
import 'package:hayati/features/journal/presentation/reflection_providers.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showReflectionSheet(
  BuildContext context,
  WidgetRef ref, {
  DailyReflection? existing,
  String? date,
}) async {
  final saved = await showModalBottomSheet<_Draft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ReflectionSheet(existing: existing),
  );
  if (saved == null) return;
  await ref
      .read(reflectionRepositoryProvider)
      .save(
        date: date ?? existing?.date ?? CalendarDate.today().iso,
        mood: saved.mood,
        gratitude: saved.gratitude,
        note: saved.note,
      );
}

class _Draft {
  const _Draft({this.mood, this.gratitude = '', this.note = ''});

  final int? mood;
  final String gratitude;
  final String note;
}

class _ReflectionSheet extends StatefulWidget {
  const _ReflectionSheet({this.existing});

  final DailyReflection? existing;

  @override
  State<_ReflectionSheet> createState() => _ReflectionSheetState();
}

class _ReflectionSheetState extends State<_ReflectionSheet> {
  late final TextEditingController _gratitude = TextEditingController(
    text: widget.existing?.gratitude ?? '',
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.existing?.note ?? '',
  );
  late int? _mood = widget.existing?.mood;

  @override
  void dispose() {
    _gratitude.dispose();
    _note.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.reflectionPrompt,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(l10n.reflectionBody),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var mood = 1; mood <= 5; mood++)
                Expanded(
                  child: IconButton(
                    tooltip: moodLabel(l10n, mood),
                    onPressed: () => setState(() {
                      _mood = _mood == mood ? null : mood;
                    }),
                    icon: Icon(
                      moodIconFor(mood),
                      color: _mood == mood
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
            ],
          ),
          TextField(
            controller: _gratitude,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.gratitudeLabel,
              hintText: l10n.gratitudeHint,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.reflectionNote),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              _Draft(mood: _mood, gratitude: _gratitude.text, note: _note.text),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
