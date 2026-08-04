import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/router/app_router.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/providers/preferences_provider.dart';
import 'package:knight_os/core/storage/local_database.dart';
import 'package:knight_os/core/storage/storage_keys.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_utils/mock_path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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
    
    // Clean up local storage for each test
    const localDb = LocalDatabase();
    await localDb.delete(StorageKeys.welcomeSeen);
  });

  testWidgets('Fresh install: Splash -> Welcome -> Home (Guest)', (tester) async {
    mockAuth.authenticated = false;
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          knightDatabaseProvider.overrideWith((ref) => KnightDatabase.forTesting(NativeDatabase.memory())),
          storageInitializerProvider.overrideWith((ref) => Future.value()),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.watch(AppRouter.provider),
            );
          },
        ),
      ),
    );

    // 1. Splash Screen
    await tester.pump();
    expect(find.text('K N I G H T   O S'), findsOneWidget);
    
    // Wait for Splash timeout/navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(); // Handle navigation
    await tester.pump(const Duration(milliseconds: 100)); // Give it a bit of time

    // 2. Welcome Screen
    expect(find.textContaining('Think. Plan. Execute.'), findsOneWidget);
    
    // 3. Tap to begin -> Dashboard (Guest)
    await tester.tap(find.textContaining('Tap anywhere to begin'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500)); // Wait for navigation
    
    expect(find.textContaining('Guest'), findsOneWidget);
    expect(find.text('Sign in to enable this feature.'), findsWidgets);
  });

  testWidgets('Returning Guest: Splash -> Home', (tester) async {
    mockAuth.authenticated = false;
    
    // Set welcome seen
    const localDb = LocalDatabase();
    await localDb.writeString(StorageKeys.welcomeSeen, 'true');
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          knightDatabaseProvider.overrideWith((ref) => KnightDatabase.forTesting(NativeDatabase.memory())),
          storageInitializerProvider.overrideWith((ref) => Future.value()),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.watch(AppRouter.provider),
            );
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Directly to Home
    expect(find.textContaining('Guest'), findsOneWidget);
  });
}
