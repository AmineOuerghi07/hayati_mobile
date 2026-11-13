import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class RingValue {
  const RingValue({required this.value, required this.color});

  /// Null when nothing was due.
  final double? value;
  final Color color;
}

/// Nested rings, outermost first, that sweep in together.
class ConcentricRings extends StatelessWidget {
  const ConcentricRings({
    required this.rings,
    required this.semanticsLabel,
    this.size = 140,
    this.strokeWidth = 13,
    this.center,
    super.key,
  });

  final List<RingValue> rings;
  final String semanticsLabel;
  final double size;
  final double strokeWidth;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final track = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: reduce ? 1 : 0, end: 1),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return CustomPaint(
              painter: _RingsPainter(
                rings: rings,
                t: t,
                track: track,
                strokeWidth: strokeWidth,
              ),
              child: child,
            );
          },
          child: center == null
              ? null
              : Padding(
                  padding: EdgeInsets.all(
                    strokeWidth * rings.length + strokeWidth * 0.6,
                  ),
                  child: FittedBox(fit: BoxFit.scaleDown, child: center),
                ),
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({
    required this.rings,
    required this.t,
    required this.track,
    required this.strokeWidth,
  });

  final List<RingValue> rings;
  final double t;
  final Color track;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final gap = strokeWidth * 0.25;
    for (var index = 0; index < rings.length; index++) {
      final inset = strokeWidth / 2 + index * (strokeWidth + gap);
      final rect = Rect.fromLTWH(
        inset,
        inset,
        size.width - inset * 2,
        size.height - inset * 2,
      );
      if (rect.width <= 0) continue;
      final ring = rings[index];
      canvas.drawArc(
        rect,
        0,
        math.pi * 2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = ring.color.withValues(alpha: 0.16),
      );
      final delay = index * 0.12;
      final local = ((t - delay) / (1 - delay)).clamp(0.0, 1.0);
      final sweep = (ring.value ?? 0).clamp(0.0, 1.0) * local;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = sweep >= 0.999 ? StrokeCap.butt : StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: math.pi * 1.5,
          colors: [Color.lerp(ring.color, Colors.white, 0.25)!, ring.color],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect);
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.rings != rings ||
        oldDelegate.track != track;
  }
}
