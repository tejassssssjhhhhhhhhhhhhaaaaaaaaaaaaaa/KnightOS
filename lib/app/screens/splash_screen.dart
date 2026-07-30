import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_constants.dart';
import '../../core/design_system/widgets/lunar_horizon_background.dart';
import '../../core/router/app_routes.dart';
import '../../core/providers/storage_providers.dart';
import '../../core/intelligence/providers/intelligence_providers.dart';
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
  
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _titleFade;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    final start = DateTime.now();
    try {
      KnightLogger.info('[STARTUP 04] Attempting Storage Initialization', category: KnightLogCategory.startup);
      
      await ref.read(storageInitializerProvider.future).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Initialization timed out'),
          );

      if (!mounted) return;
      KnightLogger.info('[STARTUP 05] Storage Initialized', category: KnightLogCategory.startup);

      // 2. Auth & Profile Check
      final authRepository = ref.read(authenticationRepositoryProvider);
      final userRepository = ref.read(userRepositoryProvider);
      
      KnightLogger.info('[STARTUP 06] Checking Authentication state', category: KnightLogCategory.startup);
      final authenticated = await authRepository.isAuthenticated();
      final profile = await userRepository.loadProfile();

      if (!mounted) return;
      
      final onboardingCompleted = profile?.isCompleted ?? false;
      KnightLogger.info('[STARTUP 06] Auth: $authenticated, Onboarding: $onboardingCompleted', category: KnightLogCategory.startup);

      // 3. Cinematic minimum wait
      final elapsed = DateTime.now().difference(start);
      const minDuration = Duration(milliseconds: 2200);
      if (elapsed < minDuration) {
        await Future.delayed(minDuration - elapsed);
      }

      if (!mounted) return;

      // 4. Start Background Perception Loop
      KnightLogger.info('[STARTUP 06] Starting Perception Scheduler', category: KnightLogCategory.startup);
      ref.read(perceptionSchedulerProvider).start();

      // 5. Navigation
      if (!mounted) return;
      if (authenticated) {
        KnightLogger.info('[STARTUP 06] Navigating to HOME', category: KnightLogCategory.startup);
        context.go(AppRoutes.home);
      } else {
        KnightLogger.info('[STARTUP 06] Navigating to WELCOME', category: KnightLogCategory.startup);
        context.go(AppRoutes.welcome);
      }
    } catch (e, stack) {
      KnightLogger.error('Startup failure', error: e, stackTrace: stack);
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Initialization Error: $message'),
        backgroundColor: DesignColors.error,
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: () => _initialize(),
        ),
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
      backgroundColor: DesignColors.background,
      body: LunarHorizonBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: const KnightHelmetLogo(size: 120),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Title
                  Opacity(
                    opacity: _titleFade.value,
                    child: const Text(
                      'K N I G H T   O S',
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 10.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tagline
                  Opacity(
                    opacity: _taglineFade.value,
                    child: const Text(
                      'YOUR PERSONAL OPERATING SYSTEM',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
