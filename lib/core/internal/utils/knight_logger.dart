import 'dart:io';
import 'package:flutter/foundation.dart';
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
    
    // Capture for In-App Developer Mode
    InternalLogService.instance.capture(level, category.name, message, error: error);
  }

  static void _rawPrint(String msg) {
    if (kReleaseMode) {
      stderr.writeln(msg);
    } else {
      debugPrint(msg);
    }
  }
}
