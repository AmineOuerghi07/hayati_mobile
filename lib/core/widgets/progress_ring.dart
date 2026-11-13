import 'dart:math' as math;

import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// A ring whose center stays empty, so the percent never sits in the stroke.
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    required this.value,
    required this.centerLabel,
    required this.semanticsLabel,
    this.size = 88,
    this.strokeWidth = 8,
    this.color,
    super.key,
  });

  /// Null when nothing was due. Otherwise 0…1.
  final double? value;
  final String centerLabel;
  final String semanticsLabel;
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with TickerProviderStateMixin {
  late final AnimationController _progress;
  late final AnimationController _pulse;
  double _from = 0;

  double get _target => (widget.value ?? 0).clamp(0, 1).toDouble();

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _progress.forward();
    if (_target >= 1) _pulse.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _from = _target;
      _progress.value = 1;
    }
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;
    _from = _shown;
    if (MediaQuery.disableAnimationsOf(context)) {
      _from = _target;
      _progress.value = 1;
    } else {
      _progress.forward(from: 0);
    }
    final wasComplete = (oldWidget.value ?? 0) >= 1;
    if (!wasComplete && _target >= 1) _pulse.forward(from: 0);
  }

  double get _shown {
    final t = Curves.easeOutCubic.transform(_progress.value);
    return _from + (_target - _from) * t;
  }

  @override
  void dispose() {
    _progress.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.color ?? scheme.primary;
    final complete = (widget.value ?? 0) >= 1;
    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_progress, _pulse]),
          builder: (context, child) {
            final pulse = complete
                ? 1 + 0.035 * math.sin(math.pi * _pulse.value)
                : 1.0;
            return Transform.scale(
              scale: pulse,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: _shown,
                  color: color,
                  track: scheme.surfaceContainerHighest,
                  strokeWidth: widget.strokeWidth,
                ),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(widget.strokeWidth + 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.centerLabel,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (complete)
                    Icon(Icons.check_rounded, size: 16, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color track;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);
    if (progress <= 0) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    if (progress >= 0.999) {
      paint.strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }
    paint.strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class LabeledRing extends StatelessWidget {
  const LabeledRing({
    required this.caption,
    required this.value,
    required this.centerLabel,
    required this.semanticsLabel,
    this.size = 84,
    this.color,
    super.key,
  });

  final String caption;
  final double? value;
  final String centerLabel;
  final String semanticsLabel;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    return Column(
      children: [
        ProgressRing(
          value: value,
          centerLabel: centerLabel,
          semanticsLabel: semanticsLabel,
          size: size,
          color: color,
        ),
        SizedBox(height: tokens.space8),
        Text(
          caption,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
