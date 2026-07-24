import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:knight_os/features/onboarding/presentation/onboarding_screen.dart';
import 'package:knight_os/knight_os_app.dart';

void main() {
  testWidgets('KnightOS splash flow opens the welcome screen', (tester) async {
    await tester.pumpWidget(const KnightOsApp());
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    expect(find.text('KnightOS'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    expect(find.text('Welcome to KnightOS'), findsOneWidget);
  });

  testWidgets('Onboarding next and back buttons change the visible step', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingFlowScreen(),
      ),
    );

    expect(find.text('Personal'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex Morgan');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(2), '1990-01-01');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(6), 'United Kingdom');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(7), 'Europe/London');
    await tester.pump();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Work'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Personal'), findsOneWidget);
  });

  testWidgets('Onboarding requires personal details before advancing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingFlowScreen(),
      ),
    );

    final nextButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'));
    expect(nextButton.onPressed, isNull);
  });
}
