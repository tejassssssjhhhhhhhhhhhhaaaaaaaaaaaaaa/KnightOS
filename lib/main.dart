import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/preferences_provider.dart';
import 'core/internal/utils/knight_logger.dart';
import 'knight_os_app.dart';

void main() {
  // P0-1: Optimized Startup
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Enable Edge-to-Edge Experience immediately
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Bootstrap critical services while Native Splash is visible
    final prefs = await SharedPreferences.getInstance();

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const KnightOsApp(),
      ),
    );
    
  }, (Object error, StackTrace stack) {
    KnightLogger.error('STARTUP ERROR: $error', error: error, stackTrace: stack);
  });
}
