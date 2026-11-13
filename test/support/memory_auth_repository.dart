import 'dart:async';

import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/domain/auth_repository.dart';

class MemoryAuthRepository implements AuthRepository {
  final AuthSession _session = const AuthSession.guest();
  final _updates = StreamController<AuthSession>.broadcast();

  @override
  Stream<AuthSession> watch() async* {
    yield _session;
    yield* _updates.stream;
  }

  @override
  Future<AuthUser> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) => throw UnimplementedError();

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<OtpChallenge> requestOtp({required String destination}) =>
      throw UnimplementedError();

  @override
  Future<AuthUser> verifyOtp({
    required String challengeId,
    required String code,
  }) => throw UnimplementedError();

  @override
  Future<OtpChallenge> requestPasswordReset({required String email}) =>
      throw UnimplementedError();

  @override
  Future<void> resetPassword({
    required String challengeId,
    required String code,
    required String newPassword,
  }) => throw UnimplementedError();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount({required String password}) async {}
}
