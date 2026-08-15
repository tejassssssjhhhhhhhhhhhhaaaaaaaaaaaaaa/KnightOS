import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/widgets/knight_circuit_shield.dart';
import '../../core/router/app_routes.dart';
import '../../core/internal/utils/knight_logger.dart';
import '../../core/theme/knight_theme_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final start = DateTime.now();
    try {
      KnightLogger.info('[SPLASH] Warming up intelligence core...', category: KnightLogCategory.startup);

      // Ensure premium minimum feel (Skip in tests)
      final isTest = Platform.environment.containsKey('FLUTTER_TEST');
      if (!isTest) {
        final elapsed = DateTime.now().difference(start);
        if (elapsed < const Duration(milliseconds: 2000)) {
          await Future.delayed(const Duration(milliseconds: 2000) - elapsed);
        }
      }

      KnightLogger.info('[SPLASH] Initialization complete. Navigating to Home.', category: KnightLogCategory.startup);
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e, s) {
      KnightLogger.error('[SPLASH ERR] Initialization failed', error: e, stackTrace: s, category: KnightLogCategory.startup);
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(currentPeriodProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'knight_shield',
              child: SizedBox(
                width: 120,
                height: 120,
                child: KnightCircuitShield(
                  period: period,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'KNIGHT OS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 8.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'V5.2 NEURAL CORE',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
