import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalFileStorage {
  Future<String?> readString(String fileName) async {
    final file = await fileFor(fileName);
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  Future<void> writeString(String fileName, String value) async {
    final file = await fileFor(fileName);
    await file.writeAsString(value);
  }

  Future<void> delete(String fileName) async {
    final file = await fileFor(fileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File> fileFor(String fileName) async {
    final directory = await _appDataDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }

  Future<Directory> _appDataDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return getApplicationSupportDirectory();
    }
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return getApplicationSupportDirectory();
    }
    return getApplicationDocumentsDirectory();
  }
}
