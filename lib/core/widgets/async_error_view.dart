import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// A short, shared failure state. The raw error stays out of the layout.
class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.somethingWentWrong, textAlign: TextAlign.center),
      ),
    );
  }
}
