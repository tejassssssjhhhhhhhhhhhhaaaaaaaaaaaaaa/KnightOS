import 'dart:io';
import 'package:crypto/crypto.dart';

class DocumentHashService {
  const DocumentHashService();

  Future<String> calculateHash(File file) async {
    if (!await file.exists()) {
      throw FileSystemException('File not found', file.path);
    }
    
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }
}
