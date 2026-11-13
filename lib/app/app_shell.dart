import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex ==
        widget.navigationShell.currentIndex) {
      return;
    }
    playHaptic();
    if (MediaQuery.disableAnimationsOf(context)) {
      _fade.value = 1;
      return;
    }
    _fade.forward(from: 0);
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final shell = widget.navigationShell;

    final destinations = [
      (Icons.today_outlined, Icons.today, l10n.today),
      (Icons.insights_outlined, Icons.insights, l10n.stats),
      (Icons.person_outline, Icons.person, l10n.profile),
    ];
    void select(int index) {
      shell.goBranch(index, initialLocation: index == shell.currentIndex);
    }

    final content = AnimatedBuilder(
      animation: _fade,
      builder: (context, child) {
        if (reduce) return child!;
        final t = Curves.easeOutCubic.transform(_fade.value);
        return Opacity(
          opacity: 0.4 + (0.6 * t),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 12),
            child: child,
          ),
        );
      },
      child: shell,
    );

    if (!isCompactWidth(context)) {
      final scheme = Theme.of(context).colorScheme;
      final wideRail = MediaQuery.sizeOf(context).width >= 1200;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: select,
              extended: wideRail,
              labelType: wideRail
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              backgroundColor: scheme.surface,
              indicatorColor: scheme.primary.withValues(alpha: 0.16),
              groupAlignment: -0.85,
              leading: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [scheme.primary, scheme.tertiary],
                    ),
                  ),
                  child: const Icon(Icons.spa_rounded, color: Colors.white),
                ),
              ),
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: _BounceIcon(selected),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: select,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: _BounceIcon(selected),
              label: label,
            ),
        ],
      ),
    );
  }
}

/// Springs in each time its destination becomes selected.
class _BounceIcon extends StatelessWidget {
  const _BounceIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return Icon(icon);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, t, child) {
        final scale = 0.7 + 0.3 * Curves.elasticOut.transform(t);
        return Transform.translate(
          offset: Offset(0, -3 * (1 - Curves.easeOut.transform(t))),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Icon(icon),
    );
  }
}

/// Slide-up transition for the editor and habit detail.
CustomTransitionPage<void> slideUpPage({
  required LocalKey pageKey,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: HayatiTokens.fallback.motionMedium,
    reverseTransitionDuration: HayatiTokens.fallback.motionFast,
    transitionsBuilder: (context, animation, secondary, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
      final curved = CurvedAnimation(
        parent: animation,
        curve: HayatiTokens.of(context).easeOut,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
