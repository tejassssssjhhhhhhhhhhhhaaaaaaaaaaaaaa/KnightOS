import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/knight_theme_provider.dart';
import 'core/providers/automation_providers.dart';
import 'core/intelligence/services/google_data_hub.dart';

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
        
        final hubStatus = ref.watch(googleDataHubProvider);
        if (hubStatus == HubStatus.disconnected) {
           // Proactive prompt if disconnected? 
           // Better to let user open Import Center.
        }

        return MaterialApp.router(
          title: 'KNIGHT',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: theme, 
          themeMode: themeMode,
          routerConfig: router,
          builder: (context, child) => child!,
        );
      },
    );
  }
}
