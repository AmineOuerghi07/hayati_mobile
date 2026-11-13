import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// Fades and lifts [child] the first time it is built.
class StaggeredItem extends StatelessWidget {
  const StaggeredItem({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final tokens = HayatiTokens.of(context);
    final duration = tokens.motionMedium + Duration(milliseconds: index * 35);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      builder: (context, t, child) {
        final start = (index * 0.05).clamp(0.0, 0.45);
        final local = ((t - start) / (1 - start)).clamp(0.0, 1.0);
        final eased = Curves.easeOutCubic.transform(local);
        return Opacity(
          opacity: eased == 0 ? 0.01 : eased,
          child: Transform.translate(
            offset: Offset(0, (1 - eased) * 10),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
