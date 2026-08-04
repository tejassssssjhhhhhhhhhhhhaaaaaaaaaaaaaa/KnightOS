import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage implementation for sensitive data like OAuth tokens.
class SecureStorage {
  const SecureStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String googleAccessTokenKey = 'google_access_token';
  static const String googleRefreshTokenKey = 'google_refresh_token';
  static const String googleIdTokenKey = 'google_id_token';

  /// Returns a unique key for a specific classification to be used in encryption.
  static String getVaultKey(String classification) => 'vault_key_$classification';

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
