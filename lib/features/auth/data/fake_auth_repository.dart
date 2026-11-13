import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:hayati/core/database/app_database.dart';
import 'package:hayati/core/database/data_scope.dart';
import 'package:hayati/features/auth/domain/auth_models.dart';
import 'package:hayati/features/auth/domain/auth_repository.dart';
import 'package:uuid/uuid.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this._db, {Uuid? uuid, Random? random})
    : _uuid = uuid ?? const Uuid(),
      _random = random ?? Random();

  final AppDatabase _db;
  final Uuid _uuid;
  final Random _random;

  static const sessionKey = 'sessionUserId';

  @override
  Stream<AuthSession> watch() async* {
    yield await _session();
    await for (final _ in _db.select(_db.appSettings).watch()) {
      yield await _session();
    }
  }

  @override
  Future<AuthUser> createAccount({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (validateEmail(normalized) != null) throw AuthFailure.invalidEmail;
    if (validatePassword(password) != null) throw AuthFailure.weakPassword;
    if (await _byEmail(normalized) != null) throw AuthFailure.emailInUse;
    final user = await _insertAccount(
      email: normalized,
      displayName: displayName.trim().isEmpty ? normalized : displayName.trim(),
      password: password,
    );
    await _enter(user.id);
    return user;
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final account = await _byEmail(email.trim().toLowerCase());
    if (account == null || !_passwordMatches(account, password)) {
      throw AuthFailure.invalidCredentials;
    }
    await _enter(account.id);
    return _user(account);
  }

  @override
  Future<OtpChallenge> requestOtp({required String destination}) async {
    final target = destination.trim();
    if (target.length < 5) throw AuthFailure.invalidEmail;
    return _issue(purpose: 'signIn', destination: target.toLowerCase());
  }

  @override
  Future<AuthUser> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    final challenge = await _consume(challengeId, code, purpose: 'signIn');
    var account =
        await _byEmail(challenge.destination) ??
        await _byPhone(challenge.destination);
    account ??= await _insertRow(
      email: challenge.destination.contains('@') ? challenge.destination : null,
      phone: challenge.destination.contains('@') ? null : challenge.destination,
      displayName: challenge.destination,
      password: null,
    );
    final user = _user(account);
    await _enter(user.id);
    return user;
  }

  @override
  Future<OtpChallenge> requestPasswordReset({required String email}) async {
    final normalized = email.trim().toLowerCase();
    if (validateEmail(normalized) != null) throw AuthFailure.invalidEmail;
    final account = await _byEmail(normalized);
    if (account == null) {
      return OtpChallenge(
        id: _uuid.v4(),
        destination: normalized,
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      );
    }
    return _issue(purpose: 'reset', destination: normalized);
  }

  @override
  Future<void> resetPassword({
    required String challengeId,
    required String code,
    required String newPassword,
  }) async {
    if (validatePassword(newPassword) != null) throw AuthFailure.weakPassword;
    final challenge = await _consume(challengeId, code, purpose: 'reset');
    final account = await _byEmail(challenge.destination);
    if (account == null) throw AuthFailure.accountNotFound;
    await _setPassword(account.id, newPassword);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (validatePassword(newPassword) != null) throw AuthFailure.weakPassword;
    final account = await _currentAccount();
    if (account == null) throw AuthFailure.accountNotFound;
    if (account.passwordHash != null &&
        !_passwordMatches(account, currentPassword)) {
      throw AuthFailure.invalidCredentials;
    }
    await _setPassword(account.id, newPassword);
  }

  @override
  Future<void> signOut() async {
    await _writeSetting(sessionKey, '');
    await DataScope(_db, uuid: _uuid).openFreshGuest();
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    final account = await _currentAccount();
    if (account == null || !_passwordMatches(account, password)) {
      throw AuthFailure.invalidCredentials;
    }
    await (_db.update(
      _db.localAccounts,
    )..where((row) => row.id.equals(account.id))).write(
      LocalAccountsCompanion(deletedAt: Value(DateTime.now().toUtc())),
    );
    await signOut();
  }

  Future<void> _enter(String userId) async {
    await DataScope(_db, uuid: _uuid).attachCurrentGuestTo(userId);
    await _writeSetting(sessionKey, userId);
  }

  Future<OtpChallenge> _issue({
    required String purpose,
    required String destination,
  }) async {
    final code = (_random.nextInt(900000) + 100000).toString();
    final id = _uuid.v4();
    final expires = DateTime.now().toUtc().add(const Duration(minutes: 5));
    await _db
        .into(_db.authChallenges)
        .insert(
          AuthChallengesCompanion.insert(
            id: id,
            purpose: purpose,
            destination: destination,
            codeHash: _hash(code, id),
            expiresAt: expires,
          ),
        );
    return OtpChallenge(
      id: id,
      destination: destination,
      expiresAt: expires,
      devCode: code,
    );
  }

  Future<ChallengeRow> _consume(
    String challengeId,
    String code, {
    required String purpose,
  }) async {
    final row =
        await (_db.select(_db.authChallenges)..where(
              (item) =>
                  item.id.equals(challengeId) & item.purpose.equals(purpose),
            ))
            .getSingleOrNull();
    if (row == null || row.consumedAt != null) throw AuthFailure.invalidCode;
    if (row.expiresAt.isBefore(DateTime.now().toUtc())) {
      throw AuthFailure.codeExpired;
    }
    if (row.codeHash != _hash(code.trim(), row.id)) {
      await (_db.update(_db.authChallenges)
            ..where((item) => item.id.equals(row.id)))
          .write(AuthChallengesCompanion(attempts: Value(row.attempts + 1)));
      throw AuthFailure.invalidCode;
    }
    await (_db.update(
      _db.authChallenges,
    )..where((item) => item.id.equals(row.id))).write(
      AuthChallengesCompanion(consumedAt: Value(DateTime.now().toUtc())),
    );
    return row;
  }

  Future<AuthUser> _insertAccount({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final row = await _insertRow(
      email: email,
      phone: null,
      displayName: displayName,
      password: password,
    );
    return _user(row);
  }

  Future<AccountRow> _insertRow({
    required String? email,
    required String? phone,
    required String displayName,
    required String? password,
  }) async {
    final id = _uuid.v4();
    final salt = password == null ? null : _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.localAccounts)
        .insert(
          LocalAccountsCompanion.insert(
            id: id,
            email: Value(email),
            phone: Value(phone),
            displayName: displayName,
            passwordSalt: Value(salt),
            passwordHash: Value(
              password == null ? null : _hash(password, salt!),
            ),
            createdAt: now,
          ),
        );
    return (await (_db.select(
      _db.localAccounts,
    )..where((row) => row.id.equals(id))).getSingle());
  }

  Future<void> _setPassword(String id, String password) async {
    final salt = _uuid.v4();
    await (_db.update(
      _db.localAccounts,
    )..where((row) => row.id.equals(id))).write(
      LocalAccountsCompanion(
        passwordSalt: Value(salt),
        passwordHash: Value(_hash(password, salt)),
      ),
    );
  }

  Future<AccountRow?> _byEmail(String email) {
    return (_db.select(_db.localAccounts)
          ..where((row) => row.email.equals(email) & row.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<AccountRow?> _byPhone(String phone) {
    return (_db.select(_db.localAccounts)
          ..where((row) => row.phone.equals(phone) & row.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<AccountRow?> _currentAccount() async {
    final id = await _setting(sessionKey);
    if (id == null || id.isEmpty) return null;
    return (_db.select(_db.localAccounts)
          ..where((row) => row.id.equals(id) & row.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<AuthSession> _session() async {
    final account = await _currentAccount();
    if (account == null) return const AuthSession.guest();
    return AuthSession.signedIn(_user(account));
  }

  AuthUser _user(AccountRow row) {
    return AuthUser(
      id: row.id,
      displayName: row.displayName,
      email: row.email,
      phone: row.phone,
      hasPassword: row.passwordHash != null,
    );
  }

  bool _passwordMatches(AccountRow row, String password) {
    if (row.passwordSalt == null || row.passwordHash == null) return false;
    return row.passwordHash == _hash(password, row.passwordSalt!);
  }

  String _hash(String value, String salt) {
    final digest = sha256.convert(utf8.encode('$salt:$value'));
    return digest.toString();
  }

  Future<String?> _setting(String key) async {
    final row =
        await (_db.select(_db.appSettings)..where(
              (item) => item.settingKey.equals(key) & item.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return row?.settingValue;
  }

  Future<void> _writeSetting(String key, String value) async {
    final now = DateTime.now().toUtc();
    final existing =
        await (_db.select(_db.appSettings)..where(
              (row) => row.settingKey.equals(key) & row.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              id: _uuid.v4(),
              createdAt: now,
              updatedAt: now,
              settingKey: key,
              settingValue: value,
            ),
          );
      return;
    }
    await (_db.update(
      _db.appSettings,
    )..where((row) => row.id.equals(existing.id))).write(
      AppSettingsCompanion(settingValue: Value(value), updatedAt: Value(now)),
    );
  }
}
