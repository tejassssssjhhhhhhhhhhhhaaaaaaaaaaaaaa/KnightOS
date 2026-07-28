import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  const LocalDatabase();

  Future<String?> _readString(String fileName) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(fileName);
      }

      debugPrint('Local storage reading $fileName');
      final file = await fileFor(fileName);
      if (!await file.exists()) {
        return null;
      }
      return await file.readAsString();
    } catch (error) {
      debugPrint('Local storage read failed for $fileName: $error');
      return null;
    }
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
    try {
      if (Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS) {
        return await getApplicationSupportDirectory();
      }
    } catch (error) {
      debugPrint(
        'Application support directory lookup failed, using documents directory: $error',
      );
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
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, value);
        return;
      }

      final file = await fileFor(fileName);
      await file.writeAsString(value);
    } catch (error) {
      debugPrint('Local storage write failed for $fileName: $error');
    }
  }

  Future<void> writeJson(String fileName, Map<String, dynamic> value) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, jsonEncode(value));
        return;
      }

      final file = await fileFor(fileName);
      await file.writeAsString(jsonEncode(value));
    } catch (error) {
      debugPrint('Local storage write failed for $fileName: $error');
    }
  }

  Future<void> writeJsonList(String fileName, List<dynamic> value) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(fileName, jsonEncode(value));
        return;
      }

      final file = await fileFor(fileName);
      await file.writeAsString(jsonEncode(value));
    } catch (error) {
      debugPrint('Local storage write failed for $fileName: $error');
    }
  }

  Future<void> delete(String fileName) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(fileName);
        return;
      }

      final file = await fileFor(fileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (error) {
      debugPrint('Local storage delete failed for $fileName: $error');
    }
  }
}
