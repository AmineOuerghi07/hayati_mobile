import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/growing_plant.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Plays once over the first screen: the plant grows, the name fades in,
/// then the veil lifts. Widget tests skip it so they can reach the app.
class HayatiSplash extends StatefulWidget {
  const HayatiSplash({required this.ready, required this.child, super.key});

  final bool ready;
  final Widget child;

  @override
  State<HayatiSplash> createState() => _HayatiSplashState();
}

class _HayatiSplashState extends State<HayatiSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  var _show = !_runningInTests;

  static bool get _runningInTests =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
    _intro.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finish();
    });
    if (_show) _intro.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _show) {
      _intro.value = 1;
      _finish();
    }
  }

  @override
  void didUpdateWidget(HayatiSplash oldWidget) {
    super.didUpdateWidget(oldWidget);
    _finish();
  }

  void _finish() {
    if (!_show || !widget.ready || _intro.value < 1) return;
    setState(() => _show = false);
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return widget.child;
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0).animate(
              CurvedAnimation(
                parent: _intro,
                curve: const Interval(0.72, 1, curve: Curves.easeOut),
              ),
            ),
            child: AuroraBackground(
              base: scheme.surface,
              colors: [
                scheme.primary.withValues(alpha: 0.28),
                scheme.tertiary.withValues(alpha: 0.18),
              ],
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _intro,
                      builder: (context, _) {
                        final grown = reduce
                            ? 1.0
                            : const Interval(
                                0,
                                0.7,
                                curve: Curves.easeOutCubic,
                              ).transform(_intro.value);
                        return GrowingPlant(
                          progress: grown,
                          size: 160,
                          semanticsLabel: l10n.appTitle,
                          flowerColor: scheme.tertiary,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
                      ),
                      child: Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
