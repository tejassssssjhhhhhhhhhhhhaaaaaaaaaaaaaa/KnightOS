import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/app/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    await tester.pump(const Duration(seconds: 1));
    // Verify static elements from Version 2 redesign
    expect(find.text('OPERATIONAL COMMAND'), findsOneWidget);
    expect(find.text('FOCUS SCORE'), findsOneWidget);
  });
}
