import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/presentation/auth_providers.dart';
import 'package:hayati/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 32),
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(20),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

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
    return AuthScaffold(
      title: _creating ? l10n.createAccount : l10n.signIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_creating) ...[
            TextField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.displayName),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: l10n.email),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.password),
          ),
          if (_failure != null) ...[
            const SizedBox(height: 12),
            Text(
              authFailureMessage(l10n, _failure!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_creating ? l10n.createAccount : l10n.signIn),
          ),
          TextButton(
            onPressed: () => context.push('/auth/forgot'),
            child: Text(l10n.forgotPassword),
          ),
          TextButton(
            onPressed: () => context.push('/auth/otp'),
            child: Text(l10n.usePhoneCode),
          ),
          TextButton(
            onPressed: () => setState(() {
              _creating = !_creating;
              _failure = null;
            }),
            child: Text(_creating ? l10n.signIn : l10n.createAccount),
          ),
        ],
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
      if (mounted) context.pop();
    } on AuthFailure catch (failure) {
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
