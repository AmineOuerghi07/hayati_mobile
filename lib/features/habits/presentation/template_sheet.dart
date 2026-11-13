import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/features/habits/domain/habit_templates.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showTemplateSheet(BuildContext context, WidgetRef ref) async {
  final selected = await showModalBottomSheet<HabitTemplate>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _TemplateList(),
  );
  if (selected == null || !context.mounted) return;
  await ref
      .read(habitRepositoryProvider)
      .create(
        draftFromTemplate(
          AppLocalizations.of(context),
          selected,
          startDate: CalendarDate.today().iso,
        ),
      );
}

class _TemplateList extends StatelessWidget {
  const _TemplateList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 8),
            child: Text(
              l10n.browseTemplates,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (final template in habitTemplates)
            ListTile(
              leading: Icon(
                habitIcon(template.icon),
                color: habitColor(template.colorKey),
              ),
              title: Text(templateTitle(l10n, template.id)),
              onTap: () => Navigator.pop(context, template),
            ),
        ],
      ),
    );
  }
}
