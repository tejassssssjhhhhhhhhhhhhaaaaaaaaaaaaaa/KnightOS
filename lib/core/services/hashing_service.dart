import 'dart:io';
import 'package:crypto/crypto.dart';

class HashingService {
  const HashingService._();

  /// Calculates SHA-256 hash of a file for deduplication.
  static Future<String> calculateFileHash(File file) async {
    if (!await file.exists()) return '';

    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  /// Checks if a hash already exists in the manifest history.
  /// (Placeholder for DB check)
  static Future<bool> isDuplicate(String hash) async {
    return false;
  }
}
