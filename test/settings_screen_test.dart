import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/screens/settings_screen.dart';
import 'package:knight_os/core/providers/storage_providers.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';

void main() {
  testWidgets('SettingsScreen renders successfully', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith((ref) => const AuthSession(
            userId: 'test-user',
            displayName: 'Knight',
            isAuthenticated: true,
          )),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('Knight'), findsOneWidget);
  });

  testWidgets('SettingsScreen displays profile information', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('Sign in to enable cloud sync'), findsOneWidget);
  });
}
