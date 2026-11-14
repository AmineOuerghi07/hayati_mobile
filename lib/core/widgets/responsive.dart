import 'package:material_ui/material_ui.dart';

/// Window classes from the Material 3 layout guidance.
const compactMaxWidth = 600.0;
const expandedMinWidth = 900.0;

bool isCompactWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width < compactMaxWidth;

/// Keeps reading width comfortable on tablets and in landscape by centering
/// [child] in a column no wider than [maxWidth].
class ResponsiveWidth extends StatelessWidget {
  const ResponsiveWidth({required this.child, this.maxWidth = 720, super.key});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// A [ListView] whose content column is capped at [maxWidth] and centered,
/// while drags anywhere across the full width still scroll it.
class ResponsiveListView extends StatelessWidget {
  const ResponsiveListView({
    required this.children,
    this.maxWidth = 720,
    this.side = 16,
    this.top = 0,
    this.bottom = 0,
    super.key,
  });

  final List<Widget> children;
  final double maxWidth;
  final double side;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: responsiveInsets(
          constraints.maxWidth,
          maxWidth: maxWidth,
          side: side,
          top: top,
          bottom: bottom,
        ),
        children: children,
      ),
    );
  }
}

/// Horizontal padding that grows on wide layouts so content stays centered
/// while the whole width still scrolls.
EdgeInsetsDirectional responsiveInsets(
  double available, {
  double maxWidth = 720,
  double side = 16,
  double top = 0,
  double bottom = 0,
}) {
  final extra = available > maxWidth + side * 2
      ? (available - maxWidth) / 2
      : side;
  return EdgeInsetsDirectional.fromSTEB(extra, top, extra, bottom);
}
