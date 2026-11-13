import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// A small plant that grows leaves as [progress] goes from 0 to 1 and
/// blooms when the day is complete. It sways gently while idle.
class GrowingPlant extends StatefulWidget {
  const GrowingPlant({
    required this.progress,
    required this.semanticsLabel,
    this.size = 96,
    this.leafColor,
    this.flowerColor,
    super.key,
  });

  final double progress;
  final String semanticsLabel;
  final double size;
  final Color? leafColor;
  final Color? flowerColor;

  @override
  State<GrowingPlant> createState() => _GrowingPlantState();
}

class _GrowingPlantState extends State<GrowingPlant>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sway = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sway.stop();
    } else if (!_sway.isAnimating) {
      _sway.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _sway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: widget.size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: widget.progress.clamp(0, 1).toDouble()),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          builder: (context, grown, _) {
            return CustomPaint(
              painter: _PlantPainter(
                sway: _sway,
                progress: grown.clamp(0, 1.05),
                leaf: widget.leafColor ?? const Color(0xFF2F9E6E),
                flower: widget.flowerColor ?? const Color(0xFFF59E0B),
                pot: Color.alphaBlend(
                  const Color(0xFFC2410C).withValues(alpha: 0.85),
                  scheme.surface,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlantPainter extends CustomPainter {
  _PlantPainter({
    required this.sway,
    required this.progress,
    required this.leaf,
    required this.flower,
    required this.pot,
  }) : super(repaint: sway);

  final Animation<double> sway;
  final double progress;
  final Color leaf;
  final Color flower;
  final Color pot;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final potTop = h * 0.74;
    final potPath = Path()
      ..moveTo(w * 0.3, potTop)
      ..lineTo(w * 0.7, potTop)
      ..lineTo(w * 0.64, h * 0.98)
      ..lineTo(w * 0.36, h * 0.98)
      ..close();
    canvas.drawPath(potPath, Paint()..color = pot);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.26, potTop - h * 0.05, w * 0.48, h * 0.07),
        Radius.circular(h * 0.02),
      ),
      Paint()..color = Color.lerp(pot, Colors.black, 0.12)!,
    );

    final grow = progress.clamp(0.0, 1.0);
    final swing = (sway.value - 0.5) * 2;
    final base = Offset(w / 2, potTop - h * 0.04);
    final stemHeight = h * 0.58 * (0.18 + 0.82 * grow);
    final tip = Offset(w / 2 + swing * w * 0.05 * grow, base.dy - stemHeight);
    final control = Offset(
      w / 2 - swing * w * 0.06,
      base.dy - stemHeight * 0.55,
    );

    final stem = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(control.dx, control.dy, tip.dx, tip.dy);
    canvas.drawPath(
      stem,
      Paint()
        ..color = Color.lerp(leaf, Colors.black, 0.15)!
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.035,
    );

    const leafSpots = [0.32, 0.5, 0.68, 0.84];
    for (var index = 0; index < leafSpots.length; index++) {
      final threshold = 0.12 + index * 0.2;
      final scale = ((grow - threshold) / 0.18).clamp(0.0, 1.0);
      if (scale <= 0) continue;
      final at = _bezier(base, control, tip, leafSpots[index]);
      final side = index.isEven ? -1.0 : 1.0;
      _leaf(canvas, at, side, w * 0.2 * scale, swing);
    }

    if (grow <= 0.05) {
      _leaf(canvas, tip, -1, w * 0.09, swing);
      _leaf(canvas, tip, 1, w * 0.09, swing);
    }

    final bloom = ((progress - 0.92) / 0.1).clamp(0.0, 1.0);
    if (bloom > 0) {
      final petal = Paint()..color = flower;
      final radius = w * 0.075 * bloom;
      for (var index = 0; index < 6; index++) {
        final angle = index * math.pi / 3 + swing * 0.2;
        canvas.drawCircle(
          tip + Offset(math.cos(angle), math.sin(angle)) * radius * 1.1,
          radius,
          petal,
        );
      }
      canvas.drawCircle(
        tip,
        radius * 0.85,
        Paint()..color = const Color(0xFFFFF4D6),
      );
    }
  }

  void _leaf(
    Canvas canvas,
    Offset at,
    double side,
    double length,
    double swing,
  ) {
    if (length <= 0) return;
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(side * (0.9 + swing * 0.08) - math.pi / 2 * 0.2);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(side * length * 0.5, -length * 0.45, side * length, 0)
      ..quadraticBezierTo(side * length * 0.5, length * 0.3, 0, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = leaf);
    canvas.restore();
  }

  Offset _bezier(Offset p0, Offset c, Offset p1, double t) {
    final u = 1 - t;
    return p0 * (u * u) + c * (2 * u * t) + p1 * (t * t);
  }

  @override
  bool shouldRepaint(_PlantPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.leaf != leaf ||
        oldDelegate.flower != flower;
  }
}
