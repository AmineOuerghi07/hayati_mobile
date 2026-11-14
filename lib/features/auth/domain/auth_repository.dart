import 'package:hayati/features/auth/domain/auth_models.dart';

abstract class AuthRepository {
  Stream<AuthSession> watch();

  Future<AuthUser> createAccount({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<OtpChallenge> requestOtp({required String destination});

  Future<AuthUser> verifyOtp({
    required String challengeId,
    required String code,
  });

  Future<OtpChallenge> requestPasswordReset({required String email});

  Future<void> resetPassword({
    required String challengeId,
    required String code,
    required String newPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> updateDisplayName(String displayName);

  Future<void> signOut();

  Future<void> deleteAccount({required String password});
}

String? validateEmail(String value) {
  final email = value.trim().toLowerCase();
  if (!email.contains('@') || !email.contains('.')) return 'invalidEmail';
  return null;
}

String? validatePassword(String value) {
  if (value.length < 8) return 'weakPassword';
  return null;
}
