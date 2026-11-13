import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// A number that eases into its new value.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({required this.value, this.style, super.key});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.toDouble()),
      duration: reduce ? Duration.zero : tokens.motionSlow,
      curve: tokens.easeOut,
      builder: (context, shown, _) {
        return Text('${shown.round()}', style: style);
      },
    );
  }
}
