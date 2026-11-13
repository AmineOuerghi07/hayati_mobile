import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Breathe and Focus side by side.
class ToolCards extends StatelessWidget {
  const ToolCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ToolCard(
              icon: Icons.air_rounded,
              colors: const [Color(0xFF7DD3FC), Color(0xFF0284C7)],
              title: l10n.breatheTitle,
              subtitle: l10n.breatheShort,
              onTap: () => context.push('/breathe'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ToolCard(
              icon: Icons.timer_outlined,
              colors: const [Color(0xFFFDBA74), Color(0xFFEA580C)],
              title: l10n.focusTitle,
              subtitle: l10n.focusShort,
              onTap: () => context.push('/focus'),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.icon,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final List<Color> colors;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    final theme = Theme.of(context);
    return SoftCard(
      onTap: onTap,
      tint: Color.alphaBlend(
        colors.last.withValues(alpha: 0.07),
        tokens.cardTint,
      ),
      padding: const EdgeInsetsDirectional.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
