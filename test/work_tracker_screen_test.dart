import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/features/work_tracker/presentation/work_tracker_screen.dart';

void main() {
  testWidgets('Work tracker shows summary cards and history section', (tester) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/work_sessions.json');
    await file.writeAsString('[]');

    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: WorkTrackerScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Work Tracker'), findsOneWidget);
    expect(find.text('Log a session'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
