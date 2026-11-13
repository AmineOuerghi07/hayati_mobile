import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// A quiet surface with a soft press, used for habits, settings, and stats.
class SoftCard extends StatefulWidget {
  const SoftCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.tint,
    this.padding = const EdgeInsetsDirectional.all(16),
    this.background,
    super.key,
  });

  final Widget child;

  /// Painted behind the padded content, clipped to the card shape.
  final Widget? background;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? tint;
  final EdgeInsetsGeometry padding;

  @override
  State<SoftCard> createState() => _SoftCardState();
}

class _SoftCardState extends State<SoftCard> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(tokens.radiusCard);
    return AnimatedScale(
      scale: _pressed && !reduce ? 0.985 : 1,
      duration: reduce ? Duration.zero : tokens.motionFast,
      curve: tokens.easeOut,
      child: Material(
        color: widget.tint ?? tokens.cardTint,
        clipBehavior: widget.background == null ? Clip.none : Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: radius),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
          child: widget.background == null
              ? Padding(padding: widget.padding, child: widget.child)
              : Stack(
                  children: [
                    Positioned.fill(child: widget.background!),
                    Padding(padding: widget.padding, child: widget.child),
                  ],
                ),
        ),
      ),
    );
  }
}
