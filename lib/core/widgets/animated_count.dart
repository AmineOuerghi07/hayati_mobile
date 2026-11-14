import 'package:hayati/app/theme.dart';
import 'package:material_ui/material_ui.dart';

/// A number that counts up on first build and eases into new values.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    required this.value,
    this.style,
    this.suffix = '',
    super.key,
  });

  final int value;
  final TextStyle? style;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduce ? value.toDouble() : 0, end: value.toDouble()),
      duration: reduce ? Duration.zero : const Duration(milliseconds: 900),
      curve: tokens.easeOut,
      builder: (context, shown, _) {
        return Text('${shown.round()}$suffix', style: style);
      },
    );
  }
}
