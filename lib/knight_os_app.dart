import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/knight_theme_provider.dart';
import 'core/providers/automation_providers.dart';
import 'app/widgets/living_environment.dart';

class KnightOsApp extends StatefulWidget {
  const KnightOsApp({super.key});

  @override
  State<KnightOsApp> createState() => _KnightOsAppState();
}

class _KnightOsAppState extends State<KnightOsApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref.watch(knightAppThemeProvider);
        final themeMode = ref.watch(knightThemeModeProvider);
        final period = ref.watch(currentPeriodProvider);
        final router = ref.watch(AppRouter.provider);
        
        // Initialize Automation Orchestrator
        ref.watch(automationOrchestratorProvider);

        return MaterialApp.router(
          title: 'KNIGHT',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: theme, 
          themeMode: themeMode,
          routerConfig: router,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                children: [
                  // Layer 0: Global Atmosphere (Background)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: LivingEnvironment(
                        period: period,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  
                  // Layer 1: App Navigation Content
                  if (child != null) Positioned.fill(child: child),
                  
                  // Layer 2: Floating Knight Companion
                  // const KnightCompanion(),
                  
                  // Layer 3: Developer Validation Tool
                  // if (kDebugMode) const ThemeValidationTool(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
