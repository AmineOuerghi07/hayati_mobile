import 'dart:math';

import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

const celebrationDuration = Duration(milliseconds: 1900);

/// Confetti, a check badge that pops in, and one line of encouragement.
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
      duration: celebrationDuration,
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 0.5;
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
    final palette = [
      scheme.primary,
      scheme.tertiary,
      const Color(0xFFFFB020),
      const Color(0xFFFF6B8A),
      const Color(0xFF4FB3FF),
      const Color(0xFF8BD17C),
    ];
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final fade = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25).clamp(0.0, 1.0);
          final pop = Curves.elasticOut.transform((t / 0.45).clamp(0.0, 1.0));
          return Opacity(
            opacity: fade,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: scheme.surface.withValues(alpha: 0.35 * fade),
                ),
                CustomPaint(
                  painter: _ConfettiPainter(t: t, palette: palette),
                ),
                Center(
                  child: Transform.scale(scale: 0.6 + 0.4 * pop, child: child),
                ),
              ],
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.tertiary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsetsDirectional.all(20),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 44),
              ),
            ),
            SizedBox(height: tokens.space16),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: tokens.space24,
              ),
              child: Material(
                color: tokens.cardTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(tokens.radiusCard),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: tokens.space24,
                    vertical: tokens.space12,
                  ),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.t, required this.palette});

  final double t;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(7);
    final seconds = t * celebrationDuration.inMilliseconds / 1000;
    final origin = Offset(size.width / 2, size.height * 0.42);
    const gravity = 900.0;
    for (var index = 0; index < 70; index++) {
      final angle = -pi / 2 + (random.nextDouble() - 0.5) * pi * 1.1;
      final speed = 380 + random.nextDouble() * 520;
      final spin = (random.nextDouble() - 0.5) * 14;
      final color = palette[index % palette.length];
      final width = 6 + random.nextDouble() * 6;
      final drag = 0.55 + random.nextDouble() * 0.3;
      final position =
          origin +
          Offset(
            cos(angle) * speed * seconds * drag,
            sin(angle) * speed * seconds * drag +
                0.5 * gravity * seconds * seconds,
          );
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(spin * seconds);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: width,
            height: width * 0.5,
          ),
          const Radius.circular(1.5),
        ),
        Paint()..color = color,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.t != t;
}
