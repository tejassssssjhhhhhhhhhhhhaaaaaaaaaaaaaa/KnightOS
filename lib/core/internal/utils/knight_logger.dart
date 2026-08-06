import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/internal_log_service.dart';

enum KnightLogCategory {
  startup,
  database,
  riverpod,
  intelligence,
  repository,
  ui,
  sync,
  auth,
  worker,
  analysis,
}

class KnightLogger {
  const KnightLogger._();

  static File? _logFile;

  static Future<void> _initLogFile() async {
    if (_logFile != null) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      _logFile = File('${logDir.path}/knight_execution.log');
      if (!await _logFile!.exists()) {
        await _logFile!.create();
      }
    } catch (e) {
      debugPrint('Failed to init log file: $e');
    }
  }

  static void info(
    String message, {
    KnightLogCategory category = KnightLogCategory.startup,
  }) {
    _log('INFO', message, category);
  }

  static void debug(
    String message, {
    KnightLogCategory category = KnightLogCategory.startup,
  }) {
    _log('DEBUG', message, category);
  }

  static void warn(
    String message, {
    KnightLogCategory category = KnightLogCategory.startup,
  }) {
    _log('WARN', message, category);
  }

  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    KnightLogCategory category = KnightLogCategory.startup,
  }) {
    _log('ERROR', message, category, error: error);
    if (error != null) _rawPrint('Error Detail: $error');
    if (stackTrace != null) _rawPrint('Stack Trace: $stackTrace');
  }

  static void _log(String level, String message, KnightLogCategory category, {Object? error}) {
    final timestamp = DateTime.now().toIso8601String().split('T').last;
    final logMessage = '[$timestamp] [$level] [${category.name.toUpperCase()}] $message';
    _rawPrint('KNIGHT: $logMessage');
    
    _writeToLogFile(logMessage);

    // Capture for In-App Developer Mode
    InternalLogService.instance.capture(level, category.name, message, error: error);
  }

  static void _writeToLogFile(String msg) async {
     await _initLogFile();
     try {
       await _logFile?.writeAsString('$msg\n', mode: FileMode.append);
     } catch (_) {}
  }

  static void _rawPrint(String msg) {
    if (kReleaseMode) {
      stderr.writeln(msg);
    } else {
      debugPrint(msg);
    }
  }
}
