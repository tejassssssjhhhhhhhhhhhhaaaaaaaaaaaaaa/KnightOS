import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen renders successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsScreen())),
    );

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('SettingsScreen displays profile information', (
    WidgetTester tester,
  ) async {
    // This is a minimal test to verify rendering.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );

    await tester.pump();
    expect(find.text('Tejas Jha'), findsAtLeast(1));
  });
}
