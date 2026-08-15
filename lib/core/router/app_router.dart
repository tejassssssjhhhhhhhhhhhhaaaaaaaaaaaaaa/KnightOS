import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/home_screen.dart';
import '../../app/app_shell.dart';
import '../../app/screens/account_center_screen.dart';
import '../../app/screens/error_screen.dart';
import '../../app/screens/profile_screen.dart';
import '../../app/screens/settings_sub_pages.dart';
import '../../app/screens/splash_screen.dart';
import '../../app/screens/auth_screen.dart';
import '../../app/screens/knight_launch_screen.dart';
import '../../app/screens/dashboard_screen.dart';
import '../../app/screens/voice_capture_screen.dart';
import '../../app/screens/app_updates_screen.dart';
import '../../app/screens/relaxation_control_screen.dart';
import '../../app/screens/executive_dashboard_screen.dart';
import '../../features/settings/presentation/gmail_sync_dashboard.dart';
import '../../features/settings/presentation/calendar_sync_dashboard.dart';
import '../../features/settings/presentation/drive_sync_dashboard.dart';
import '../../features/settings/presentation/developer_mode_screen.dart';
import '../../features/settings/presentation/provider_health_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/atlas/presentation/life_atlas_screen.dart';
import '../../features/knight/presentation/knight_screen.dart';
import '../../features/my_place/presentation/my_place_screen.dart';
import '../../features/system/presentation/my_data_screen.dart';
import '../../features/finance/presentation/finance_tracker_screen.dart';
import '../../features/finance/presentation/finance_inbox_screen.dart';
import '../../features/finance/presentation/finance_mission_control_screen.dart';
import '../../features/finance/presentation/finance_explorer_screen.dart';
import '../../features/finance/presentation/finance_timeline_screen.dart';
import '../../features/finance/presentation/finance_analytics_screen.dart';
import '../../features/finance/presentation/finance_planning_screen.dart';
import '../../features/finance/presentation/finance_goals_screen.dart';
import '../../features/finance/presentation/finance_advisor_screen.dart';
import '../../features/finance/presentation/finance_reports_screen.dart';
import '../../features/finance/presentation/finance_settings_screen.dart';
import '../../features/fitness/presentation/fitness_tracker_screen.dart';
import '../../features/fitness/presentation/workout_logger_screen.dart';
import '../../features/sleep/presentation/sleep_tracker_screen.dart';
import '../../features/work_tracker/presentation/work_tracker_screen.dart';
import '../../features/knowledge/presentation/knowledge_vault_screen.dart';
import '../../features/knowledge/presentation/knowledge_graph_explorer_screen.dart';
import '../../features/planner/presentation/planner_home_screen.dart';
import '../../features/mission/presentation/mission_dashboard_screen.dart';
import '../../features/connectors/presentation/connector_dashboard_screen.dart';
import '../../features/discovery/presentation/discovery_dashboard_screen.dart';
import '../../features/health/presentation/health_dashboard_screen.dart';
import '../../features/knight/presentation/intelligence_dashboard_screen.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/memory/presentation/memory_screen.dart';
import '../../features/journal/presentation/journal_screen.dart';
import '../../features/import/presentation/import_center_screen.dart';
import '../../features/import/presentation/knight_core_screen.dart';
import '../../features/import/presentation/my_knight_brain_screen.dart';
import '../../features/import/presentation/screens/evidence_inbox_screen.dart';
import '../../features/settings/presentation/sync_center_screen.dart';
import '../../features/knight/presentation/knight_ai_qa_screen.dart';
import '../../features/travel/presentation/travel_foundation_dashboards.dart';
import '../../features/travel/presentation/travel_home_screen.dart';
import '../../features/travel/presentation/travel_timeline_screen.dart';
import '../../features/travel/presentation/memory_lane_screen.dart';
import '../../features/travel/presentation/trip_story_screen.dart';
import '../../features/travel/presentation/travel_dna_screen.dart';
import '../../features/travel/presentation/travel_assistant_screen.dart';
import '../../features/travel/presentation/trip_comparison_screen.dart';
import '../../features/career/presentation/screens/career_dashboard_screen.dart';
import '../../features/career/presentation/screens/career_timeline_screen.dart';
import '../../features/career/presentation/screens/career_dna_screen.dart';
import '../../features/career/presentation/screens/achievement_vault_screen.dart';
import '../../features/career/presentation/screens/north_star_screen.dart';
import '../../features/career/presentation/screens/mission_center_screen.dart';
import '../../features/import/presentation/hub_resource_list_screen.dart';

import 'app_routes.dart';
import 'knight_route_observer.dart';
import 'router_notifier.dart';

