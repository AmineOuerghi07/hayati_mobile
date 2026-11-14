import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/settings/presentation/preferences_controller.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showNameSheet(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final session =
      ref.read(authSessionProvider).value ?? const AuthSession.guest();
  final guest =
      ref.read(preferencesControllerProvider).value?.displayName ?? '';
  final initial = session.user?.displayName ?? guest;
  final controller = TextEditingController(text: initial);
  final saved = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
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
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.displayName),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(l10n.save),
            ),
          ],
        ),
      );
    },
  );
  controller.dispose();
  final name = saved?.trim() ?? '';
  if (name.isEmpty) return;
  if (session.user != null) {
    await ref.read(authRepositoryProvider).updateDisplayName(name);
    return;
  }
  await ref.read(preferencesControllerProvider.notifier).setDisplayName(name);
}
