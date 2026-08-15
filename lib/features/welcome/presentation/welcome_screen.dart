import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/internal/utils/knight_logger.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/design_system/widgets/entrance_fader.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/local_database.dart';
import '../../../core/storage/storage_keys.dart';
import '../../../core/design_system/widgets/knight_circuit_shield.dart';
import '../../../core/theme/knight_theme_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        KnightLogger.info('[STARTUP 07] WelcomeScreen build()', category: KnightLogCategory.ui);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () async {
              if (_isProcessing) return;
              
              setState(() {
                _isProcessing = true;
              });

              try {
                KnightLogger.info('[STARTUP 08] WelcomeScreen Begin Tapped', category: KnightLogCategory.ui);
                
                // Version 4: Mark welcome as seen and go to Dashboard (Guest Mode)
                const localDb = LocalDatabase();
                await localDb.writeString(StorageKeys.welcomeSeen, 'true');
                
                KnightLogger.info('[STARTUP 09] Navigating to Home...', category: KnightLogCategory.ui);
                
                if (context.mounted) {
                  context.go(AppRoutes.home);
                }
              } catch (e, s) {
                KnightLogger.error('[WELCOME ERR] Failed to transition', error: e, stackTrace: s, category: KnightLogCategory.ui);
                if (mounted) {
                  setState(() {
                    _isProcessing = false;
                  });
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to start: $e')),
                  );
                }
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                // Atmosphere inherited from Global Root

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
                          EntranceFader(
                            child: KnightCircuitShield(
                              size: 120,
                              period: ref.watch(currentPeriodProvider),
                            ),
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
                          EntranceFader(
                            delay: const Duration(milliseconds: 1200),
                            child: _isProcessing 
                              ? const CircularProgressIndicator(color: DesignColors.accentBlue)
                              : const _TapToBegin(),
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
      },
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
