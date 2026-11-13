import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/app/theme.dart';
import 'package:hayati/core/haptics.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/features/auth/presentation/auth_widgets.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  var _creating = false;
  var _busy = false;
  AuthFailure? _failure;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = HayatiTokens.of(context);
    return AuthScaffold(
      icon: _creating ? Icons.spa_rounded : Icons.waving_hand_rounded,
      title: _creating ? l10n.authCreateTitle : l10n.authSignInTitle,
      subtitle: _creating ? l10n.authCreateBody : l10n.authSignInBody,
      footer: Column(
        children: [
          const BenefitList(),
          const SizedBox(height: 8),
          TextButton(onPressed: () => context.pop(), child: Text(l10n.notNow)),
        ],
      ),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthModeSwitch(
              labels: [l10n.signIn, l10n.createAccount],
              index: _creating ? 1 : 0,
              onChanged: (index) => setState(() {
                _creating = index == 1;
                _failure = null;
              }),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: tokens.motion(context, tokens.motionMedium),
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _creating
                  ? Padding(
                      key: const ValueKey('name'),
                      padding: const EdgeInsetsDirectional.only(bottom: 12),
                      child: AuthField(
                        controller: _name,
                        label: l10n.displayName,
                        icon: Icons.person_outline_rounded,
                        autofillHints: const [AutofillHints.name],
                      ),
                    )
                  : const SizedBox(
                      key: ValueKey('no-name'),
                      width: double.infinity,
                    ),
            ),
            AuthField(
              controller: _email,
              label: l10n.email,
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 12),
            AuthField(
              controller: _password,
              label: l10n.password,
              icon: Icons.lock_outline_rounded,
              password: true,
              textInputAction: TextInputAction.done,
              autofillHints: [
                _creating ? AutofillHints.newPassword : AutofillHints.password,
              ],
              onChanged: (_) {
                if (_creating) setState(() {});
              },
              onSubmitted: (_) => _submit(),
            ),
            if (_creating) PasswordStrengthMeter(password: _password.text),
            if (!_creating)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => context.push('/auth/forgot'),
                  child: Text(l10n.forgotPassword),
                ),
              ),
            AuthErrorBanner(
              message: _failure == null
                  ? null
                  : authFailureMessage(l10n, _failure!),
            ),
            const SizedBox(height: 16),
            BusyButton(
              label: _creating ? l10n.createAccount : l10n.signIn,
              icon: Icons.arrow_forward_rounded,
              busy: _busy,
              onPressed: _submit,
            ),
            const OrDivider(),
            OutlinedButton.icon(
              onPressed: () => context.push('/auth/otp'),
              icon: const Icon(Icons.sms_outlined),
              label: Text(l10n.usePhoneCode),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _failure = null;
    });
    final auth = ref.read(authRepositoryProvider);
    try {
      if (_creating) {
        await auth.createAccount(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
      } else {
        await auth.signInWithEmail(
          email: _email.text,
          password: _password.text,
        );
      }
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

String authFailureMessage(AppLocalizations l10n, AuthFailure failure) {
  return switch (failure) {
    AuthFailure.invalidCredentials => l10n.invalidCredentials,
    AuthFailure.emailInUse => l10n.emailInUse,
    AuthFailure.invalidEmail => l10n.invalidEmail,
    AuthFailure.weakPassword => l10n.weakPassword,
    AuthFailure.invalidCode => l10n.invalidCode,
    AuthFailure.codeExpired => l10n.codeExpired,
    AuthFailure.accountNotFound => l10n.accountNotFound,
  };
}
