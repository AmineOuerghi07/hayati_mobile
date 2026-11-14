import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/auth/domain/data_choice.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<DataChoice?> showDataChoiceSheet(
  BuildContext context, {
  required ScopeCounts here,
  required ScopeCounts account,
  required bool accountHasData,
}) {
  return showModalBottomSheet<DataChoice>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    builder: (context) => PopScope(
      canPop: false,
      child: DataChoiceSheet(
        here: here,
        account: account,
        accountHasData: accountHasData,
      ),
    ),
  );
}

class DataChoiceSheet extends StatefulWidget {
  const DataChoiceSheet({
    required this.here,
    required this.account,
    required this.accountHasData,
    super.key,
  });

  final ScopeCounts here;
  final ScopeCounts account;
  final bool accountHasData;

  @override
  State<DataChoiceSheet> createState() => _DataChoiceSheetState();
}

class _DataChoiceSheetState extends State<DataChoiceSheet> {
  DataChoice? _confirming;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final pending = _confirming;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 20 + bottom),
      child: pending == null
          ? _Options(
              here: widget.here,
              account: widget.account,
              accountHasData: widget.accountHasData,
              onPick: (choice) {
                if (choice == DataChoice.merge) {
                  Navigator.pop(context, choice);
                  return;
                }
                setState(() => _confirming = choice);
              },
            )
          : _Confirm(
              onBack: () => setState(() => _confirming = null),
              onConfirm: () => Navigator.pop(context, pending),
              title: l10n.dataChoiceConfirm,
              body: _confirmBody(l10n, pending),
            ),
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({
    required this.here,
    required this.account,
    required this.accountHasData,
    required this.onPick,
  });

  final ScopeCounts here;
  final ScopeCounts account;
  final bool accountHasData;
  final ValueChanged<DataChoice> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final choices = accountHasData
        ? DataChoice.values
        : const [DataChoice.merge, DataChoice.fresh];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.dataChoiceTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          l10n.scopeCounts(here.habits, here.checkIns),
          style: theme.textTheme.bodyMedium,
        ),
        if (accountHasData)
          Text(
            l10n.accountScopeCounts(account.habits, account.checkIns),
            style: theme.textTheme.bodyMedium,
          ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          itemCount: choices.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final choice = choices[index];
            final (icon, title, body) = _copy(l10n, choice);
            return SoftCard(
              onTap: () => onPick(choice),
              child: Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(body, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Confirm extends StatelessWidget {
  const _Confirm({
    required this.title,
    required this.body,
    required this.onBack,
    required this.onConfirm,
  });

  final String title;
  final String body;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 36,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(body),
        const SizedBox(height: 16),
        FilledButton(onPressed: onConfirm, child: Text(l10n.dataChoiceConfirm)),
        TextButton(onPressed: onBack, child: Text(l10n.dataChoiceGoBack)),
      ],
    );
  }
}

(IconData, String, String) _copy(AppLocalizations l10n, DataChoice choice) {
  return switch (choice) {
    DataChoice.merge => (
      Icons.merge_rounded,
      l10n.dataChoiceMerge,
      l10n.dataChoiceMergeBody,
    ),
    DataChoice.keepAccount => (
      Icons.cloud_done_outlined,
      l10n.dataChoiceKeepAccount,
      l10n.dataChoiceKeepAccountBody,
    ),
    DataChoice.keepDevice => (
      Icons.phonelink_setup_rounded,
      l10n.dataChoiceKeepDevice,
      l10n.dataChoiceKeepDeviceBody,
    ),
    DataChoice.fresh => (
      Icons.spa_outlined,
      l10n.dataChoiceFresh,
      l10n.dataChoiceFreshBody,
    ),
  };
}

String _confirmBody(AppLocalizations l10n, DataChoice choice) {
  return switch (choice) {
    DataChoice.keepAccount => l10n.dataChoiceKeepAccountBody,
    DataChoice.keepDevice => l10n.dataChoiceKeepDeviceBody,
    DataChoice.fresh => l10n.dataChoiceFreshBody,
    DataChoice.merge => l10n.dataChoiceMergeBody,
  };
}
