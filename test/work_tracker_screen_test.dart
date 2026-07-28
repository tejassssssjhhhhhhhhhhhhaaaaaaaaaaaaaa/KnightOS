import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:knight_os/features/work_tracker/presentation/work_tracker_screen.dart';

void main() {
  testWidgets('Work tracker renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WorkTrackerScreen())),
    );
    await tester.pump();

    expect(find.text('WORK TRACKER'), findsOneWidget);
  });
}
