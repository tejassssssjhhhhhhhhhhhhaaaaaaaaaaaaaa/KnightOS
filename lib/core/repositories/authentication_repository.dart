import 'dart:async';
import '../storage/local_database.dart';
import '../storage/storage_keys.dart';

/// ROBUST AUTHENTICATION MODEL
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.displayName,
    this.email = 'owner@knight.os',
    this.isAuthenticated = true,
    this.isEmailVerified = true,
    this.provider = 'local',
    this.googleAccountEmail,
    this.photoUrl,
    this.expiresAt,
  });

  final String userId;
  final String displayName;
  final String email;
  final bool isAuthenticated;
  final bool isEmailVerified;
  final String provider;
  final String? googleAccountEmail;
  final String? photoUrl;
  final DateTime? expiresAt;
  
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    'email': email,
    'isAuthenticated': isAuthenticated,
    'isEmailVerified': isEmailVerified,
    'provider': provider,
    'googleAccountEmail': googleAccountEmail,
    'photoUrl': photoUrl,
    'expiresAt': expiresAt?.toIso8601String(),
  };

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    userId: json['userId'] as String? ?? 'local-owner',
    displayName: json['displayName'] as String? ?? 'System Owner',
    email: json['email'] as String? ?? 'owner@knight.os',
    isAuthenticated: json['isAuthenticated'] as bool? ?? true,
    isEmailVerified: json['isEmailVerified'] as bool? ?? true,
    provider: json['provider'] as String? ?? 'local',
    googleAccountEmail: json['googleAccountEmail'] as String?,
    photoUrl: json['photoUrl'] as String?,
    expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt'] as String) : null,
  );

  AuthSession copyWith({
    String? displayName,
    String? googleAccountEmail,
  }) {
    return AuthSession(
      userId: userId,
      displayName: displayName ?? this.displayName,
      email: email,
      isAuthenticated: isAuthenticated,
      isEmailVerified: isEmailVerified,
      provider: provider,
      googleAccountEmail: googleAccountEmail ?? this.googleAccountEmail,
      expiresAt: expiresAt,
    );
  }
}

class AuthenticationRepository {
  AuthenticationRepository();

  static AuthenticationRepository instance = AuthenticationRepository();

  final _db = const LocalDatabase();

  Future<AuthSession?> getCurrentSession() async {
    final json = await _db.readJson(StorageKeys.authSession);
    if (json == null) return null;
    return AuthSession.fromJson(json);
  }

  Future<bool> isAuthenticated() async {
    final session = await getCurrentSession();
    return session != null && session.isAuthenticated;
  }

  Future<AuthSession> signIn({required String email, required String password}) async {
    final accounts = await _db.readJson(StorageKeys.authAccounts) ?? {};
    if (!accounts.containsKey(email)) {
      throw ArgumentError('No account exists with this email.');
    }
    
    final accountData = accounts[email] as Map<String, dynamic>;
    if (accountData['password'] != password) {
      throw ArgumentError('Incorrect email or password.');
    }

    final session = AuthSession(
      userId: accountData['userId'] as String,
      displayName: accountData['displayName'] as String,
      email: email,
    );
    await persistSession(session);
    return session;
  }

  Future<AuthSession> signUp({required String email, required String password, String displayName = ''}) async {
    final accounts = await _db.readJson(StorageKeys.authAccounts) ?? {};
    final userId = 'user-${DateTime.now().millisecondsSinceEpoch}';
    
    accounts[email] = {
      'userId': userId,
      'password': password,
      'displayName': displayName,
    };
    
    await _db.writeJson(StorageKeys.authAccounts, Map<String, dynamic>.from(accounts));
    
    final session = AuthSession(
      userId: userId,
      displayName: displayName,
      email: email,
    );
    await persistSession(session);
    return session;
  }

  Future<void> connectGoogle(String googleEmail) async {
    final session = await getCurrentSession();
    if (session == null) throw Exception('No active session');
    
    final updatedSession = session.copyWith(googleAccountEmail: googleEmail);
    await persistSession(updatedSession);
  }

  Future<bool> isGoogleConnected() async {
    final session = await getCurrentSession();
    return session?.googleAccountEmail != null;
  }

  Future<void> disconnectGoogle() async {
    final session = await getCurrentSession();
    if (session == null) return;
    
    final updatedSession = AuthSession(
      userId: session.userId,
      displayName: session.displayName,
      email: session.email,
      googleAccountEmail: null,
    );
    await persistSession(updatedSession);
  }

  Future<void> resetPassword(String email) async {}

  Future<void> signOut() async {
    await _db.delete(StorageKeys.authSession);
  }

  Future<void> persistSession(AuthSession session) async {
    await _db.writeJson(StorageKeys.authSession, session.toJson());
  }
}
