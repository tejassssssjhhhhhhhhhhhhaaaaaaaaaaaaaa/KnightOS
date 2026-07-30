import 'dart:async';
import 'package:flutter/material.dart';
import 'app/screens/development_error_screen.dart';
import 'core/internal/utils/knight_logger.dart';

import 'knight_os_app.dart';

void main() {
  print('KNIGHT_LOG: main() starting');
  runZonedGuarded(() {
    print('KNIGHT_LOG: inside runZonedGuarded');
    WidgetsFlutterBinding.ensureInitialized();
    print('KNIGHT_LOG: WidgetsFlutterBinding initialized');
    
    KnightLogger.info('[STARTUP 01] main() entry', category: KnightLogCategory.startup);

    // Framework error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      KnightLogger.error(
        '[STARTUP ERR] Flutter Framework Error',
        error: details.exception,
        stackTrace: details.stack,
        category: KnightLogCategory.ui,
      );
      // In debug/dev mode, dump to console as well
      FlutterError.dumpErrorToConsole(details);
    };

    // Build failure handling
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return DevelopmentErrorScreen(details: details);
    };

    KnightLogger.info('[STARTUP 02] runApp() calling', category: KnightLogCategory.startup);
    runApp(const KnightOsApp());
    
  }, (Object error, StackTrace stack) {
    print('KNIGHT_LOG: UNCAUGHT ERROR: $error');
    KnightLogger.error(
      '[STARTUP ERR] Uncaught Asynchronous Error',
      error: error,
      stackTrace: stack,
      category: KnightLogCategory.startup,
    );
  });
}
