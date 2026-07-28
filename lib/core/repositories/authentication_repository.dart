/// Authentication and session management logic.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/local_database.dart';
import '../storage/storage_keys.dart';
import '../internal/utils/knight_logger.dart';

/// Represents an active authentication session.
class AuthSession {
  /// Creates an [AuthSession].
  const AuthSession({
    required this.userId,
    required this.email,
    required this.displayName,
    this.isAuthenticated = true,
    this.isEmailVerified = true,
    this.provider = 'local',
    this.expiresAt,
  });

  /// The unique identifier of the user.
  final String userId;

  /// The email address of the user.
  final String email;

  /// The display name of the user.
  final String displayName;

  /// Whether the user is currently authenticated.
  final bool isAuthenticated;

  /// Whether the user's email has been verified.
  final bool isEmailVerified;

  /// The authentication provider (e.g., 'local', 'google').
  final String provider;

  /// The timestamp when the session expires.
  final DateTime? expiresAt;

  /// Converts the session to a JSON-compatible map.
  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'isAuthenticated': isAuthenticated,
      'isEmailVerified': isEmailVerified,
      'provider': provider,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  /// Creates an [AuthSession] from a JSON map.
  factory AuthSession.fromJson(Map<String, Object?> json) {
    return AuthSession(
      userId: json['userId'] as String? ?? 'local-user',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Knight User',
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      provider: json['provider'] as String? ?? 'local',
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.tryParse(json['expiresAt'] as String),
    );
  }
}

/// Repository responsible for user authentication and session management.
///
/// This repository handles sign-in, sign-up, password resets, and persistence
/// of authentication state using secure storage and local database fallbacks.
class AuthenticationRepository {
  /// Internal constructor for singleton.
  AuthenticationRepository._({
    LocalDatabase? localDatabase,
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _database = localDatabase ?? const LocalDatabase();

  /// Singleton instance.
  static AuthenticationRepository _instance = AuthenticationRepository._();

  static AuthenticationRepository get instance => _instance;

  @visibleForTesting
  static set instance(AuthenticationRepository mock) => _instance = mock;

  /// Public factory for legacy compatibility (returns same instance).
  factory AuthenticationRepository({
    LocalDatabase? localDatabase,
    FlutterSecureStorage? secureStorage,
  }) {
    return instance;
  }

  final FlutterSecureStorage _secureStorage;
  final LocalDatabase _database;
  final Map<String, _StoredAccount> _accounts = <String, _StoredAccount>{};

  Future<Map<String, _StoredAccount>> _loadAccounts() async {
    if (_accounts.isNotEmpty) {
      return _accounts;
    }

    final securePayload = await _secureStorage.read(
      key: StorageKeys.authAccounts,
    );
    final fallbackPayload = securePayload == null || securePayload.isEmpty
        ? await _database.readString(StorageKeys.authAccounts)
        : null;
    final payload = securePayload ?? fallbackPayload;

    if (payload == null || payload.isEmpty) {
      return _accounts;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! List<dynamic>) {
        return _accounts;
      }

      for (final item in decoded) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final account = _StoredAccount.fromJson(item.cast<String, Object?>());
        _accounts[account.email] = account;
      }
    } catch (error) {
      KnightLogger.error(
        'Unable to decode persisted accounts: $error',
        error: error,
        category: KnightLogCategory.repository,
      );
    }
    return _accounts;
  }

  /// Returns the current active session, if any.
  ///
  /// Returns null if no session exists or if the current session has expired.
  Future<AuthSession?> getCurrentSession() async {
    try {
      final payload = await _readPersistedValue(
        StorageKeys.authSession,
      ).timeout(const Duration(milliseconds: 300));
      if (payload == null || payload.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        await _secureStorage
            .delete(key: StorageKeys.authSession)
            .timeout(const Duration(milliseconds: 300));
        return null;
      }

      final session = AuthSession.fromJson(decoded.cast<String, Object?>());
      if (session.expiresAt != null &&
          DateTime.now().isAfter(session.expiresAt!)) {
        await _secureStorage
            .delete(key: StorageKeys.authSession)
            .timeout(const Duration(milliseconds: 300));
        return null;
      }
      return session;
    } on TimeoutException catch (error) {
      KnightLogger.warn(
        'Authentication session lookup timed out: $error',
        category: KnightLogCategory.repository,
      );
      return null;
    } catch (error) {
      KnightLogger.error(
        'Unable to read persisted auth session: $error',
        error: error,
        category: KnightLogCategory.repository,
      );
      return null;
    }
  }

