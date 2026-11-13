import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Minutes after local midnight, or null if the user dismissed the picker.
Future<int?> showReminderPicker(
  BuildContext context, {
  required int? currentMinutes,
}) async {
  final l10n = AppLocalizations.of(context);
  final initialMinutes = currentMinutes ?? 8 * 60;
  final initial = TimeOfDay(
    hour: initialMinutes ~/ 60,
    minute: initialMinutes % 60,
  );

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    var selected = DateTime(2026, 1, 1, initial.hour, initial.minute);
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      onPressed: () => Navigator.pop(
                        context,
                        selected.hour * 60 + selected.minute,
                      ),
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selected,
                  onDateTimeChanged: (value) => selected = value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final picked = await showTimePicker(context: context, initialTime: initial);
  if (picked == null) return null;
  return picked.hour * 60 + picked.minute;
}

String formatReminder(BuildContext context, int? minutes) {
  if (minutes == null) return AppLocalizations.of(context).reminderNone;
  return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);
}
