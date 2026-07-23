import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  const LocalDatabase();

  Future<String?> _readString(String fileName) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(fileName);
      } catch (error) {
        debugPrint('Web storage read failed: $error');
        return null;
      }
    }

    final file = await fileFor(fileName);
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  Future<File> fileFor(String fileName) async {
    if (kIsWeb) {
      throw UnsupportedError('File storage is not supported on web.');
    }

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

  Future<String?> readString(String fileName) async {
    return _readString(fileName);
  }

  Future<Map<String, dynamic>?> readJson(String fileName) async {
    final contents = await _readString(fileName);
    if (contents == null) {
      return null;
    }
    return jsonDecode(contents) as Map<String, dynamic>;
  }

  Future<List<dynamic>?> readJsonList(String fileName) async {
    final contents = await _readString(fileName);
    if (contents == null) {
      return null;
    }
    return jsonDecode(contents) as List<dynamic>;
  }

  Future<void> writeString(String fileName, String value) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, value);
      } catch (error) {
        debugPrint('Web storage write failed: $error');
      }
      return;
    }

    final file = await fileFor(fileName);
    await file.writeAsString(value);
  }

  Future<void> writeJson(String fileName, Map<String, dynamic> value) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, jsonEncode(value));
      } catch (error) {
        debugPrint('Web storage write failed: $error');
      }
      return;
    }

    final file = await fileFor(fileName);
    await file.writeAsString(jsonEncode(value));
  }

  Future<void> writeJsonList(String fileName, List<dynamic> value) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, jsonEncode(value));
      } catch (error) {
        debugPrint('Web storage write failed: $error');
      }
      return;
    }

    final file = await fileFor(fileName);
    await file.writeAsString(jsonEncode(value));
  }

  Future<void> delete(String fileName) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(fileName);
      } catch (error) {
        debugPrint('Web storage delete failed: $error');
      }
      return;
    }

    final file = await fileFor(fileName);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
