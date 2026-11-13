import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder cards with a soft moving shine while data loads.
class SkeletonList extends StatefulWidget {
  const SkeletonList({this.count = 4, super.key});

  final int count;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _shine.stop();
    } else if (!_shine.isAnimating) {
      _shine.repeat();
    }
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final base = scheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final light = scheme.surfaceContainerLowest;
    return SafeArea(
      child: AnimatedBuilder(
        animation: _shine,
        builder: (context, _) {
          final x = _shine.value * 3 - 1;
          final shader = LinearGradient(
            begin: Alignment(x - 1, 0),
            end: Alignment(x + 1, 0),
            colors: [base, light, base],
          );
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.all(16),
            children: [
              _block(shader, 150, tokens.radiusSheet),
              const SizedBox(height: 16),
              for (var index = 0; index < widget.count; index++) ...[
                _block(shader, 72, tokens.radiusCard),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _block(Gradient gradient, double height, double radius) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
