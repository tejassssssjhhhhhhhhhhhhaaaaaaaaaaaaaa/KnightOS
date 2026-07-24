import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/repositories/authentication_repository.dart';
import '../../core/router/app_routes.dart';
import '../widgets/knight_page_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final authRepository = AuthenticationRepository();
        final authenticated = await authRepository.isAuthenticated();
        if (!mounted) return;
        if (authenticated) {
          context.go(AppRoutes.launch);
        } else {
          context.go(AppRoutes.welcome);
        }
      } catch (error, stackTrace) {
        debugPrint('Startup initialization failed: $error');
        debugPrintStack(stackTrace: stackTrace);
        if (!mounted) return;
        context.go(AppRoutes.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KnightPageScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 54,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'KnightOS',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preparing your personal operating system',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
