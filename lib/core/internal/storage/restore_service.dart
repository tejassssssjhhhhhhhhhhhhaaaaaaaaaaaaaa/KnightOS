import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../utils/knight_logger.dart';

class RestoreService {
  /// Decrypts and restores the state from a backup archive.
  Future<void> restoreFromArchive(File backupFile, String encryptionKey) async {
    final bytes = await backupFile.readAsBytes();
    
    // 1. Decrypt
    final decryptedBytes = _decryptBytes(bytes, encryptionKey);

    // 2. Decode Zip
    final archive = ZipDecoder().decodeBytes(decryptedBytes);
    final dbFolder = await getApplicationDocumentsDirectory();

    // 3. Extract Files
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        final targetPath = filename == 'database.sqlite' 
            ? p.join(dbFolder.path, 'knight_os_v2.sqlite')
            : p.join(dbFolder.path, filename);
            
        final targetFile = File(targetPath);
        await targetFile.parent.create(recursive: true);
        await targetFile.writeAsBytes(data);
      }
    }

    KnightLogger.info('Restore complete. Reboot recommended.');
  }

  /// Restores from a cloud provider (currently Google Drive).
  Future<void> restoreFromCloud(String source) async {
     // This is a high-level orchestration point. 
     // The actual download and verification should be implemented in the respective provider.
     // For now, we keep the signature for the GoogleDriveProvider to call.
     KnightLogger.info('Cloud restore requested from: $source');
     // In a full implementation, this would trigger a background sync and verification.
  }

  List<int> _decryptBytes(List<int> bytes, String keyStr) {
    final key = enc.Key.fromUtf8(keyStr.padRight(32).substring(0, 32));
    final iv = enc.IV(Uint8List.fromList(bytes.sublist(0, 16)));
    final encryptedData = bytes.sublist(16);

    final encrypter = enc.Encrypter(enc.AES(key));
    return encrypter.decryptBytes(enc.Encrypted(Uint8List.fromList(encryptedData)), iv: iv);
  }
}
