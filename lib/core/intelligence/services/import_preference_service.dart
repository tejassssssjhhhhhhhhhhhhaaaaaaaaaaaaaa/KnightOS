import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ImportPreferenceService {
  const ImportPreferenceService(this._prefs);
  final SharedPreferences _prefs;

  static const String _kImportPathsKey = 'import_paths';
  static const String _kDefaultPathWindows = 'C:/Users/tejas/OneDrive/ドキュメント/knight_os';
  static const String _kDefaultPathAndroid = '/sdcard/Download/knight_os';

  List<String> getImportPaths() {
    final storedPaths = _prefs.getStringList(_kImportPathsKey);
    if (storedPaths != null && storedPaths.isNotEmpty) {
      return storedPaths;
    }
    
    // Default fallback
    if (Platform.isAndroid) {
      return [_kDefaultPathAndroid];
    }
    return [_kDefaultPathWindows];
  }

  Future<void> addImportPath(String path) async {
    final paths = _prefs.getStringList(_kImportPathsKey) ?? [];
    if (!paths.contains(path)) {
      paths.add(path);
      await _prefs.setStringList(_kImportPathsKey, paths);
    }
  }

  Future<void> removeImportPath(String path) async {
    final paths = _prefs.getStringList(_kImportPathsKey) ?? [];
    if (paths.remove(path)) {
      await _prefs.setStringList(_kImportPathsKey, paths);
    }
  }
}
