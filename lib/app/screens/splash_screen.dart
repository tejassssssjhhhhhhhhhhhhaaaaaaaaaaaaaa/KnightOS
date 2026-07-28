import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/widgets/lunar_horizon_background.dart';
import '../../core/router/app_routes.dart';
import '../../core/providers/storage_providers.dart';
import '../../core/internal/utils/knight_logger.dart';
import '../../features/welcome/presentation/widgets/knight_helmet_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    final stopwatch = Stopwatch()..start();
    try {
      final start = DateTime.now();

      await ref
          .read(storageInitializerProvider.future)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
              'Storage initialization timed out',
            ),
          );

      final authRepository = ref.read(authenticationRepositoryProvider);
      final userRepository = ref.read(userRepositoryProvider);
      final authenticated = await authRepository.isAuthenticated();
      final profile = await userRepository.loadProfile();
      final onboardingCompleted = profile?.isCompleted ?? false;

      final elapsed = DateTime.now().difference(start);
      // Reduced artificial wait for faster startup experience
      final remaining = const Duration(milliseconds: 800) - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      if (!mounted) return;

      if (authenticated) {
        if (onboardingCompleted) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.onboarding);
        }
      } else {
        context.go(AppRoutes.welcome);
      }
    } catch (e, stack) {
      KnightLogger.error('Startup failed: $e', error: e, stackTrace: stack);
      if (!mounted) return;
      _showErrorDialog(e.toString());
    } finally {
      stopwatch.stop();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('System Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => _initialize(), child: const Text('RETRY')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LunarHorizonBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                KnightHelmetLogo(size: 100),
                SizedBox(height: 32),
                Text(
                  'K N I G H T   O S',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 8.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