import '../../features/import/presentation/google_data_audit_screen.dart';

/// Centralized router configuration for Knight OS.
class AppRouter {
  AppRouter._();

  /// Provider for the [GoRouter] instance.
  static final provider = Provider<GoRouter>((ref) {
    final notifier = ref.watch(routerNotifierProvider);

    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: notifier,
      debugLogDiagnostics: true,
      observers: [KnightRouteObserver()],
      redirect: notifier.redirect,
      errorBuilder: (context, state) => ErrorScreen(error: state.error),
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
          path: AppRoutes.launch,
          builder: (context, state) => const KnightLaunchScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.voiceCapture,
          builder: (context, state) => const VoiceCaptureScreen(),
        ),
        GoRoute(
          path: AppRoutes.appUpdates,
          builder: (context, state) => const AppUpdatesScreen(),
        ),
        GoRoute(
          path: AppRoutes.relaxation,
          builder: (context, state) => const RelaxationControlScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => KnightShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => _fadeTransition(context, state, const HomeScreen()),
            ),
            GoRoute(
              path: AppRoutes.knight,
              pageBuilder: (context, state) => _fadeTransition(context, state, const KnightScreen()),
            ),
            GoRoute(
              path: AppRoutes.lifeAtlas,
              pageBuilder: (context, state) => _fadeTransition(context, state, const LifeAtlasScreen()),
            ),
            GoRoute(
              path: AppRoutes.myPlace,
              pageBuilder: (context, state) => _fadeTransition(context, state, const MyPlaceScreen()),
            ),
            GoRoute(
              path: AppRoutes.finance,
              pageBuilder: (context, state) => _fadeTransition(context, state, const FinanceTrackerScreen()),
            ),
            GoRoute(
              path: AppRoutes.travelHome,
              pageBuilder: (context, state) => _fadeTransition(context, state, const TravelHomeScreen()),
            ),
            GoRoute(
              path: AppRoutes.career,
              pageBuilder: (context, state) => _fadeTransition(context, state, const CareerDashboardScreen()),
            ),
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) => _fadeTransition(context, state, const ProfileScreen()),
            ),
            GoRoute(
              path: AppRoutes.planner,
              pageBuilder: (context, state) => _fadeTransition(context, state, const PlannerHomeScreen()),
            ),
            GoRoute(
              path: AppRoutes.health,
              pageBuilder: (context, state) => _fadeTransition(context, state, const HealthDashboardScreen()),
            ),
            GoRoute(
              path: AppRoutes.mission,
              pageBuilder: (context, state) => _fadeTransition(context, state, const MissionDashboardScreen()),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.settings,
          redirect: (context, state) => AppRoutes.profile,
        ),
        GoRoute(
          path: AppRoutes.account,
          builder: (context, state) => const AccountCenterScreen(),
        ),
        GoRoute(
          path: AppRoutes.myData,
          builder: (context, state) => const MyDataScreen(),
        ),
        GoRoute(
          path: AppRoutes.dataCenter,
          builder: (context, state) => const KnightCoreScreen(),
        ),
        GoRoute(
          path: '/hub/tasks',
          builder: (context, state) => const HubResourceListScreen(resourceType: 'task'),
        ),
        GoRoute(
          path: '/hub/contacts',
          builder: (context, state) => const HubResourceListScreen(resourceType: 'contact'),
        ),
        GoRoute(
          path: '/hub/emails',
          builder: (context, state) => const HubResourceListScreen(resourceType: 'email'),
        ),
        GoRoute(
          path: '/hub/calendar',
          builder: (context, state) => const HubResourceListScreen(resourceType: 'calendar'),
        ),
        GoRoute(
          path: '/hub/drive',
          builder: (context, state) => const HubResourceListScreen(resourceType: 'drive'),
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder: (context, state) => const SettingsSubPage(title: 'Data & Privacy'),
        ),
        GoRoute(
          path: AppRoutes.integrations,
          builder: (context, state) => const SyncCenterScreen(),
        ),
        GoRoute(
          path: '/settings/sync/gmail',
          builder: (context, state) => const GmailSyncDashboard(),
        ),
        GoRoute(
          path: '/settings/sync/calendar',
          builder: (context, state) => const CalendarSyncDashboard(),
        ),
        GoRoute(
          path: '/settings/sync/drive',
          builder: (context, state) => const DriveSyncDashboard(),
        ),
        GoRoute(
          path: AppRoutes.developerMode,
          builder: (context, state) => const DeveloperModeScreen(),
        ),
        GoRoute(
          path: AppRoutes.providerHealth,
          builder: (context, state) => const ProviderHealthScreen(),
        ),
        GoRoute(
          path: AppRoutes.googleDataAudit,
          builder: (context, state) => const GoogleDataAuditScreen(),
        ),
        GoRoute(
          path: AppRoutes.executiveDashboard,
          builder: (context, state) => const ExecutiveDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.automation,
          builder: (context, state) => const SettingsSubPage(title: 'Automation'),
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SettingsSubPage(title: 'Search'),
        ),
        GoRoute(
          path: AppRoutes.timeline,
          builder: (context, state) => const LifeAtlasScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeInbox,
          builder: (context, state) => const FinanceInboxScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeMissionControl,
          builder: (context, state) => const FinanceMissionControlScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeExplorer,
          builder: (context, state) => const FinanceExplorerScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeTimeline,
          builder: (context, state) => const FinanceTimelineScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeAnalytics,
          builder: (context, state) => const FinanceAnalyticsScreen(),
        ),
        GoRoute(
          path: AppRoutes.financePlanning,
          builder: (context, state) => const FinancePlanningScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeGoals,
          builder: (context, state) => const FinanceGoalsScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeAdvisor,
          builder: (context, state) => const FinanceAdvisorScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeReports,
          builder: (context, state) => const FinanceReportsScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeSettings,
          builder: (context, state) => const FinanceSettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.fitness,
          builder: (context, state) => const FitnessTrackerScreen(),
        ),
        GoRoute(
          path: AppRoutes.workoutLogger,
          builder: (context, state) => const WorkoutLoggerScreen(),
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
          builder: (context, state) => const KnowledgeVaultScreen(),
        ),
        GoRoute(
          path: AppRoutes.knowledgeGraph,
          builder: (context, state) => const KnowledgeGraphExplorerScreen(),
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
          path: AppRoutes.documents,
          builder: (context, state) => const KnowledgeVaultScreen(),
        ),
        GoRoute(
          path: AppRoutes.intelligence,
          builder: (context, state) => const IntelligenceDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.learning,
          builder: (context, state) => const LearningScreen(),
        ),
        GoRoute(
          path: AppRoutes.memory,
          builder: (context, state) => const MemoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.journal,
          builder: (context, state) => const JournalScreen(),
        ),
        GoRoute(
          path: AppRoutes.importCenter,
          builder: (context, state) => const ImportCenterScreen(),
        ),
        GoRoute(
          path: AppRoutes.brain,
          builder: (context, state) => const MyKnightBrainScreen(),
        ),
        GoRoute(
          path: AppRoutes.dataHub,
          builder: (context, state) => const KnightCoreScreen(),
        ),
        GoRoute(
          path: '/evidence/inbox',
          builder: (context, state) => const EvidenceInboxScreen(),
        ),
        GoRoute(
          path: AppRoutes.aiQa,
          builder: (context, state) => const KnightAiQaScreen(),
        ),
        GoRoute(
          path: AppRoutes.travelImport,
          builder: (context, state) => const TravelImportDashboard(),
        ),
        GoRoute(
          path: AppRoutes.travelTimeline,
          builder: (context, state) => const TravelTimelineScreen(),
        ),
        GoRoute(
          path: AppRoutes.travelMemoryLane,
          builder: (context, state) => const MemoryLaneScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.travelTripStory}/:tripId',
          builder: (context, state) => TripStoryScreen(tripId: state.pathParameters['tripId'] ?? ''),
        ),
        GoRoute(
          path: AppRoutes.travelDna,
          builder: (context, state) => const TravelDnaScreen(),
        ),
        GoRoute(
          path: AppRoutes.travelAssistant,
          builder: (context, state) => const TravelAssistantScreen(),
        ),
        GoRoute(
          path: AppRoutes.travelCompare,
          builder: (context, state) => TripComparisonScreen(tripIds: state.extra as List<String>),
        ),
        GoRoute(
          path: AppRoutes.careerTimeline,
          builder: (context, state) => const CareerTimelineScreen(),
        ),
        GoRoute(
          path: AppRoutes.careerDna,
          builder: (context, state) => const CareerDnaScreen(),
        ),
        GoRoute(
          path: AppRoutes.careerVault,
          builder: (context, state) => const AchievementVaultScreen(),
        ),
        GoRoute(
          path: AppRoutes.northStar,
          builder: (context, state) => const NorthStarScreen(),
        ),
        GoRoute(
          path: AppRoutes.missionCenter,
          builder: (context, state) => const MissionCenterScreen(),
        ),
      ],
    );
  });

  static CustomTransitionPage _fadeTransition(BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
