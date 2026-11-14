import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/widgets/aurora_background.dart';
import 'package:hayati/core/widgets/responsive.dart';
import 'package:hayati/core/widgets/staggered_item.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Aurora backdrop, an animated emblem, a title, and a form card.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = HayatiTokens.of(context);
    return AuroraBackground(
      base: scheme.surface,
      colors: [
        scheme.primary.withValues(alpha: 0.24),
        scheme.tertiary.withValues(alpha: 0.18),
        scheme.secondaryContainer.withValues(alpha: 0.55),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          top: false,
          child: ResponsiveListView(
            maxWidth: 480,
            side: 20,
            top: 0,
            bottom: 32,
            children: [
              StaggeredItem(index: 0, child: AuthEmblem(icon: icon)),
              const SizedBox(height: 20),
              StaggeredItem(
                index: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StaggeredItem(
                index: 2,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              StaggeredItem(
                index: 3,
                child: Material(
                  color: tokens.cardTint.withValues(alpha: 0.92),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.radiusSheet),
                    side: BorderSide(
                      color: scheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: AnimatedSize(
                    duration: tokens.motion(context, tokens.motionMedium),
                    curve: tokens.easeOut,
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(20),
                      child: child,
                    ),
                  ),
                ),
              ),
              if (footer != null) ...[
                const SizedBox(height: 20),
                StaggeredItem(index: 5, child: footer!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A glowing orb with pulsing rings and orbiting sparks.
class AuthEmblem extends StatefulWidget {
  const AuthEmblem({required this.icon, this.size = 148, super.key});

  final IconData icon;
  final double size;

  @override
  State<AuthEmblem> createState() => _AuthEmblemState();
}

class _AuthEmblemState extends State<AuthEmblem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Center(
        child: SizedBox.square(
          dimension: widget.size,
          child: CustomPaint(
            painter: _EmblemPainter(
              loop: _loop,
              primary: scheme.primary,
              tertiary: scheme.tertiary,
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _loop,
                builder: (context, child) {
                  final bob = math.sin(_loop.value * math.pi * 4) * 3;
                  return Transform.translate(
                    offset: Offset(0, bob),
                    child: child,
                  );
                },
                child: Container(
                  width: widget.size * 0.46,
                  height: widget.size * 0.46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [scheme.primary, scheme.tertiary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: widget.size * 0.22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmblemPainter extends CustomPainter {
  _EmblemPainter({
    required this.loop,
    required this.primary,
    required this.tertiary,
  }) : super(repaint: loop);

  final Animation<double> loop;
  final Color primary;
  final Color tertiary;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final max = size.width / 2;
    final t = loop.value;

    for (var ring = 0; ring < 3; ring++) {
      final phase = (t * 2 + ring / 3) % 1;
      canvas.drawCircle(
        center,
        max * (0.35 + 0.65 * phase),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = primary.withValues(alpha: 0.35 * (1 - phase)),
      );
    }

    for (var spark = 0; spark < 5; spark++) {
      final angle =
          t * math.pi * 2 * (spark.isEven ? 1 : -0.7) + spark * math.pi * 2 / 5;
      final orbit = max * (0.62 + 0.08 * math.sin(t * math.pi * 6 + spark));
      final point = center + Offset(math.cos(angle), math.sin(angle)) * orbit;
      canvas.drawCircle(
        point,
        2.5 + (spark % 3),
        Paint()..color = Color.lerp(primary, tertiary, spark / 4)!,
      );
    }
  }

  @override
  bool shouldRepaint(_EmblemPainter oldDelegate) =>
      oldDelegate.primary != primary || oldDelegate.tertiary != tertiary;
}

/// A rounded field with a leading icon. Password fields get a reveal toggle.
class AuthField extends StatefulWidget {
  const AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.password = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.onSubmitted,
    this.onChanged,
    this.textDirection,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool password;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextDirection? textDirection;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  var _hidden = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: widget.controller,
      obscureText: widget.password && _hidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      textDirection: widget.textDirection,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.password
            ? IconButton(
                tooltip: _hidden ? l10n.showPassword : l10n.hidePassword,
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    _hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    key: ValueKey(_hidden),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

/// 0 to 4: length, mixed case, a digit, and a symbol each add one.
int passwordScore(String password) {
  if (password.isEmpty) return 0;
  var score = 0;
  if (password.length >= 8) score += 1;
  if (RegExp('[a-z]').hasMatch(password) &&
      RegExp('[A-Z]').hasMatch(password)) {
    score += 1;
  }
  if (RegExp(r'\d').hasMatch(password)) score += 1;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 1;
  return math.max(score, 1);
}

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = HayatiTokens.of(context);
    final score = passwordScore(password);
    const colors = [
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF84CC16),
      Color(0xFF16A34A),
    ];
    final labels = [
      l10n.passwordWeak,
      l10n.passwordFair,
      l10n.passwordGood,
      l10n.passwordStrong,
    ];
    final color = score == 0
        ? theme.colorScheme.outlineVariant
        : colors[score - 1];
    return AnimatedOpacity(
      opacity: password.isEmpty ? 0 : 1,
      duration: tokens.motion(context, tokens.motionMedium),
      child: Semantics(
        label: score == 0 ? null : l10n.passwordStrength(labels[score - 1]),
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 10),
          child: Row(
            children: [
              for (var index = 0; index < 4; index++) ...[
                if (index > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: tokens.motion(context, tokens.motionMedium),
                    curve: tokens.easeOut,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index < score
                          ? color
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 10),
              SizedBox(
                width: 64,
                child: Text(
                  score == 0 ? '' : labels[score - 1],
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An error line that slides in and gives a small shake each time it changes.
class AuthErrorBanner extends StatefulWidget {
  const AuthErrorBanner({required this.message, super.key});

  final String? message;

  @override
  State<AuthErrorBanner> createState() => _AuthErrorBannerState();
}

class _AuthErrorBannerState extends State<AuthErrorBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void didUpdateWidget(AuthErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != null &&
        widget.message != oldWidget.message &&
        !MediaQuery.disableAnimationsOf(context)) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final message = widget.message;
    return AnimatedSwitcher(
      duration: tokens.motion(context, tokens.motionMedium),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: message == null
          ? const SizedBox(width: double.infinity)
          : AnimatedBuilder(
              key: const ValueKey('error'),
              animation: _shake,
              builder: (context, child) {
                final offset =
                    math.sin(_shake.value * math.pi * 6) *
                    8 *
                    (1 - _shake.value);
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 14),
                child: Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(12),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(tokens.radiusChip),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: scheme.onErrorContainer,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            message,
                            style: TextStyle(color: scheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// A primary button that swaps its label for a spinner while busy.
class BusyButton extends StatelessWidget {
  const BusyButton({
    required this.label,
    required this.busy,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = HayatiTokens.of(context);
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        child: AnimatedSwitcher(
          duration: tokens.motion(context, tokens.motionFast),
          child: busy
              ? const SizedBox.square(
                  key: ValueKey('busy'),
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  key: const ValueKey('label'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, size: 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// Two options on a pill with a sliding thumb.
class AuthModeSwitch extends StatelessWidget {
  const AuthModeSwitch({
    required this.labels,
    required this.index,
    required this.onChanged,
    super.key,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      height: 52,
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: tokens.motion(context, tokens.motionMedium),
            curve: tokens.checkOff,
            alignment: (index == 0) != rtl
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.cardTint,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (var option = 0; option < labels.length; option++)
                Expanded(
                  child: Semantics(
                    selected: option == index,
                    button: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => onChanged(option),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: tokens.motion(context, tokens.motionFast),
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: option == index
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                              ),
                          child: Text(labels[option]),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Six boxes over one hidden field, so paste and autofill still work.
class CodeBoxes extends StatefulWidget {
  const CodeBoxes({
    required this.controller,
    required this.label,
    this.length = 6,
    this.onCompleted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<CodeBoxes> createState() => _CodeBoxesState();
}

class _CodeBoxesState extends State<CodeBoxes> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
    _focus.addListener(_changed);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    _focus.dispose();
    super.dispose();
  }

  void _changed() {
    setState(() {});
    final text = widget.controller.text;
    if (text.length == widget.length) widget.onCompleted?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    final text = widget.controller.text;
    return Semantics(
      label: widget.label,
      textField: true,
      child: GestureDetector(
        onTap: _focus.requestFocus,
        child: Stack(
          children: [
            Opacity(
              opacity: 0,
              child: SizedBox(
                height: 56,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  maxLength: widget.length,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  showCursor: false,
                  decoration: const InputDecoration(counterText: ''),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  for (var index = 0; index < widget.length; index++) ...[
                    if (index > 0) const SizedBox(width: 8),
                    Expanded(
                      child: AnimatedContainer(
                        duration: tokens.motion(context, tokens.motionFast),
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: index < text.length
                              ? scheme.primary.withValues(alpha: 0.1)
                              : scheme.surfaceContainerHighest.withValues(
                                  alpha: 0.5,
                                ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                _focus.hasFocus &&
                                    index ==
                                        math.min(text.length, widget.length - 1)
                                ? scheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: AnimatedScale(
                          scale: index < text.length ? 1 : 0.4,
                          duration: tokens.motion(context, tokens.motionFast),
                          curve: tokens.checkOff,
                          child: Text(
                            index < text.length ? text[index] : '',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Counts down to [expiresAt] once a second.
class ExpiryCountdown extends StatefulWidget {
  const ExpiryCountdown({required this.expiresAt, super.key});

  final DateTime expiresAt;

  @override
  State<ExpiryCountdown> createState() => _ExpiryCountdownState();
}

class _ExpiryCountdownState extends State<ExpiryCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (!DateTime.now().isBefore(widget.expiresAt)) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final left = widget.expiresAt.difference(DateTime.now());
    if (left.isNegative || left == Duration.zero) {
      return Text(
        l10n.codeExpiredHint,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }
    final seconds = left.inSeconds;
    final label =
        '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 16,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(l10n.codeExpiresIn(label), style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            child: Text(
              AppLocalizations.of(context).orDivider,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

/// Icon-led reasons to create an account.
class BenefitList extends StatelessWidget {
  const BenefitList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = [
      (Icons.sync_rounded, const Color(0xFF0EA5E9), l10n.benefitSync),
      (Icons.shield_moon_outlined, const Color(0xFF8B5CF6), l10n.benefitBackup),
      (
        Icons.lock_outline_rounded,
        const Color(0xFF10B981),
        l10n.benefitPrivate,
      ),
    ];
    return Column(
      children: [
        for (final (index, (icon, color, label)) in items.indexed)
          StaggeredItem(
            index: index + 5,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(label, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
