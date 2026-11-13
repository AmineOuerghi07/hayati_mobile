import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/soft_card.dart';
import 'package:hayati/features/habits/domain/habit.dart';
import 'package:hayati/features/habits/domain/habit_progress.dart';
import 'package:hayati/features/habits/presentation/habit_labels.dart';
import 'package:hayati/features/habits/presentation/habit_style.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.index,
    required this.habit,
    required this.value,
    required this.onOpen,
    required this.onToggle,
    required this.onStep,
    required this.onNote,
    required this.onEdit,
    required this.onArchive,
    super.key,
  });

  final int index;
  final Habit habit;
  final double value;
  final VoidCallback onOpen;
  final VoidCallback onToggle;
  final void Function(double delta) onStep;
  final VoidCallback onNote;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = habitColor(habit.colorKey);
    final complete = meetsTarget(value, habit.targetValue);
    final tokens = HayatiTokens.of(context);
    final tint = complete
        ? Color.alphaBlend(color.withValues(alpha: 0.16), tokens.cardTint)
        : null;
    return SwipeActions(
      actions: [
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
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 8, 8),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Tooltip(
                message: l10n.dragToReorder,
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.drag_handle),
                ),
              ),
            ),
            Hero(
              tag: 'habit-${habit.id}',
              child: Icon(habitIcon(habit.icon), color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (habit.tracksQuantity) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: habit.targetValue <= 0
                            ? 0
                            : (value / habit.targetValue).clamp(0, 1),
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          key: ValueKey('minus-${habit.id}'),
                          tooltip: l10n.decreaseHabit(habit.name),
                          onPressed: value <= 0 ? null : () => onStep(-1),
                          icon: const Icon(Icons.remove),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              l10n
                                  .quantityProgress(
                                    value.round(),
                                    habit.targetValue.round(),
                                    unitLabel(l10n, habit.unit),
                                  )
                                  .trim(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        IconButton(
                          key: ValueKey('plus-${habit.id}'),
                          tooltip: l10n.increaseHabit(habit.name),
                          onPressed: () => onStep(1),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!habit.tracksQuantity)
              IconButton(
                tooltip: habit.name,
                onPressed: onToggle,
                icon: AnimatedScale(
                  duration: tokens.motion(context, tokens.motionMedium),
                  curve: tokens.checkOff,
                  scale: complete ? 1 : 0.92,
                  child: Icon(
                    complete ? Icons.check_circle : Icons.circle_outlined,
                    color: complete
                        ? color
                        : Theme.of(context).colorScheme.outline,
                    size: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
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
