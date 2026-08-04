import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:knight_os/features/onboarding/presentation/onboarding_screen.dart';
import 'package:knight_os/knight_os_app.dart';
import 'package:knight_os/core/providers/database_provider.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/core/design_system/widgets/knight_circuit_shield.dart';
import 'package:drift/native.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knight_os/core/theme/app_theme.dart';

class MockAuthRepository extends Fake implements AuthenticationRepository {
  @override
  Future<bool> isAuthenticated() async => false;
  @override
  Future<AuthSession?> getCurrentSession() async => null;
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    AuthenticationRepository.instance = MockAuthRepository();
  });

  testWidgets('KnightOS splash flow opens', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            knightDatabaseProvider.overrideWith((ref) {
              final db = KnightDatabase.forTesting(NativeDatabase.memory());
              ref.onDispose(() => db.close());
              return db;
            }),
            storageInitializerProvider.overrideWith((ref) => Future.value()),
            authenticationRepositoryProvider.overrideWith(
              (ref) => MockAuthRepository(),
            ),
          ],
          child: const KnightOsApp(),
        ),
      );
      // Advance clock to clear cinematic effect and storage init
      await tester.pump(const Duration(seconds: 3));
      // Verify logo appears
      expect(find.byType(KnightCircuitShield), findsWidgets);
    });
  });

  testWidgets('Onboarding renders first step', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          knightDatabaseProvider.overrideWith((ref) {
            final db = KnightDatabase.forTesting(NativeDatabase.memory());
            ref.onDispose(() => db.close());
            return db;
          }),
          storageInitializerProvider.overrideWith((ref) => Future.value()),
          authenticationRepositoryProvider.overrideWith(
            (ref) => MockAuthRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme(isTest: true),
          home: const OnboardingFlowScreen(),
        ),
      ),
    );

    expect(find.text('Personal'), findsOneWidget);
    expect(find.text('Share the essentials so KnightOS can personalize your experience.'), findsOneWidget);
  });
}
