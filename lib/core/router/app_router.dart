import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/home_screen.dart';
import '../../app/app_shell.dart';
import '../../app/screens/account_center_screen.dart';
import '../../app/screens/auth_screen.dart';
import '../../app/screens/premium_launch_screen.dart';
import '../../app/screens/settings_screen.dart';
import '../../app/screens/splash_screen.dart';
import '../../app/screens/voice_capture_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/atlas/presentation/life_atlas_screen.dart';
import '../../features/knight/presentation/knight_screen.dart';
import '../../features/my_place/presentation/my_place_screen.dart';
import '../../features/system/presentation/my_data_screen.dart';
import '../../features/finance/presentation/finance_tracker_screen.dart';
import '../../features/fitness/presentation/fitness_tracker_screen.dart';
import '../../features/sleep/presentation/sleep_tracker_screen.dart';
import '../../features/work_tracker/presentation/work_tracker_screen.dart';
import '../../features/knowledge/presentation/knowledge_dashboard_screen.dart';
import '../../features/knowledge/presentation/knowledge_graph_explorer_screen.dart';
import '../../features/planner/presentation/planner_home_screen.dart';
import '../../features/mission/presentation/mission_dashboard_screen.dart';
import '../../features/connectors/presentation/connector_dashboard_screen.dart';
import '../../features/discovery/presentation/discovery_dashboard_screen.dart';
import '../../features/health/presentation/health_dashboard_screen.dart';
import '../../features/documents/presentation/document_center_screen.dart';
import '../../features/knight/presentation/intelligence_dashboard_screen.dart';
import '../internal/utils/knight_logger.dart';

import 'app_routes.dart';
import 'knight_route_observer.dart';

class AppRouter {
  AppRouter._();

  static GoRouter? _router;

  static GoRouter get router {
    if (_router == null) {
      KnightLogger.info('[ROUTER] Building GoRouter...');
      _router = _buildRouter();
    }
    return _router!;
  }

  static GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      observers: [KnightRouteObserver()],
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.auth,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingFlowScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => KnightShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.knight,
              builder: (context, state) => const KnightScreen(),
            ),
            GoRoute(
              path: AppRoutes.lifeAtlas,
              builder: (context, state) => const LifeAtlasScreen(),
            ),
            GoRoute(
              path: AppRoutes.myPlace,
              builder: (context, state) => const MyPlaceScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.account,
          builder: (context, state) => const AccountCenterScreen(),
        ),
        GoRoute(
          path: AppRoutes.voiceCapture,
          builder: (context, state) => const VoiceCaptureScreen(),
        ),
        GoRoute(
          path: AppRoutes.launch,
          builder: (context, state) => const PremiumLaunchScreen(),
        ),
        GoRoute(
          path: AppRoutes.myData,
          builder: (context, state) => const MyDataScreen(),
        ),
        GoRoute(
          path: AppRoutes.finance,
          builder: (context, state) => const FinanceTrackerScreen(),
        ),
        GoRoute(
          path: AppRoutes.fitness,
          builder: (context, state) => const FitnessTrackerScreen(),
        ),
        GoRoute(
          path: AppRoutes.sleep,
          builder: (context, state) => const SleepTrackerScreen(),
        ),
        GoRoute(
          path: AppRoutes.work,
          builder: (context, state) => const WorkTrackerScreen(),
        ),
        GoRoute(
          path: AppRoutes.knowledgeVault,
          builder: (context, state) => const KnowledgeDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.knowledgeGraph,
          builder: (context, state) => const KnowledgeGraphExplorerScreen(),
        ),
        GoRoute(
          path: AppRoutes.planner,
          builder: (context, state) => const PlannerHomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.mission,
          builder: (context, state) => const MissionDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.connectors,
          builder: (context, state) => const ConnectorDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.discovery,
          builder: (context, state) => const DiscoveryDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.health,
          builder: (context, state) => const HealthDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.documents,
          builder: (context, state) => const DocumentCenterScreen(),
        ),
        GoRoute(
          path: AppRoutes.intelligence,
          builder: (context, state) => const IntelligenceDashboardScreen(),
        ),
      ],
    );
  }
}
