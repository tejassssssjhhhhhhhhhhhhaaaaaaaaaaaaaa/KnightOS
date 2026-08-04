import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/home_screen.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_utils/mock_path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockContextNotifier extends CurrentContextNotifier {
  @override
  Future<KnightContext> build() async {
    return KnightContext(
      registeredModules: [],
      currentScores: [],
      analyticsSummary: const KnightAnalyticsSummary(analyticsProviderCount: 0, snapshotsPlaceholder: '', weeklySummaryPlaceholder: '', monthlySummaryPlaceholder: ''),
      recommendationSummary: const KnightRecommendationSummary(recommendationProviderCount: 0, recommendationCount: 0, topRecommendationPlaceholder: ''),
      recentActivity: [],
      searchSummary: const KnightSearchSummary(searchProviderCount: 0, indexedModules: 0, lastSearchPlaceholder: ''),
      moduleHealth: [],
      lastSyncTime: DateTime.now(),
      healthStatus: 'Optimal',
      dataFreshness: 'Live',
      applicationVersion: '4.0.0',
      fitnessSummary: const KnightFitnessSummary(gymProfileExists: false, equipmentCount: 0, capabilityPlaceholder: '', workoutPlaceholder: ''),
      travelSummary: const KnightTravelSummary(visited: 0, wishlist: 0, planned: 0, favoritePlaces: 0, upcomingTripsPlaceholder: ''),
      workSummary: const KnightWorkSummary(currentShiftPlaceholder: '', questions: 0, calls: 0, chats: 0, dailyTarget: 0, productivityPlaceholder: ''),
      timestamp: DateTime.now(),
      greeting: 'Morning',
      sleepStatus: 'Optimal',
      upcomingEvents: [],
      currentGoals: [],
      healthSummary: 'Nominal',
      weather: 'Sunny',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    PathProviderPlatform.instance = MockPathProvider();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('HomeScreen Basic Render (No pumpAndSettle)', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          knightDatabaseProvider.overrideWith((ref) => KnightDatabase.forTesting(NativeDatabase.memory())),
          storageInitializerProvider.overrideWith((ref) => Future.value()),
          currentContextNotifierProvider.overrideWith(MockContextNotifier.new),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pump(); // Start building
    await tester.pump(const Duration(milliseconds: 500)); // Advance animations

    // Verify presence of major components
    expect(find.textContaining('Morning'), findsOneWidget);
    expect(find.text('SYSTEM SNAPSHOT'), findsOneWidget);
  });
}
