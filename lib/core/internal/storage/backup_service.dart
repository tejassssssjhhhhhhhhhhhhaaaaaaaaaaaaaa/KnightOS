import 'dart:io';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'drift/knight_database.dart';
import '../utils/knight_logger.dart';

class BackupService {
  BackupService({required this.db});

  final KnightDatabase db;

  /// Creates an encrypted archive of the database and vault.
  Future<File> createBackupArchive(String encryptionKey) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'knight_os_v2.sqlite'));
    final vaultDir = Directory(p.join(dbFolder.path, 'vault'));

    final encoder = ZipEncoder();
    final archive = Archive();

    // 1. Add Database
    if (await dbFile.exists()) {
      final bytes = await dbFile.readAsBytes();
      archive.addFile(ArchiveFile('database.sqlite', bytes.length, bytes));
    }

    // 2. Add Vault Files
    if (await vaultDir.exists()) {
      final files = vaultDir.listSync(recursive: true);
      for (final file in files) {
        if (file is File) {
          final relativePath = p.relative(file.path, from: dbFolder.path);
          final bytes = await file.readAsBytes();
          archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
        }
      }
    }

    final zipBytes = encoder.encode(archive);
    if (zipBytes == null) throw Exception('Failed to encode archive');

    // 3. Encrypt
    final encryptedBytes = _encryptBytes(zipBytes, encryptionKey);

    final backupFile = File(p.join(dbFolder.path, 'knight_backup.knt'));
    await backupFile.writeAsBytes(encryptedBytes);

    KnightLogger.info('Backup archive created: ${backupFile.path}');
    return backupFile;
  }

  List<int> _encryptBytes(List<int> bytes, String keyStr) {
    // Ensure key is 32 bytes for AES-256
    final key = enc.Key.fromUtf8(keyStr.padRight(32).substring(0, 32));
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return iv.bytes + encrypted.bytes; // Prepend IV
  }
}
