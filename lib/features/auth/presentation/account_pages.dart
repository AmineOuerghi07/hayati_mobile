import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/core/config/app_config_provider.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
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
    final showCode =
        ref.watch(appConfigProvider).isDev && _challenge?.devCode != null;
    return AuthScaffold(
      title: l10n.usePhoneCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _destination,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.emailOrPhone),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _busy ? null : _request,
            child: Text(l10n.sendCode),
          ),
          if (showCode) ...[
            const SizedBox(height: 16),
            Material(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Text('${l10n.localDemoCode}: ${_challenge!.devCode}'),
              ),
            ),
          ],
          if (_challenge != null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: l10n.verifyCode),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _verify,
              child: Text(l10n.verifyCode),
            ),
          ],
          if (_failure != null) ...[
            const SizedBox(height: 12),
            Text(
              authFailureMessage(l10n, _failure!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _request() async {
    setState(() => _busy = true);
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestOtp(destination: _destination.text);
      setState(() => _challenge = challenge);
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final challenge = _challenge;
    if (challenge == null) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyOtp(challengeId: challenge.id, code: _code.text);
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
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
    final showCode =
        ref.watch(appConfigProvider).isDev && _challenge?.devCode != null;
    return AuthScaffold(
      title: l10n.forgotPassword,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.resetHint),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            decoration: InputDecoration(labelText: l10n.email),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _request, child: Text(l10n.sendCode)),
          if (showCode)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 12),
              child: Text('${l10n.localDemoCode}: ${_challenge!.devCode}'),
            ),
          if (_challenge != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _code,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: l10n.verifyCode),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPassword),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _reset, child: Text(l10n.save)),
          ],
          if (_failure != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 12),
              child: Text(
                authFailureMessage(l10n, _failure!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _request() async {
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(email: _email.text);
      setState(() {
        _challenge = challenge;
        _failure = null;
      });
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    }
  }

  Future<void> _reset() async {
    final challenge = _challenge;
    if (challenge == null) return;
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            challengeId: challenge.id,
            code: _code.text,
            newPassword: _password.text,
          );
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
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
      title: l10n.changePassword,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _current,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.currentPassword),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _next,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.newPassword),
          ),
          if (_failure != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 12),
              child: Text(
                authFailureMessage(l10n, _failure!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
    );
  }

  Future<void> _save() async {
    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(
            currentPassword: _current.text,
            newPassword: _next.text,
          );
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
      setState(() => _failure = failure);
    }
  }
}
