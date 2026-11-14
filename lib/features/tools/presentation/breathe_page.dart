import 'dart:math' as math;

import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum BreathPhase { inhale, hold, exhale }

class BreathStep {
  const BreathStep(this.phase, this.seconds);

  final BreathPhase phase;
  final int seconds;
}

/// One breathing rhythm, as an ordered list of phases.
class BreathPattern {
  const BreathPattern({required this.id, required this.steps});

  final String id;
  final List<BreathStep> steps;

  int get seconds => steps.fold(0, (total, step) => total + step.seconds);
}

const breathPatterns = <BreathPattern>[
  BreathPattern(
    id: 'calm',
    steps: [
      BreathStep(BreathPhase.inhale, 4),
      BreathStep(BreathPhase.hold, 4),
      BreathStep(BreathPhase.exhale, 6),
    ],
  ),
  BreathPattern(
    id: 'box',
    steps: [
      BreathStep(BreathPhase.inhale, 4),
      BreathStep(BreathPhase.hold, 4),
      BreathStep(BreathPhase.exhale, 4),
      BreathStep(BreathPhase.hold, 4),
    ],
  ),
  BreathPattern(
    id: 'fourSevenEight',
    steps: [
      BreathStep(BreathPhase.inhale, 4),
      BreathStep(BreathPhase.hold, 7),
      BreathStep(BreathPhase.exhale, 8),
    ],
  ),
  BreathPattern(
    id: 'coherent',
    steps: [
      BreathStep(BreathPhase.inhale, 5),
      BreathStep(BreathPhase.exhale, 5),
    ],
  ),
];

const breathSessionMinutes = [1, 3, 5];

/// The phase and how far through it [t] (0–1 of one cycle) is.
({BreathPhase phase, double within}) breathPhaseAt(
  BreathPattern pattern,
  double t,
) {
  if (pattern.steps.isEmpty || pattern.seconds <= 0) {
    return (phase: BreathPhase.inhale, within: 0);
  }
  if (t >= 1) {
    return (phase: pattern.steps.last.phase, within: 1);
  }
  var remaining = t * pattern.seconds;
  for (final step in pattern.steps) {
    if (remaining < step.seconds) {
      final within = step.seconds == 0 ? 1.0 : remaining / step.seconds;
      return (phase: step.phase, within: within.clamp(0, 1));
    }
    remaining -= step.seconds;
  }
  return (phase: pattern.steps.last.phase, within: 1);
}

class BreathePage extends StatefulWidget {
  const BreathePage({super.key});

  @override
  State<BreathePage> createState() => _BreathePageState();
}

