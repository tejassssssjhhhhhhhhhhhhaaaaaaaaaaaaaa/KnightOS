import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/internal/utils/knight_logger.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/design_system/widgets/lunar_horizon_background.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import 'widgets/knight_helmet_logo.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    KnightLogger.info('[STARTUP 07] WelcomeScreen build()', category: KnightLogCategory.ui);
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          KnightLogger.info('[STARTUP 08] WelcomeScreen Begin Tapped', category: KnightLogCategory.ui);
          
          // Version 4: Mark welcome as seen and go to Dashboard (Guest Mode)
          const localDb = LocalDatabase();
          await localDb.writeString(StorageKeys.welcomeSeen, 'true');
          
          if (context.mounted) {
            context.go(AppRoutes.home);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // 1. Cinematic Lunar Horizon
            const LunarHorizonBackground(),

            // 2. Welcome Content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      
                      // Knight Helmet Logo
                      const EntranceFader(
                        child: KnightHelmetLogo(size: 120),
                      ),
                      
                      const SizedBox(height: DesignSpacing.xl),
                      
                      // Brand Identity
                      EntranceFader(
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            Text(
                              'K N I G H T   O S',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 24,
                                letterSpacing: 8.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'YOUR PERSONAL OPERATING SYSTEM',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: DesignColors.accentBlue,
                                letterSpacing: 4.0,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(flex: 2),
                      
                      // Minimal Copy
                      EntranceFader(
                        delay: const Duration(milliseconds: 600),
                        child: Text(
                          'Think. Plan. Execute.\nOwn your life.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                      ),
                      
                      const Spacer(flex: 1),
                      
                      // Tap to begin
                      const EntranceFader(
                        delay: Duration(milliseconds: 1200),
                        child: _TapToBegin(),
                      ),
                      
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TapToBegin extends StatefulWidget {
  const _TapToBegin();

  @override
  State<_TapToBegin> createState() => _TapToBeginState();
}

class _TapToBeginState extends State<_TapToBegin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
      child: Column(
        children: [
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38),
          const SizedBox(height: 8),
          Text(
            'Tap anywhere to begin',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white38,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
