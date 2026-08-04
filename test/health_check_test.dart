import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/router/app_router.dart';
import 'package:knight_os/core/router/app_routes.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/providers/preferences_provider.dart';
import 'package:knight_os/core/intelligence/engines/sensor_fusion_engine.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'test_utils/mock_path_provider.dart';

class MockAuthRepo extends Fake implements AuthenticationRepository {
  bool authenticated = false;
  @override
  Future<bool> isAuthenticated() async => authenticated;
  @override
  Future<AuthSession?> getCurrentSession() async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthRepo mockAuth;
  late SharedPreferences prefs;

  setUp(() async {
    PathProviderPlatform.instance = MockPathProvider();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    mockAuth = MockAuthRepo();
    AuthenticationRepository.instance = mockAuth;
  });

  testWidgets('Sequential Route Health Check', (tester) async {
    final routes = [
      AppRoutes.splash,
      AppRoutes.welcome,
      AppRoutes.auth,
      AppRoutes.onboarding,
      AppRoutes.launch,
      AppRoutes.dashboard,
      AppRoutes.home,
      AppRoutes.lifeAtlas,
      AppRoutes.myPlace,
      AppRoutes.knight,
      AppRoutes.settings,
      AppRoutes.myData,
      AppRoutes.documents,
      AppRoutes.health,
      AppRoutes.finance,
      AppRoutes.fitness,
      AppRoutes.sleep,
      AppRoutes.work,
      AppRoutes.knowledgeVault,
      AppRoutes.knowledgeGraph,
      AppRoutes.planner,
      AppRoutes.mission,
      AppRoutes.connectors,
      AppRoutes.discovery,
      AppRoutes.intelligence,
      AppRoutes.voiceCapture,
    ];

    for (final route in routes) {
      debugPrint('TESTING ROUTE: $route');
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              knightDatabaseProvider.overrideWith((ref) => KnightDatabase.forTesting(NativeDatabase.memory())),
              storageInitializerProvider.overrideWith((ref) => Future.value()),
              sharedPreferencesProvider.overrideWithValue(prefs),
              sensorFusionEngineProvider.overrideWithValue(SensorFusionEngine()), // New instance for test isolation
            ],
            child: Consumer(
              builder: (context, ref, child) {
                final router = ref.watch(AppRouter.provider);
                return MaterialApp.router(
                  routerConfig: router,
                );
              },
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        debugPrint('SUCCESS: $route built');
      } catch (e, stack) {
        debugPrint('FAILURE: $route crashed during pump');
        debugPrint('Error: $e');
        debugPrint('Stack: $stack');
      }
    }
  });
}
