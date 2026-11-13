import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.today, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(l10n.todayPlaceholder),
          ],
        ),
      ),
    );
  }
}