  /// Returns whether a user is currently authenticated.
  Future<bool> isAuthenticated() async {
    try {
      final session = await getCurrentSession().timeout(
        const Duration(milliseconds: 300),
      );
      return session?.isAuthenticated ?? false;
    } on TimeoutException catch (error) {
      KnightLogger.warn(
        'Authentication check timed out: $error',
        category: KnightLogCategory.repository,
      );
      return false;
    } catch (error) {
      KnightLogger.error(
        'Authentication check failed: $error',
        error: error,
        category: KnightLogCategory.repository,
      );
      return false;
    }
  }

  /// Signs in a user with the supplied credentials.
  ///
  /// Throws [ArgumentError] if the credentials are invalid or if no account exists.
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = await _loadAccounts();
    if (normalizedEmail.isEmpty || password.trim().isEmpty) {
      throw ArgumentError('Email and password are required.');
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw ArgumentError('Enter a valid email address.');
    }

    final account = accounts[normalizedEmail];
    if (account == null) {
      throw ArgumentError('No account exists with this email.');
    }
    if (account.password != password) {
      throw ArgumentError('Incorrect email or password.');
    }

    final session = AuthSession(
      userId: account.userId,
      email: normalizedEmail,
      displayName: account.displayName,
      isAuthenticated: true,
      isEmailVerified: true,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
    await _persistSession(session);
    return session;
  }

  /// Registers a new user account.
  ///
  /// Throws [ArgumentError] if the registration data is invalid or if the email
  /// is already in use.
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.trim().isEmpty) {
      throw ArgumentError('Email and password are required.');
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw ArgumentError('Enter a valid email address.');
    }
    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters.');
    }
    final accounts = await _loadAccounts();
    if (accounts.containsKey(normalizedEmail)) {
      throw ArgumentError('An account already exists with this email.');
    }

    final account = _StoredAccount(
      userId:
          'user-${normalizedEmail.replaceAll(RegExp(r'[^a-z0-9]'), '')}-${DateTime.now().microsecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: displayName.trim().isEmpty
          ? normalizedEmail.split('@').first
          : displayName.trim(),
      password: password,
    );
    _accounts[normalizedEmail] = account;
    await _persistAccounts();

    final session = AuthSession(
      userId: account.userId,
      email: normalizedEmail,
      displayName: account.displayName,
      isAuthenticated: true,
      isEmailVerified: false,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
    await _persistSession(session);
    return session;
  }

  Future<void> resetPassword(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Enter an email address to reset your password.');
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw ArgumentError('Enter a valid email address.');
    }
    final accounts = await _loadAccounts();
    if (accounts[normalizedEmail] == null) {
      throw ArgumentError('No account exists with this email.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (kDebugMode) {
      debugPrint('Password reset requested for $email');
    }
  }

  Future<void> verifyEmail({String? code}) async {
    final session = await getCurrentSession();
    if (session == null) {
      return;
    }
    await persistSession(
      AuthSession(
        userId: session.userId,
        email: session.email,
        displayName: session.displayName,
        isAuthenticated: true,
        isEmailVerified: true,
        provider: session.provider,
      ),
    );
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: StorageKeys.authSession);
    await _database.delete(StorageKeys.authSession);
  }

  Future<void> persistSession(AuthSession session) async {
    await _persistSession(session);
  }

  Future<void> _persistSession(AuthSession session) async {
    final payload = jsonEncode(session.toJson());
    await _writePersistedValue(StorageKeys.authSession, payload);
  }

  Future<void> _persistAccounts() async {
    final payload = jsonEncode(
      _accounts.values.map((account) => account.toJson()).toList(),
    );
    await _writePersistedValue(StorageKeys.authAccounts, payload);
  }

  Future<String?> _readPersistedValue(String key) async {
    try {
      final secureValue = await _secureStorage
          .read(key: key)
          .timeout(const Duration(milliseconds: 300));
      if (secureValue != null && secureValue.isNotEmpty) {
        return secureValue;
      }
      return await _database
          .readString(key)
          .timeout(const Duration(milliseconds: 300));
    } on TimeoutException catch (error) {
      debugPrint('Persisted value read timed out for $key: $error');
      return null;
    } catch (error) {
      debugPrint('Unable to read persisted value for $key: $error');
      return null;
    }
  }

  Future<void> _writePersistedValue(String key, String value) async {
    try {
      await _secureStorage
          .write(key: key, value: value)
          .timeout(const Duration(milliseconds: 300));
      await _database
          .writeString(key, value)
          .timeout(const Duration(milliseconds: 300));
    } on TimeoutException catch (error) {
      debugPrint('Persisted value write timed out for $key: $error');
    } catch (error) {
      debugPrint('Unable to write persisted value for $key: $error');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}

class _StoredAccount {
  const _StoredAccount({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.password,
  });

  final String userId;
  final String email;
  final String displayName;
  final String password;

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'password': password,
    };
  }

  factory _StoredAccount.fromJson(Map<String, Object?> json) {
    return _StoredAccount(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}
