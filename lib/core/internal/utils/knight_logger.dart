import 'package:flutter/foundation.dart';

enum KnightLogCategory {
  startup,
  database,
  riverpod,
  intelligence,
  repository,
  ui,
}

class KnightLogger {
  const KnightLogger._();

  static void info(
    String message, {
    KnightLogCategory category = KnightLogCategory.startup,
  }) {
    _log('INFO', message, category);
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
    _log('ERROR', message, category);
    if (error != null) debugPrint('Error Detail: $error');
    if (stackTrace != null) debugPrint('Stack Trace: $stackTrace');
  }

  static void _log(String level, String message, KnightLogCategory category) {
    final timestamp = DateTime.now().toIso8601String().split('T').last;
    debugPrint(
      '[$timestamp] [$level] [${category.name.toUpperCase()}] $message',
    );
  }
}
