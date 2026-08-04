import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/internal/utils/knight_logger.dart';
import '../../core/repositories/authentication_repository.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/launch_experience_service.dart';

class PremiumLaunchScreen extends StatefulWidget {
  const PremiumLaunchScreen({super.key});

  @override
  State<PremiumLaunchScreen> createState() => _PremiumLaunchScreenState();
}

class _PremiumLaunchScreenState extends State<PremiumLaunchScreen>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _bootController;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoOpacityAnimation;
  late final Animation<double> _greetingOpacityAnimation;
  late final Animation<double> _greetingSlideAnimation;
  late final Animation<double> _logoSweepAnimation;

  bool _showGreeting = false;
  bool _buttonEnabled = false;
  bool _useShortExperience = false;

  final LaunchExperienceService _launchExperienceService =
      LaunchExperienceService();
  String _displayName = 'Knight User';
  String _greeting = 'Welcome back,';
  LaunchInsight _insight = LaunchInsight('Ready for tonight\'s shift?', '');

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _bootController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: _bootController, curve: Curves.easeOutBack),
    );
    _logoOpacityAnimation = CurvedAnimation(
      parent: _bootController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _greetingOpacityAnimation = CurvedAnimation(
      parent: _bootController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
    );
    _greetingSlideAnimation = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _bootController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );
    _logoSweepAnimation = Tween<double>(begin: -0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutSine,
      ),
    );

    _initializeLaunchSequence();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _bootController.dispose();
    super.dispose();
  }

  Future<void> _initializeLaunchSequence() async {
    final shouldPlayFullExperience = await _launchExperienceService
        .shouldPlayFullExperience();
    if (!mounted) {
      return;
    }

    setState(() {
      _useShortExperience = !shouldPlayFullExperience;
    });

    if (shouldPlayFullExperience) {
      await _launchExperienceService.markLaunchSeen();
      _bootController.forward();
    } else {
      _bootController.value = 1.0;
    }

    final session = await AuthenticationRepository().getCurrentSession();
    if (!mounted) {
      return;
    }

    final displayName = session?.displayName.trim();
    _displayName = displayName?.isNotEmpty == true
        ? displayName!
        : 'Knight User';
    _greeting = _buildGreeting();
    _insight = _selectInsight();

    if (_useShortExperience) {
      setState(() {
        _showGreeting = true;
        _buttonEnabled = true;
      });
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) {
      return;
    }

    setState(() {
      _showGreeting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) {
      return;
    }

    setState(() {
      _buttonEnabled = true;
    });
  }

  String _buildGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5 || hour >= 21) {
      return 'Good Night';
    }
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  LaunchInsight _selectInsight() {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday;

    if (hour >= 18 || hour < 6) {
      return const LaunchInsight('Ready for tonight\'s shift?', '');
    }
    if (weekday == DateTime.monday || weekday == DateTime.thursday) {
      return const LaunchInsight('Gym Day 💪', '');
    }
    if (weekday == DateTime.wednesday) {
      return const LaunchInsight('You\'ve been consistent this week', '');
    }
    return const LaunchInsight('3 tasks due today', '');
  }

  Color _interpolatedColor(Color a, Color b, double progress) {
    return Color.lerp(a, b, progress) ?? a;
  }

  Future<void> _goToNextScreen() async {
    if (!_buttonEnabled) {
      return;
    }
    HapticFeedback.lightImpact();
    final isAuthenticated = await AuthenticationRepository().isAuthenticated();
    if (!mounted) {
      return;
    }
    context.go(isAuthenticated ? AppRoutes.dashboard : AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context) {
    KnightLogger.info('[STARTUP 10] PremiumLaunchScreen build()', category: KnightLogCategory.ui);
    final theme = Theme.of(context);
    final topColor = _interpolatedColor(
      const Color(0xFF08101F),
      const Color(0xFF10192B),
      _backgroundController.value,
    );
    final bottomColor = _interpolatedColor(
      const Color(0xFF111A2A),
      const Color(0xFF06111B),
      1.0 - _backgroundController.value,
    );

    return Scaffold(
      backgroundColor: topColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [topColor, bottomColor],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, _) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.6, -0.8),
                        radius: 1.6,
                        colors: [
                          const Color(0xFF2C4D7C).withValues(alpha: 0.16),
                          const Color(0xFF08101F).withValues(alpha: 0),
                        ],
                        stops: [0.0, 0.85],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _logoOpacityAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.22),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.18,
                                ),
                                width: 1.4,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 60,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _backgroundController,
                                  builder: (context, _) {
                                    return Positioned.fill(
                                      child: Transform.translate(
                                        offset: Offset(
                                          _logoSweepAnimation.value * 140,
                                          0,
                                        ),
                                        child: Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.18,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0,
                                                ),
                                              ],
                                              stops: const [0.0, 0.5, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Text(
                        'KnightOS',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Text(
                        'Your Personal Operating System',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _showGreeting
                          ? Opacity(
                              key: const ValueKey('greeting'),
                              opacity: _greetingOpacityAnimation.value,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  _greetingSlideAnimation.value,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _greeting,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Welcome back,',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _displayName,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 18),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _insight.title,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                        ),
                                        onPressed: _buttonEnabled
                                            ? _goToNextScreen
                                            : null,
                                        child: Text(
                                          '⚔ Get Started',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                              key: ValueKey('placeholder'),
                              height: 0,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LaunchInsight {
  const LaunchInsight(this.title, this.description);

  final String title;
  final String description;
}
