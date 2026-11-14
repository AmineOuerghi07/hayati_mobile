import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showNameSheet(BuildContext context, WidgetRef ref) async {
  final session =
      ref.read(authSessionProvider).value ?? const AuthSession.guest();
  final guest =
      ref.read(preferencesControllerProvider).value?.displayName ?? '';
  final initial = session.user?.displayName ?? guest;
  final saved = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _NameSheet(initial: initial),
  );
  final name = saved?.trim() ?? '';
  if (name.isEmpty) return;
  if (session.user != null) {
    await ref.read(authRepositoryProvider).updateDisplayName(name);
    return;
  }
  await ref.read(preferencesControllerProvider.notifier).setDisplayName(name);
}

/// Owns the field controller so it stays alive through the sheet's
/// closing animation. Disposing it as soon as the route pops makes the
/// field rebuild against a dead controller.
class _NameSheet extends StatefulWidget {
  const _NameSheet({required this.initial});

  final String initial;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _name.dispose();
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
          Text(l10n.yourName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.displayName),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context, _name.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
