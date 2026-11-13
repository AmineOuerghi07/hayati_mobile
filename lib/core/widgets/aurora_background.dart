import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Slowly drifting soft color glows. Static when the system reduces motion.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    required this.base,
    required this.colors,
    this.child,
    super.key,
  });

  final Color base;
  final List<Color> colors;
  final Widget? child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _drift.stop();
    } else if (!_drift.isAnimating) {
      _drift.repeat();
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _AuroraPainter(
          animation: _drift,
          base: widget.base,
          colors: widget.colors,
        ),
        child: widget.child,
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.animation,
    required this.base,
    required this.colors,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color base;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final t = animation.value * math.pi * 2;
    final radius = math.max(size.width, size.height) * 0.6;
    for (var index = 0; index < colors.length; index++) {
      final phase = index * 2.1;
      final center = Offset(
        size.width * (0.15 + 0.7 * (math.sin(t + phase) + 1) / 2),
        size.height * (0.2 + 0.6 * (math.cos(t * 0.8 + phase) + 1) / 2),
      );
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[index].withValues(alpha: 0.55),
            colors[index].withValues(alpha: 0),
          ],
        ).createShader(rect);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) {
    return oldDelegate.base != base || oldDelegate.colors != colors;
  }
}
