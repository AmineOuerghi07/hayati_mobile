class AuthUser {
  const AuthUser({
    required this.id,
    required this.displayName,
    this.email,
    this.phone,
    required this.hasPassword,
  });

  final String id;
  final String displayName;
  final String? email;
  final String? phone;
  final bool hasPassword;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    final letters = parts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0]);
    final value = letters.join();
    return value.isEmpty ? '?' : value.toUpperCase();
  }
}

class AuthSession {
  const AuthSession.guest() : user = null;
  const AuthSession.signedIn(this.user);

  final AuthUser? user;
  bool get isGuest => user == null;
}

class OtpChallenge {
  const OtpChallenge({
    required this.id,
    required this.destination,
    required this.expiresAt,
    this.devCode,
  });

  final String id;
  final String destination;
  final DateTime expiresAt;

  /// Present only for the local demo authenticator. Never an SMS.
  final String? devCode;
}

enum AuthFailure {
  invalidCredentials,
  emailInUse,
  invalidEmail,
  weakPassword,
  invalidCode,
  codeExpired,
  accountNotFound,
}
