import 'dart:math';

import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// A short burst of soft dots and a single line of encouragement.
///
/// Pointers pass through so the undo action under it still works.
class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({required this.message, super.key});

  final String message;

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final fade = t < 0.7 ? 1.0 : (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0);
          return Opacity(
            opacity: fade,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _BurstPainter(t: t, color: scheme.primary),
                ),
                Center(child: child),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: tokens.space24),
          child: Material(
            color: tokens.cardTint,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radiusCard),
              side: BorderSide(color: scheme.primary.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.all(tokens.space16),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(4);
    for (var index = 0; index < 26; index++) {
      final x = random.nextDouble() * size.width;
      final start = size.height * (0.15 + random.nextDouble() * 0.35);
      final drift = (random.nextDouble() - 0.5) * 36;
      final y = start + t * size.height * 0.42;
      final paint = Paint()..color = color.withValues(alpha: (1 - t) * 0.8);
      canvas.drawCircle(
        Offset(x + drift * t, y),
        2.5 + random.nextDouble() * 2.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => oldDelegate.t != t;
}
