import 'package:material_ui/material_ui.dart';

const _flameColors = [Color(0xFFFFC94D), Color(0xFFFF8A00), Color(0xFFE8452C)];

/// A warm flame that flickers while a streak is alive.
class StreakFlame extends StatefulWidget {
  const StreakFlame({required this.active, this.size = 18, super.key});

  final bool active;
  final double size;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flicker = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(StreakFlame oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final run = widget.active && !MediaQuery.disableAnimationsOf(context);
    if (run && !_flicker.isAnimating) {
      _flicker.repeat(reverse: true);
    } else if (!run && _flicker.isAnimating) {
      _flicker.stop();
    }
  }

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.local_fire_department_rounded,
      size: widget.size,
      color: Colors.white,
    );
    if (!widget.active) {
      return Icon(
        Icons.local_fire_department_outlined,
        size: widget.size,
        color: Theme.of(context).colorScheme.outline,
      );
    }
    return AnimatedBuilder(
      animation: _flicker,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_flicker.value);
        return Transform.rotate(
          angle: (t - 0.5) * 0.12,
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: 0.94 + 0.1 * t,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _flameColors,
        ).createShader(bounds),
        child: icon,
      ),
    );
  }
}

/// Flame plus a count, used on cards and in the Today header.
class StreakChip extends StatelessWidget {
  const StreakChip({required this.count, required this.label, super.key});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreakFlame(active: count > 0, size: 16),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: count > 0
                  ? const Color(0xFFE8622C)
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
