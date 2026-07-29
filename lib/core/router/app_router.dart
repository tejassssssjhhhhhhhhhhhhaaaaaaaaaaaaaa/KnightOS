import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/home_screen.dart';
import '../../app/app_shell.dart';
import '../../app/screens/account_center_screen.dart';
import '../../app/screens/auth_screen.dart';
import '../../app/screens/settings_screen.dart';
import '../../app/screens/splash_screen.dart';
import '../../app/screens/voice_capture_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/atlas/presentation/life_atlas_screen.dart';
import '../../features/knight/presentation/knight_screen.dart';
import '../../core/repositories/authentication_repository.dart';
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

import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Page<dynamic> _fadeTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final publicPaths = <String>{
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.auth,
      };
      final location = state.matchedLocation;
      final repository = AuthenticationRepository.instance;
      final authenticated = await repository.isAuthenticated();

      if (publicPaths.contains(location)) {
        if (!authenticated) {
          return null;
        }
        // If authenticated and on a public page, let splash or login flow handle it.
        // We'll default to home to avoid loops.
        return AppRoutes.home;
      }

      if (!authenticated) {
        return AppRoutes.auth;
      }

      return null;
    },
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
      GoRoute(
        path: AppRoutes.account,
        builder: (context, state) => const AccountCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.voiceCapture,
        builder: (context, state) => const VoiceCaptureScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => KnightShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.lifeAtlas,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const LifeAtlasScreen()),
          ),
          GoRoute(
            path: AppRoutes.myPlace,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const MyPlaceScreen()),
          ),
          GoRoute(
            path: AppRoutes.knight,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const KnightScreen()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const SettingsScreen()),
          ),
          GoRoute(
            path: AppRoutes.myData,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const MyDataScreen()),
          ),
          GoRoute(
            path: AppRoutes.documents,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const DocumentCenterScreen()),
          ),
          GoRoute(
            path: AppRoutes.health,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const HealthDashboardScreen()),
          ),
          GoRoute(
            path: AppRoutes.finance,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const FinanceTrackerScreen()),
          ),
          GoRoute(
            path: AppRoutes.fitness,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const FitnessTrackerScreen()),
          ),
          GoRoute(
            path: AppRoutes.sleep,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const SleepTrackerScreen()),
          ),
          GoRoute(
            path: AppRoutes.work,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const WorkTrackerScreen()),
          ),
          GoRoute(
            path: AppRoutes.knowledgeVault,
            pageBuilder: (context, state) => _fadeTransition(
              context,
              state,
              const KnowledgeDashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.knowledgeGraph,
            pageBuilder: (context, state) => _fadeTransition(
              context,
              state,
              const KnowledgeGraphExplorerScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.planner,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const PlannerHomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.mission,
            pageBuilder: (context, state) =>
                _fadeTransition(context, state, const MissionDashboardScreen()),
          ),
          GoRoute(
            path: AppRoutes.connectors,
            pageBuilder: (context, state) => _fadeTransition(
              context,
              state,
              const ConnectorDashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.discovery,
            pageBuilder: (context, state) => _fadeTransition(
              context,
              state,
              const DiscoveryDashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.intelligence,
            pageBuilder: (context, state) => _fadeTransition(
              context,
              state,
              const IntelligenceDashboardScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
