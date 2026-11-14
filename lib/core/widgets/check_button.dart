import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// A round check that fills, draws its tick, and throws a small burst.
class AnimatedCheckButton extends StatefulWidget {
  const AnimatedCheckButton({
    required this.checked,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.size = 40,
    super.key,
  });

  final bool checked;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;
  final double size;

  @override
  State<AnimatedCheckButton> createState() => _AnimatedCheckButtonState();
}

class _AnimatedCheckButtonState extends State<AnimatedCheckButton>
    with TickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: widget.checked ? 1 : 0,
  );
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void didUpdateWidget(AnimatedCheckButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked == widget.checked) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _fill.value = widget.checked ? 1 : 0;
      return;
    }
    if (widget.checked) {
      _fill.forward(from: 0);
      _burst.forward(from: 0);
    } else {
      _fill.reverse();
    }
  }

  @override
  void dispose() {
    _fill.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return Semantics(
      button: true,
      checked: widget.checked,
      child: Tooltip(
        message: widget.tooltip,
        child: InkResponse(
          onTap: widget.onPressed,
          radius: 28,
          child: SizedBox.square(
            dimension: 48,
            child: Center(
              child: CustomPaint(
                size: Size.square(widget.size),
                painter: _CheckPainter(
                  fill: _fill,
                  burst: _burst,
                  color: widget.color,
                  outline: outline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({
    required this.fill,
    required this.burst,
    required this.color,
    required this.outline,
  }) : super(repaint: Listenable.merge([fill, burst]));

  final Animation<double> fill;
  final Animation<double> burst;
  final Color color;
  final Color outline;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 1.5;
    final t = fill.value;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Color.lerp(outline, color, t)!,
    );

    final grow = Curves.easeOutBack.transform(t.clamp(0.0, 1.0));
    if (grow > 0) {
      canvas.drawCircle(
        center,
        (radius * grow).clamp(0.0, radius + 2),
        Paint()..color = color,
      );
    }

    final tick = ((t - 0.35) / 0.65).clamp(0.0, 1.0);
    if (tick > 0) {
      final path = Path()
        ..moveTo(size.width * 0.28, size.height * 0.52)
        ..lineTo(size.width * 0.44, size.height * 0.67)
        ..lineTo(size.width * 0.73, size.height * 0.36);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * tick),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Colors.white,
      );
    }

    final b = burst.value;
    if (b > 0 && b < 1) {
      final eased = Curves.easeOutCubic.transform(b);
      final dot = Paint()..color = color.withValues(alpha: 1 - b);
      for (var index = 0; index < 8; index++) {
        final angle = index * math.pi / 4;
        final distance = radius + 3 + 8 * eased;
        canvas.drawCircle(
          center + Offset(math.cos(angle), math.sin(angle)) * distance,
          2.4 * (1 - b),
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.outline != outline;
  }
}
