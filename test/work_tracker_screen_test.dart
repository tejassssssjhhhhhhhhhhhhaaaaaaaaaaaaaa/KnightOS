import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/features/work_tracker/presentation/work_tracker_screen.dart';

const MethodChannel _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
late Directory _tempDirectory;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _tempDirectory = await Directory.systemTemp.createTemp('knight_os_work_tracker_test');
    _pathProviderChannel.setMockMethodCallHandler((call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return _tempDirectory.path;
      }
      return null;
    });
  });

  tearDownAll(() async {
    _pathProviderChannel.setMockMethodCallHandler(null);
    if (await _tempDirectory.exists()) {
      await _tempDirectory.delete(recursive: true);
    }
  });

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
