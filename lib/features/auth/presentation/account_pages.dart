import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/auth/presentation/auth_widgets.dart';
import 'package:hayati/features/auth/presentation/sign_in_page.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _destination = TextEditingController();
  final _code = TextEditingController();
  OtpChallenge? _challenge;
  AuthFailure? _failure;
  var _busy = false;

  @override
  void dispose() {
    _destination.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final challenge = _challenge;
    final showCode =
        ref.watch(appConfigProvider).isDev && challenge?.devCode != null;
    return AuthScaffold(
      icon: challenge == null
          ? Icons.sms_outlined
          : Icons.mark_email_read_outlined,
      title: l10n.usePhoneCode,
      subtitle: challenge == null
          ? l10n.otpBody
          : l10n.codeSentTo(challenge.destination),
      child: AnimatedSwitcher(
        duration: tokens.motion(context, tokens.motionMedium),
        transitionBuilder: _slide,
        child: challenge == null
            ? Column(
                key: const ValueKey('send'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthField(
                    controller: _destination,
                    label: l10n.emailOrPhone,
                    icon: Icons.contact_mail_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _request(),
                  ),
                  AuthErrorBanner(message: _message(l10n)),
                  const SizedBox(height: 16),
                  BusyButton(
                    label: l10n.sendCode,
                    icon: Icons.send_rounded,
                    busy: _busy,
                    onPressed: _request,
                  ),
                ],
              )
            : Column(
                key: const ValueKey('verify'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showCode) _DemoCode(code: challenge.devCode!),
                  CodeBoxes(
                    controller: _code,
                    label: l10n.verifyCode,
                    onCompleted: (_) => _verify(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ExpiryCountdown(
                        key: ValueKey(challenge.id),
                        expiresAt: challenge.expiresAt,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _busy ? null : _request,
                        child: Text(l10n.resendCode),
                      ),
                    ],
                  ),
                  AuthErrorBanner(message: _message(l10n)),
                  const SizedBox(height: 12),
                  BusyButton(
                    label: l10n.verifyCode,
                    icon: Icons.verified_outlined,
                    busy: _busy,
                    onPressed: _verify,
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _challenge = null;
                      _code.clear();
                      _failure = null;
                    }),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.changeDestination),
                  ),
                ],
              ),
      ),
    );
  }

  String? _message(AppLocalizations l10n) =>
      _failure == null ? null : authFailureMessage(l10n, _failure!);

  Future<void> _request() async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestOtp(destination: _destination.text);
      _code.clear();
      setState(() => _challenge = challenge);
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final challenge = _challenge;
    if (challenge == null || _busy) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyOtp(challengeId: challenge.id, code: _code.text);
      playHaptic(strong: true);
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
      playHaptic();
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  OtpChallenge? _challenge;
  AuthFailure? _failure;
  var _busy = false;
  var _done = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    final challenge = _challenge;
    final showCode =
        ref.watch(appConfigProvider).isDev && challenge?.devCode != null;
    final step = _done ? 3 : (challenge == null ? 1 : 2);
    return AuthScaffold(
      icon: _done ? Icons.lock_open_rounded : Icons.key_rounded,
      title: _done ? l10n.passwordUpdated : l10n.forgotPassword,
      subtitle: _done
          ? l10n.passwordUpdatedBody
          : challenge == null
          ? l10n.resetHint
          : l10n.codeSentTo(challenge.destination),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepDots(step: step, total: 3),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: tokens.motion(context, tokens.motionMedium),
            transitionBuilder: _slide,
            child: switch (step) {
              1 => Column(
                key: const ValueKey(1),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthField(
                    controller: _email,
                    label: l10n.email,
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _request(),
                  ),
                  AuthErrorBanner(message: _message(l10n)),
                  const SizedBox(height: 16),
                  BusyButton(
                    label: l10n.sendCode,
                    icon: Icons.send_rounded,
                    busy: _busy,
                    onPressed: _request,
                  ),
                ],
              ),
              2 => Column(
                key: const ValueKey(2),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showCode) _DemoCode(code: challenge!.devCode!),
                  CodeBoxes(controller: _code, label: l10n.verifyCode),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ExpiryCountdown(
                      key: ValueKey(challenge!.id),
                      expiresAt: challenge.expiresAt,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    controller: _password,
                    label: l10n.newPassword,
                    icon: Icons.lock_reset_rounded,
                    password: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _reset(),
                  ),
                  PasswordStrengthMeter(password: _password.text),
                  AuthErrorBanner(message: _message(l10n)),
                  const SizedBox(height: 16),
                  BusyButton(
                    label: l10n.save,
                    icon: Icons.check_rounded,
                    busy: _busy,
                    onPressed: _reset,
                  ),
                ],
              ),
              _ => Column(
                key: const ValueKey(3),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SuccessBadge(),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.signIn),
                  ),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }

  String? _message(AppLocalizations l10n) =>
      _failure == null ? null : authFailureMessage(l10n, _failure!);

  Future<void> _request() async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(email: _email.text);
      setState(() => _challenge = challenge);
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reset() async {
    final challenge = _challenge;
    if (challenge == null) return;
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            challengeId: challenge.id,
            code: _code.text,
            newPassword: _password.text,
          );
      playHaptic(strong: true);
      setState(() => _done = true);
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  AuthFailure? _failure;
  var _busy = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthScaffold(
      icon: Icons.password_rounded,
      title: l10n.changePassword,
      subtitle: l10n.changePasswordBody,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: _current,
              label: l10n.currentPassword,
              icon: Icons.lock_outline_rounded,
              password: true,
              autofillHints: const [AutofillHints.password],
            ),
            const SizedBox(height: 12),
            AuthField(
              controller: _next,
              label: l10n.newPassword,
              icon: Icons.lock_reset_rounded,
              password: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _save(),
            ),
            PasswordStrengthMeter(password: _next.text),
            AuthErrorBanner(
              message: _failure == null
                  ? null
                  : authFailureMessage(l10n, _failure!),
            ),
            const SizedBox(height: 20),
            BusyButton(
              label: l10n.save,
              icon: Icons.check_rounded,
              busy: _busy,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(
            currentPassword: _current.text,
            newPassword: _next.text,
          );
      playHaptic(strong: true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.passwordUpdated)));
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

Widget _slide(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tokens = HayatiTokens.of(context);
    return Semantics(
      label: l10n.stepOf(step, total),
      excludeSemantics: true,
      child: Row(
        children: [
          for (var index = 1; index <= total; index++) ...[
            if (index > 1) const SizedBox(width: 6),
            Expanded(
              child: AnimatedContainer(
                duration: tokens.motion(context, tokens.motionMedium),
                curve: tokens.easeOut,
                height: 6,
                decoration: BoxDecoration(
                  color: index <= step
                      ? scheme.primary
                      : scheme.outlineVariant.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DemoCode extends StatelessWidget {
  const _DemoCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              Icons.developer_mode_rounded,
              color: scheme.onTertiaryContainer,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${l10n.localDemoCode}: $code',
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduce ? 1 : 0, end: 1),
        duration: reduce ? Duration.zero : const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, t, child) =>
            Transform.scale(scale: 0.4 + 0.6 * t, child: child),
        child: Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF16A34A),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
        ),
      ),
    );
  }
}
