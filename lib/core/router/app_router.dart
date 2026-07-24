import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../app/placeholder_screen.dart';
import '../../app/screens/account_center_screen.dart';
import '../../app/screens/app_updates_screen.dart';
import '../../app/screens/auth_screen.dart';
import '../../app/screens/dashboard_screen.dart';
import '../../app/screens/premium_launch_screen.dart';
import '../../app/screens/onboarding_screen.dart';
import '../../app/screens/settings_screen.dart';
import '../../app/screens/splash_screen.dart';
import '../../app/screens/voice_capture_screen.dart';
import '../../app/screens/welcome_screen.dart';
import '../../features/journal/presentation/journal_screen.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/memory/presentation/memory_screen.dart';
import '../../features/onboarding/data/onboarding_storage.dart';
import '../../features/search/universal_search_screen.dart';
import '../../features/timeline/timeline_screen.dart';
import '../../core/repositories/authentication_repository.dart';
import '../../features/finance/presentation/finance_tracker_screen.dart';
import '../../features/fitness/presentation/fitness_tracker_screen.dart';
import '../../features/sleep/presentation/sleep_tracker_screen.dart';
import '../../features/work_tracker/presentation/work_tracker_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final publicPaths = <String>{
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.auth,
      };
      final location = state.matchedLocation;
      final repository = AuthenticationRepository();
      final authenticated = await repository.isAuthenticated();

      if (publicPaths.contains(location)) {
        if (!authenticated) {
          return null;
        }
        final profile = await OnboardingStorage().loadProfile();
        final onboardingComplete = profile != null && profile.completedSteps.isNotEmpty;
        return onboardingComplete ? AppRoutes.launch : AppRoutes.onboarding;
      }

      if (location == AppRoutes.onboarding) {
        final profile = await OnboardingStorage().loadProfile();
        if (profile != null && profile.completedSteps.isNotEmpty) {
          return AppRoutes.launch;
        }
      }

      if (!authenticated) {
        return AppRoutes.auth;
      }

      final profile = await OnboardingStorage().loadProfile();
      final onboardingComplete = profile != null && profile.completedSteps.isNotEmpty;
      if (!onboardingComplete && location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.auth, builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.launch,
        builder: (context, state) {
          return const PremiumLaunchScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.account,
        builder: (context, state) {
          return const AccountCenterScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.voiceCapture,
        builder: (context, state) {
          return const VoiceCaptureScreen();
        },
      ),
      ShellRoute(
        builder: (context, state, child) => KnightShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.home,
            redirect: (context, state) => AppRoutes.dashboard,
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) {
              return const SettingsScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) {
              return const SettingsScreen(view: SettingsView.profile);
            },
          ),
          GoRoute(
            path: AppRoutes.privacy,
            builder: (context, state) {
              return const SettingsScreen(view: SettingsView.privacy);
            },
          ),
          GoRoute(
            path: AppRoutes.appUpdates,
            builder: (context, state) {
              return const AppUpdatesScreen();
            },
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
            path: AppRoutes.timeline,
            builder: (context, state) => const TimelineScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const UniversalSearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.integrations,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Integrations',
              subtitle: 'Calendar, health, and device connections will be managed here.',
            ),
          ),
          GoRoute(
            path: AppRoutes.automation,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Automation',
              subtitle: 'Intelligent workflows will be orchestrated in this space.',
            ),
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
            path: AppRoutes.finance,
            builder: (context, state) => const FinanceTrackerScreen(),
          ),
          GoRoute(
            path: AppRoutes.fitness,
            builder: (context, state) => const FitnessTrackerScreen(),
          ),
          GoRoute(
            path: AppRoutes.planner,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Planner',
              subtitle: 'Mission planning and daily coordination will be organized here.',
            ),
          ),
          GoRoute(
            path: AppRoutes.knight,
            builder: (context, state) => const PlaceholderScreen(
              title: 'Knight',
              subtitle: 'Coming Soon',
            ),
          ),
        ],
      ),
    ],
  );
}