class _BreathePageState extends State<BreathePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cycle = AnimationController(vsync: this);
  var _pattern = breathPatterns.first;
  var _minutes = 1;
  var _cycles = 0;
  var _finished = false;
  BreathPhase? _lastPhase;

  @override
  void initState() {
    super.initState();
    _applyDuration();
    _cycle.addListener(_onTick);
    _cycle.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      final done = (_cycles + 1) * _pattern.seconds >= _minutes * 60;
      setState(() {
        _cycles += 1;
        _finished = done;
      });
      if (done) {
        _cycle.stop();
        _cycle.value = 0;
        return;
      }
      _cycle.forward(from: 0);
    });
  }

  void _applyDuration() {
    _cycle.duration = Duration(seconds: _pattern.seconds);
  }

  void _onTick() {
    final phase = breathPhaseAt(_pattern, _cycle.value).phase;
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

  void _selectPattern(BreathPattern pattern) {
    if (pattern.id == _pattern.id) return;
    setState(() {
      _pattern = pattern;
      _cycles = 0;
      _finished = false;
      _lastPhase = null;
      _applyDuration();
      _cycle
        ..stop()
        ..value = 0;
    });
  }

  void _selectMinutes(int minutes) {
    if (minutes == _minutes) return;
    setState(() {
      _minutes = minutes;
      _cycles = 0;
      _finished = false;
      _cycle
        ..stop()
        ..value = 0;
    });
  }

  void _toggle() {
    setState(() {
      if (_finished) {
        _finished = false;
        _cycles = 0;
        _cycle.forward(from: 0);
        return;
      }
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
    final color = scheme.primary;
    return AuroraBackground(
      base: scheme.surface,
      colors: [color.withValues(alpha: 0.12)],
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
                constraints.maxHeight * 0.42,
                280.0,
              ].reduce(math.min).clamp(140.0, 280.0);
              return SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
                child: Column(
                  children: [
                    Text(
                      _patternLine(l10n, _pattern),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final pattern in breathPatterns)
                          ChoiceChip(
                            label: Text(_patternName(l10n, pattern.id)),
                            selected: pattern.id == _pattern.id,
                            onSelected: (_) => _selectPattern(pattern),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        for (final minutes in breathSessionMinutes)
                          ChoiceChip(
                            label: Text(l10n.sessionMinutes(minutes)),
                            selected: minutes == _minutes,
                            onSelected: (_) => _selectMinutes(minutes),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _cycle,
                      builder: (context, _) {
                        final state = breathPhaseAt(_pattern, _cycle.value);
                        final idle =
                            _finished ||
                            (!_cycle.isAnimating && _cycle.value == 0);
                        final eased = Curves.easeInOut.transform(state.within);
                        final scale = idle || reduce
                            ? 0.72
                            : switch (state.phase) {
                                BreathPhase.inhale => 0.62 + 0.38 * eased,
                                BreathPhase.hold => 1.0,
                                BreathPhase.exhale => 1.0 - 0.38 * eased,
                              };
                        final label = _finished
                            ? l10n.breatheComplete
                            : idle
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
                                fill: scheme.primaryContainer,
                                animate: !reduce && !idle,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: size * 0.42,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      child: Text(
                                        label,
                                        key: ValueKey(label),
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color: scheme.onPrimaryContainer,
                                              fontWeight: FontWeight.w600,
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
                    const SizedBox(height: 12),
                    Text(
                      _finished
                          ? l10n.breatheCompleteBody
                          : l10n.breathCycles(_cycles),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _toggle,
                      icon: Icon(
                        _finished
                            ? Icons.replay_rounded
                            : _cycle.isAnimating
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        _finished
                            ? l10n.breatheAgain
                            : _cycle.isAnimating
                            ? l10n.pause
                            : l10n.start,
                      ),
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

String _patternName(AppLocalizations l10n, String id) => switch (id) {
  'box' => l10n.breathBox,
  'fourSevenEight' => l10n.breathFourSevenEight,
  'coherent' => l10n.breathCoherent,
  _ => l10n.breathCalm,
};

String _patternLine(AppLocalizations l10n, BreathPattern pattern) {
  final parts = [
    for (final step in pattern.steps)
      switch (step.phase) {
        BreathPhase.inhale => l10n.breathStepIn(step.seconds),
        BreathPhase.hold => l10n.breathStepHold(step.seconds),
        BreathPhase.exhale => l10n.breathStepOut(step.seconds),
      },
  ];
  return parts.join(' · ');
}

class _BreathPainter extends CustomPainter {
  _BreathPainter({
    required this.scale,
    required this.spin,
    required this.color,
    required this.fill,
    required this.animate,
  });

  final double scale;
  final double spin;
  final Color color;
  final Color fill;
  final bool animate;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final max = size.width / 2;
    final radius = max * scale;

    for (var ring = 3; ring >= 1; ring--) {
      canvas.drawCircle(
        center,
        radius * (1 + ring * 0.07),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color.withValues(alpha: 0.08 + ring * 0.04),
      );
    }

    const petals = 6;
    for (var index = 0; index < petals; index++) {
      final angle = index * math.pi * 2 / petals + (animate ? spin * 0.35 : 0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.78),
        angle,
        math.pi / 10,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = color.withValues(alpha: 0.35),
      );
    }

    canvas.drawCircle(
      center,
      radius * 0.58,
      Paint()
        ..shader = RadialGradient(
          colors: [fill, color.withValues(alpha: 0.55)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.58)),
    );
  }

  @override
  bool shouldRepaint(_BreathPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.spin != spin ||
        oldDelegate.color != color;
  }
}
