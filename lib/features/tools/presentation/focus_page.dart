import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/core/time/calendar_date.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/celebration_overlay.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
import 'package:hayati/features/habits/presentation/habit_providers.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

const focusPresets = [5, 10, 15, 25, 45];

/// A calm countdown. When it finishes with a habit attached, the minutes
/// are added to today (for minute habits) or the habit is checked off.
class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({this.habitId, super.key});

  final String? habitId;

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage>
    with TickerProviderStateMixin {
  var _minutes = 25;
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: Duration(minutes: _minutes),
  )..addStatusListener(_onStatus);
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  String? _burst;
  Timer? _burstTimer;

  @override
  void dispose() {
    _burstTimer?.cancel();
    _clock.dispose();
    _pulse.dispose();
    super.dispose();
  }

  bool get _running => _clock.isAnimating;
  bool get _started => _clock.value > 0 && !_clock.isCompleted;

  void _pick(int minutes) {
    if (_started) return;
    setState(() {
      _minutes = minutes;
      _clock.duration = Duration(minutes: minutes);
      _clock.value = 0;
    });
  }

  void _toggle() {
    playHaptic();
    setState(() {
      if (_running) {
        _clock.stop();
        _pulse.stop();
      } else {
        if (_clock.isCompleted) _clock.value = 0;
        _clock.forward();
        if (!MediaQuery.disableAnimationsOf(context)) {
          _pulse.repeat(reverse: true);
        }
      }
    });
  }

  void _reset() {
    setState(() {
      _clock.stop();
      _clock.value = 0;
      _pulse.stop();
    });
  }

  Future<void> _onStatus(AnimationStatus status) async {
    if (status != AnimationStatus.completed) return;
    _pulse.stop();
    playHaptic(strong: true);
    final l10n = AppLocalizations.of(context);
    final habit = _habit;
    var message = l10n.focusDone;
    if (habit != null) {
      await _log(habit);
      if (!mounted) return;
      message = l10n.focusLogged(_minutes, habit.name);
    }
    _burstTimer?.cancel();
    setState(() => _burst = message);
    _burstTimer = Timer(celebrationDuration, () {
      if (mounted) setState(() => _burst = null);
    });
  }

  Habit? get _habit {
    final id = widget.habitId;
    if (id == null) return null;
    return ref.read(habitByIdProvider(id)).value;
  }

  Future<void> _log(Habit habit) async {
    final today = CalendarDate.today().iso;
    final completions = ref.read(allCompletionsProvider).value ?? const [];
    final current = completions
        .where((item) => item.habitId == habit.id && item.date == today)
        .firstOrNull;
    final next = habit.unit == 'minutes'
        ? stepQuantity(current?.value ?? 0, _minutes.toDouble())
        : math.max(current?.value ?? 0, habit.targetValue);
    await ref
        .read(completionRepositoryProvider)
        .setValue(
          habitId: habit.id,
          date: today,
          value: next,
          note: current?.note,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final habit = widget.habitId == null
        ? null
        : ref.watch(habitByIdProvider(widget.habitId!)).value;
    final accent = habit == null ? scheme.primary : habitColor(habit.colorKey);

    return AuroraBackground(
      base: scheme.surface,
      colors: [
        accent.withValues(alpha: 0.22),
        scheme.tertiary.withValues(alpha: 0.16),
        scheme.secondaryContainer.withValues(alpha: 0.5),
      ],
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(l10n.focusTitle),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final dial = [
                    constraints.maxWidth - 64,
                    constraints.maxHeight * 0.5,
                    300.0,
                  ].reduce(math.min).clamp(160.0, 300.0);
                  return SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      24,
                      8,
                      24,
                      24,
                    ),
                    child: Column(
                      children: [
                        if (habit != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HabitBadge(
                                icon: habit.icon,
                                colorKey: habit.colorKey,
                                size: 32,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  habit.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            l10n.focusBody,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 24),
                        AnimatedBuilder(
                          animation: Listenable.merge([_clock, _pulse]),
                          builder: (context, _) {
                            final total = _minutes * 60;
                            final left = (total * (1 - _clock.value)).ceil();
                            final label =
                                '${(left ~/ 60).toString().padLeft(2, '0')}:'
                                '${(left % 60).toString().padLeft(2, '0')}';
                            return Semantics(
                              label: l10n.focusRemaining(label),
                              liveRegion: false,
                              excludeSemantics: true,
                              child: SizedBox.square(
                                dimension: dial,
                                child: CustomPaint(
                                  painter: _DialPainter(
                                    progress: _clock.value,
                                    pulse: _pulse.value,
                                    color: accent,
                                    track: accent.withValues(alpha: 0.14),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            label,
                                            textDirection: TextDirection.ltr,
                                            style: theme.textTheme.displayMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontFeatures: const [
                                                    FontFeature.tabularFigures(),
                                                  ],
                                                ),
                                          ),
                                        ),
                                        Text(
                                          _running
                                              ? l10n.focusInProgress
                                              : _started
                                              ? l10n.focusPaused
                                              : l10n.minutesShort(_minutes),
                                          style: theme.textTheme.labelLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        AnimatedOpacity(
                          opacity: _started ? 0.4 : 1,
                          duration: const Duration(milliseconds: 250),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final preset in focusPresets)
                                ChoiceChip(
                                  label: Text(l10n.minutesShort(preset)),
                                  selected: preset == _minutes,
                                  onSelected: _started
                                      ? null
                                      : (_) => _pick(preset),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filledTonal(
                              tooltip: l10n.reset,
                              onPressed: _started || _clock.isCompleted
                                  ? _reset
                                  : null,
                              icon: const Icon(Icons.replay_rounded),
                            ),
                            const SizedBox(width: 20),
                            SizedBox.square(
                              dimension: 80,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: accent,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: _toggle,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                  child: Icon(
                                    _running
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    key: ValueKey(_running),
                                    size: 40,
                                    semanticLabel: _running
                                        ? l10n.pause
                                        : _started
                                        ? l10n.resume
                                        : l10n.start,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 68),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_burst != null)
            Positioned.fill(child: CelebrationOverlay(message: _burst!)),
        ],
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.progress,
    required this.pulse,
    required this.color,
    required this.track,
  });

  final double progress;
  final double pulse;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final stroke = radius * 0.09;

    canvas.drawCircle(
      center,
      radius * (0.78 + 0.05 * pulse),
      Paint()..color = color.withValues(alpha: 0.06 + 0.06 * pulse),
    );

    for (var index = 0; index < 60; index++) {
      final angle = index / 60 * math.pi * 2 - math.pi / 2;
      final major = index % 5 == 0;
      final outer = radius - stroke * 1.6;
      final inner = outer - (major ? stroke * 0.7 : stroke * 0.35);
      final passed = index / 60 <= progress;
      canvas.drawLine(
        center + Offset(math.cos(angle), math.sin(angle)) * inner,
        center + Offset(math.cos(angle), math.sin(angle)) * outer,
        Paint()
          ..strokeWidth = major ? 2.4 : 1.2
          ..strokeCap = StrokeCap.round
          ..color = passed
              ? color.withValues(alpha: 0.9)
              : color.withValues(alpha: 0.22),
      );
    }

    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = progress >= 1 ? StrokeCap.butt : StrokeCap.round
        ..shader = SweepGradient(
          colors: [Color.lerp(color, Colors.white, 0.35)!, color],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
    final angle = -math.pi / 2 + math.pi * 2 * progress;
    canvas.drawCircle(
      center + Offset(math.cos(angle), math.sin(angle)) * (radius - stroke / 2),
      stroke * 0.75,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.color != color;
  }
}
