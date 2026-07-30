/// Authentication and session management logic.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  /// Public factory for legacy compatibility.
  factory AuthenticationRepository({
    LocalDatabase? localDatabase,
    FlutterSecureStorage? secureStorage,
  }) {
    return instance;
  }

  final FlutterSecureStorage _secureStorage;
  final LocalDatabase _database;
  final Map<String, _StoredAccount> _accounts = <String, _StoredAccount>{};
  AuthSession? _currentSession;
  bool _sessionLoaded = false;

  Future<Map<String, _StoredAccount>> _loadAccounts() async {
    if (_accounts.isNotEmpty) {
      return _accounts;
    }

    KnightLogger.info('[AUTH] Loading accounts...');
    
    final payload = await _readPersistedValue(StorageKeys.authAccounts);

    if (payload == null || payload.isEmpty) {
      return _accounts;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is List) {
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            final account = _StoredAccount.fromJson(item.cast<String, Object?>());
            _accounts[account.email] = account;
          }
        }
      }
    } catch (error) {
      KnightLogger.error('Unable to decode accounts', error: error);
    }
    return _accounts;
  }

  Future<AuthSession?> getCurrentSession() async {
    if (_sessionLoaded) return _currentSession;

    try {
      final payload = await _readPersistedValue(StorageKeys.authSession);
      
      if (payload == null || payload.isEmpty) {
        _currentSession = null;
        _sessionLoaded = true;
        return null;
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        _currentSession = null;
        _sessionLoaded = true;
        return null;
      }

      final session = AuthSession.fromJson(decoded.cast<String, Object?>());
      if (session.expiresAt != null &&
          DateTime.now().isAfter(session.expiresAt!)) {
        _currentSession = null;
        _sessionLoaded = true;
        return null;
      }
      _currentSession = session;
      _sessionLoaded = true;
      return session;
    } catch (error) {
      KnightLogger.error('Unable to read session', error: error);
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final session = await getCurrentSession();
    return session?.isAuthenticated ?? false;
  }

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = await _loadAccounts();
    
    final account = accounts[normalizedEmail];
    if (account == null || account.password != password) {
      throw ArgumentError('Incorrect email or password.');
    }

    final session = AuthSession(
      userId: account.userId,
      email: normalizedEmail,
      displayName: account.displayName,
      isAuthenticated: true,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
    await _persistSession(session);
    return session;
  }

  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = await _loadAccounts();
    if (accounts.containsKey(normalizedEmail)) {
      throw ArgumentError('An account already exists.');
    }

    final account = _StoredAccount(
      userId: 'user-${DateTime.now().microsecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: displayName.isEmpty ? normalizedEmail.split('@').first : displayName,
      password: password,
    );
    _accounts[normalizedEmail] = account;
    await _persistAccounts();

    final session = AuthSession(
      userId: account.userId,
      email: normalizedEmail,
      displayName: account.displayName,
      isAuthenticated: true,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
    await _persistSession(session);
    return session;
  }

  Future<void> resetPassword(String email) async {
    KnightLogger.info('[AUTH] Reset password requested for $email');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> persistSession(AuthSession session) async {
    await _persistSession(session);
  }

  Future<void> signOut() async {
    await _writePersistedValue(StorageKeys.authSession, '');
    _currentSession = null;
    _sessionLoaded = true;
  }

  Future<void> _persistSession(AuthSession session) async {
    final payload = jsonEncode(session.toJson());
    await _writePersistedValue(StorageKeys.authSession, payload);
    _currentSession = session;
    _sessionLoaded = true;
  }

  Future<void> _persistAccounts() async {
    final payload = jsonEncode(
      _accounts.values.map((account) => account.toJson()).toList(),
    );
    await _writePersistedValue(StorageKeys.authAccounts, payload);
  }

  /// ROBUST PERSISTENCE:
  /// Uses FlutterSecureStorage with a strict timeout to prevent hangs on 
  /// problematic Android Keystore implementations (e.g. Xiaomi/Mediatek).
  /// Falls back to non-encrypted LocalDatabase for reliability.
  Future<String?> _readPersistedValue(String key) async {
    try {
      // 1. Attempt Secure Read (Fast Timeout)
      final secureValue = await _secureStorage
          .read(key: key)
          .timeout(const Duration(milliseconds: 500));
      
      if (secureValue != null && secureValue.isNotEmpty) return secureValue;
    } catch (e) {
      KnightLogger.warn('Secure storage read bypassed/failed: $e');
    }

    // 2. Fallback to LocalDatabase
    try {
      return await _database
          .readString(key)
          .timeout(const Duration(seconds: 1));
    } catch (e) {
      KnightLogger.error('Storage fallback failed: $e');
      return null;
    }
  }

  Future<void> _writePersistedValue(String key, String value) async {
    try {
      await _secureStorage
          .write(key: key, value: value)
          .timeout(const Duration(milliseconds: 500));
    } catch (_) {}
    
    try {
      await _database
          .writeString(key, value)
          .timeout(const Duration(seconds: 1));
    } catch (_) {}
  }

  bool _isValidEmail(String email) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
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

  Map<String, Object?> toJson() => {
    'userId': userId,
    'email': email,
    'displayName': displayName,
    'password': password,
  };

  factory _StoredAccount.fromJson(Map<String, Object?> json) => _StoredAccount(
    userId: json['userId'] as String? ?? '',
    email: json['email'] as String? ?? '',
    displayName: json['displayName'] as String? ?? '',
    password: json['password'] as String? ?? '',
  );
}
