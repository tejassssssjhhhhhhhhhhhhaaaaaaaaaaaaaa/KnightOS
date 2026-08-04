import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'secure_storage.dart';

enum PrivacyClassification {
  public,
  personal,
  sensitive,
  highlySensitive,
}

/// Manages encryption and secure storage for sensitive data.
class PrivacyVault {
  PrivacyVault._({SecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const SecureStorage();

  static final PrivacyVault instance = PrivacyVault._();

  final SecureStorage _secureStorage;

  /// Encrypts and stores a value with a specific classification.
  Future<void> store(String key, String value, PrivacyClassification classification) async {
    if (classification == PrivacyClassification.public) {
      await _secureStorage.write(key, value);
      return;
    }

    // For sensitive and above, we use additional encryption.
    final encryptionKey = await _getEncryptionKey(classification);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromBase64(encryptionKey)));

    final encrypted = encrypter.encrypt(value, iv: iv);

    final encryptedData = {
      'ciphertext': encrypted.base64,
      'iv': iv.base64,
    };

    await _secureStorage.write(key, json.encode(encryptedData));
  }

  /// Retrieves and decrypts a value.
  Future<String?> retrieve(String key, PrivacyClassification classification) async {
    final storedValue = await _secureStorage.read(key);
    if (storedValue == null) return null;

    if (classification == PrivacyClassification.public) {
      return storedValue;
    }

    try {
      final encryptedData = json.decode(storedValue);
      final encryptionKey = await _getEncryptionKey(classification);
      
      final iv = IV.fromBase64(encryptedData['iv']);
      final encrypter = Encrypter(AES(Key.fromBase64(encryptionKey)));

      final decrypted = encrypter.decrypt64(encryptedData['ciphertext'], iv: iv);

      return decrypted;
    } catch (e) {
      // If decryption fails, it might be corrupted or the key changed.
      return null;
    }
  }

  Future<String> _getEncryptionKey(PrivacyClassification classification) async {
    final keyName = 'vault_key_${classification.name}';
    String? storedKey = await _secureStorage.read(keyName);

    if (storedKey == null) {
      // Generate a new random key if it doesn't exist
      final newKey = Key.fromSecureRandom(32);
      final keyBase64 = newKey.base64;
      await _secureStorage.write(keyName, keyBase64);
      return keyBase64;
    }

    return storedKey;
  }
}
