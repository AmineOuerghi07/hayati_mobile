import 'dart:math' as math;

import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum BreathPhase { inhale, hold, exhale }

/// Seconds for inhale, hold, and exhale: a calming 4-4-6 rhythm.
const breathPattern = (inhale: 4, hold: 4, exhale: 6);

int get breathCycleSeconds =>
    breathPattern.inhale + breathPattern.hold + breathPattern.exhale;

/// The phase and how far through it [t] (0–1 of one cycle) is.
({BreathPhase phase, double within}) breathPhaseAt(double t) {
  final seconds = t * breathCycleSeconds;
  if (seconds < breathPattern.inhale) {
    return (phase: BreathPhase.inhale, within: seconds / breathPattern.inhale);
  }
  final afterInhale = seconds - breathPattern.inhale;
  if (afterInhale < breathPattern.hold) {
    return (phase: BreathPhase.hold, within: afterInhale / breathPattern.hold);
  }
  final afterHold = afterInhale - breathPattern.hold;
  return (
    phase: BreathPhase.exhale,
    within: (afterHold / breathPattern.exhale).clamp(0, 1),
  );
}

class BreathePage extends StatefulWidget {
  const BreathePage({super.key});

  @override
  State<BreathePage> createState() => _BreathePageState();
}

class _BreathePageState extends State<BreathePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cycle = AnimationController(
    vsync: this,
    duration: Duration(seconds: breathCycleSeconds),
  );
  var _cycles = 0;
  BreathPhase? _lastPhase;

  @override
  void initState() {
    super.initState();
    _cycle.addListener(_onTick);
    _cycle.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _cycles += 1);
        _cycle.forward(from: 0);
      }
    });
  }

  void _onTick() {
    final phase = breathPhaseAt(_cycle.value).phase;
    if (phase != _lastPhase) {
      _lastPhase = phase;
      if (_cycle.isAnimating) playHaptic();
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_cycle.isAnimating) {
        _cycle.stop();
      } else {
        _cycle.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final color = const Color(0xFF38BDF8);
    return AuroraBackground(
      base: scheme.surface,
      colors: [
        color.withValues(alpha: 0.25),
        scheme.tertiary.withValues(alpha: 0.18),
        const Color(0xFFA78BFA).withValues(alpha: 0.2),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(l10n.breatheTitle),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = [
                constraints.maxWidth - 48,
                constraints.maxHeight * 0.55,
                320.0,
              ].reduce(math.min).clamp(160.0, 320.0);
              return SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(24),
                child: Column(
                  children: [
                    Text(
                      l10n.breatheBody,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _cycle,
                      builder: (context, _) {
                        final state = breathPhaseAt(_cycle.value);
                        final idle = !_cycle.isAnimating && _cycle.value == 0;
                        final eased = Curves.easeInOut.transform(state.within);
                        final scale = idle || reduce
                            ? 0.75
                            : switch (state.phase) {
                                BreathPhase.inhale => 0.55 + 0.45 * eased,
                                BreathPhase.hold => 1.0,
                                BreathPhase.exhale => 1.0 - 0.45 * eased,
                              };
                        final label = idle
                            ? l10n.breatheReady
                            : switch (state.phase) {
                                BreathPhase.inhale => l10n.breatheIn,
                                BreathPhase.hold => l10n.breatheHold,
                                BreathPhase.exhale => l10n.breatheOut,
                              };
                        return Semantics(
                          liveRegion: true,
                          label: label,
                          excludeSemantics: true,
                          child: SizedBox.square(
                            dimension: size,
                            child: CustomPaint(
                              painter: _BreathPainter(
                                scale: scale,
                                spin: _cycle.value,
                                color: color,
                                accent: const Color(0xFFA78BFA),
                                animate: !reduce,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: size * 0.3,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: Text(
                                        label,
                                        key: ValueKey(label),
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.breathCycles(_cycles),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _toggle,
                      icon: Icon(
                        _cycle.isAnimating
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(_cycle.isAnimating ? l10n.pause : l10n.start),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BreathPainter extends CustomPainter {
  _BreathPainter({
    required this.scale,
    required this.spin,
    required this.color,
    required this.accent,
    required this.animate,
  });

  final double scale;
  final double spin;
  final Color color;
  final Color accent;
  final bool animate;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final max = size.width / 2;
    final radius = max * scale;

    for (var ring = 3; ring >= 1; ring--) {
      canvas.drawCircle(
        center,
        radius * (1 + ring * 0.08),
        Paint()..color = color.withValues(alpha: 0.06 * ring),
      );
    }

    final petals = 6;
    for (var index = 0; index < petals; index++) {
      final angle = index * math.pi * 2 / petals + (animate ? spin * 0.6 : 0);
      final offset =
          Offset(math.cos(angle), math.sin(angle)) * radius * 0.32 * scale;
      canvas.drawCircle(
        center + offset,
        radius * 0.62,
        Paint()
          ..color = Color.lerp(
            color,
            accent,
            index / petals,
          )!.withValues(alpha: 0.28),
      );
    }

    canvas.drawCircle(
      center,
      radius * 0.6,
      Paint()
        ..shader = RadialGradient(
          colors: [color, Color.lerp(color, accent, 0.6)!],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.6)),
    );
  }

  @override
  bool shouldRepaint(_BreathPainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.spin != spin;
  }
}
