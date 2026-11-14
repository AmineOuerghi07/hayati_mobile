import 'dart:math' as math;

import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/check_button.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/core/widgets/streak_flame.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
import 'package:hayati/features/habits/domain/part_of_day.dart';
import 'package:hayati/features/habits/domain/habit_schedule.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.index,
    required this.habit,
    required this.value,
    required this.streak,
    required this.onOpen,
    required this.onToggle,
    required this.onStep,
    required this.onNote,
    required this.onEdit,
    required this.onArchive,
    this.onSkip,
    this.skipped = false,
    this.reorderEnabled = true,
    super.key,
  });

  final int index;
  final Habit habit;
  final double value;
  final int streak;
  final VoidCallback onOpen;
  final VoidCallback onToggle;
  final void Function(double delta) onStep;
  final VoidCallback onNote;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback? onSkip;
  final bool skipped;
  final bool reorderEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = habitColor(habit.colorKey);
    final complete = meetsTarget(value, habit.targetValue);
    final tokens = HayatiTokens.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final weeks = habit.frequencyType == FrequencyType.timesPerWeek;
    final fill = habit.targetValue <= 0
        ? 0.0
        : (value / habit.targetValue).clamp(0.0, 1.0);
    final tint = complete
        ? Color.alphaBlend(color.withValues(alpha: 0.10), tokens.cardTint)
        : null;
    final subtitle = skipped
        ? l10n.skippedToday
        : habit.tracksQuantity
        ? l10n
              .quantityProgress(
                value.round(),
                habit.targetValue.round(),
                unitLabel(l10n, habit.unit),
              )
              .trim()
        : (weeks ? l10n.streakWeeks(streak) : l10n.streakDays(streak));
    return _Pop(
      active: complete,
      child: SwipeActions(
        actions: [
          if (onSkip != null)
            _Action(
              tooltip: skipped ? l10n.undoSkip : l10n.skipToday,
              icon: Icons.redo_rounded,
              onPressed: onSkip!,
            ),
          _Action(
            tooltip: l10n.addNote,
            icon: Icons.edit_note_outlined,
            onPressed: onNote,
          ),
          _Action(
            tooltip: l10n.editHabit,
            icon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
          _Action(
            tooltip: l10n.archive,
            icon: Icons.archive_outlined,
            onPressed: onArchive,
          ),
        ],
        child: SoftCard(
          tint: tint,
          onTap: onOpen,
          onLongPress: onNote,
          padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 6, 8),
          background: habit.tracksQuantity
              ? TweenAnimationBuilder<double>(
                  tween: Tween(end: fill),
                  duration: reduce
                      ? Duration.zero
                      : const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, level, _) =>
                      _LiquidFill(level: level, color: color, animate: !reduce),
                )
              : null,
          child: Row(
            children: [
              if (reorderEnabled)
                ReorderableDragStartListener(
                  index: index,
                  child: Tooltip(
                    message: l10n.dragToReorder,
                    child: SizedBox(
                      width: 40,
                      height: 48,
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        size: 20,
                        color: theme.colorScheme.outline.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              Hero(
                tag: 'habit-${habit.id}',
                child: HabitBadge(icon: habit.icon, colorKey: habit.colorKey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: tokens.motion(context, tokens.motionMedium),
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: complete
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                            : theme.colorScheme.onSurface,
                      ),
                      child: Row(
                        children: [
                          if (resolvedPartOfDay(
                                chosen: habit.partOfDay,
                                reminderMinutes: habit.reminderTime,
                              )
                              case final part?) ...[
                            Icon(partIcon(part), size: 16, color: color),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              habit.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        StreakChip(
                          count: streak,
                          label: weeks
                              ? l10n.streakWeeks(streak)
                              : l10n.streakDays(streak),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: AnimatedSwitcher(
                            duration: tokens.motion(context, tokens.motionFast),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween(
                                      begin: const Offset(0, 0.4),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: Text(
                              subtitle,
                              key: ValueKey(subtitle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (habit.tracksQuantity) ...[
                _RoundStep(
                  key: ValueKey('minus-${habit.id}'),
                  tooltip: l10n.decreaseHabit(habit.name),
                  icon: Icons.remove_rounded,
                  color: color,
                  filled: false,
                  onPressed: value <= 0 ? null : () => onStep(-1),
                ),
                _RoundStep(
                  key: ValueKey('plus-${habit.id}'),
                  tooltip: l10n.increaseHabit(habit.name),
                  icon: complete ? Icons.check_rounded : Icons.add_rounded,
                  color: color,
                  filled: true,
                  onPressed: () => onStep(1),
                ),
              ] else
                AnimatedCheckButton(
                  checked: complete,
                  color: color,
                  tooltip: habit.name,
                  onPressed: onToggle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A soft rising level with a gentle wave on its edge.
class _LiquidFill extends StatefulWidget {
  const _LiquidFill({
    required this.level,
    required this.color,
    required this.animate,
  });

  final double level;
  final Color color;
  final bool animate;

  @override
  State<_LiquidFill> createState() => _LiquidFillState();
}

class _LiquidFillState extends State<_LiquidFill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_LiquidFill oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final run = widget.animate && widget.level > 0 && widget.level < 1;
    if (run && !_wave.isAnimating) {
      _wave.repeat();
    } else if (!run && _wave.isAnimating) {
      _wave.stop();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LiquidPainter(
        wave: _wave,
        level: widget.level,
        color: widget.color,
        rtl: Directionality.of(context) == TextDirection.rtl,
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({
    required this.wave,
    required this.level,
    required this.color,
    required this.rtl,
  }) : super(repaint: wave);

  final Animation<double> wave;
  final double level;
  final Color color;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    if (level <= 0) return;
    final edge = size.width * level;
    final amplitude = level >= 1 ? 0.0 : 5.0;
    final phase = wave.value * math.pi * 2;
    final path = Path()..moveTo(0, 0);
    for (var y = 0.0; y <= size.height; y += 4) {
      final x =
          edge + math.sin(y / size.height * math.pi * 2 + phase) * amplitude;
      path.lineTo(x, y);
    }
    path
      ..lineTo(0, size.height)
      ..close();
    if (rtl) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0.10),
            color.withValues(alpha: 0.22),
          ],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) {
    return oldDelegate.level != level ||
        oldDelegate.color != color ||
        oldDelegate.rtl != rtl;
  }
}

class _RoundStep extends StatelessWidget {
  const _RoundStep({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: filled ? color : color.withValues(alpha: 0.12),
        foregroundColor: filled ? Colors.white : color,
        disabledBackgroundColor: color.withValues(alpha: 0.05),
        minimumSize: const Size(44, 44),
        fixedSize: const Size(44, 44),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      icon: Icon(icon, size: 22),
    );
  }
}

/// Gives the card a short happy bounce when it becomes complete.
class _Pop extends StatefulWidget {
  const _Pop({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_Pop> createState() => _PopState();
}

class _PopState extends State<_Pop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(_Pop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active &&
        widget.active &&
        !MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = 1 + math.sin(t * math.pi) * 0.025;
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(tooltip: tooltip, onPressed: onPressed, icon: Icon(icon));
  }
}

/// Reveals [actions] when the card is dragged toward the end edge.
class SwipeActions extends StatefulWidget {
  const SwipeActions({required this.child, required this.actions, super.key});

  final Widget child;
  final List<Widget> actions;

  @override
  State<SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<SwipeActions> {
  double _offset = 0;

  @override
  Widget build(BuildContext context) {
    final width = 48.0 * widget.actions.length;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final tokens = HayatiTokens.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusCard),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: rtl ? Alignment.centerLeft : Alignment.centerRight,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.actions,
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final next = _offset + (details.primaryDelta ?? 0);
              setState(() {
                _offset = rtl ? next.clamp(0, width) : next.clamp(-width, 0);
              });
            },
            onHorizontalDragEnd: (_) {
              final open = _offset.abs() > width / 2;
              setState(() => _offset = open ? (rtl ? width : -width) : 0);
            },
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
