import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/screens/auth_screen.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/intelligence/providers/intelligence_providers.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_utils/mock_path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class MockAuthRepo extends Fake implements AuthenticationRepository {
  @override
  Future<bool> isAuthenticated() async => false;
  @override
  Future<AuthSession?> getCurrentSession() async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    PathProviderPlatform.instance = MockPathProvider();
    SharedPreferences.setMockInitialValues({});
    AuthenticationRepository.instance = MockAuthRepo();
  });

  testWidgets('AuthScreen Interaction: Toggle Login/Signup and Text Inputs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          knightDatabaseProvider.overrideWith((ref) => KnightDatabase.forTesting(NativeDatabase.memory())),
          storageInitializerProvider.overrideWith((ref) => Future.value()),
        ],
        child: const MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Initial State: Login
    expect(find.text('Log in to KnightOS'), findsOneWidget); // Body header
    expect(find.text('LOG IN TO KNIGHTOS'), findsOneWidget); // AppBar title
    expect(find.text('Sign In'), findsOneWidget);

    // 2. Test Text Fields
    await tester.enterText(find.byType(TextField).first, 'test@knight.os');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.pump();
    
    expect(find.text('test@knight.os'), findsOneWidget);

    // 3. Toggle to Signup
    final toggleButton = find.text('Create Account');
    expect(toggleButton, findsWidgets); // Might find multiple (Title and Button)
    await tester.tap(toggleButton.last);
    await tester.pumpAndSettle();

    expect(find.text('Create your KnightOS account'), findsOneWidget);
    expect(find.text('Create Account'), findsWidgets);
    
    // 4. Verification: Name field appeared
    expect(find.byType(TextField), findsNWidgets(3));
  });
}
