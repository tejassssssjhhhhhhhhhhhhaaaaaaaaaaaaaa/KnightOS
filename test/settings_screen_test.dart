import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/app/screens/settings_screen.dart';
import 'package:knight_os/features/onboarding/domain/onboarding_profile.dart';

const MethodChannel _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
late Directory _tempDirectory;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _tempDirectory = await Directory.systemTemp.createTemp('knight_os_settings_test');
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

  testWidgets('Settings screen loads and displays profile sections', (tester) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/onboarding_profile.json');
    await file.writeAsString(
      jsonEncode(
        const OnboardingProfile(
          completedSteps: ['personal', 'work', 'health', 'finance', 'goals', 'aiPreferences'],
          fullName: 'Maya Chen',
          preferredName: 'Maya',
          occupation: 'Product Designer',
          workType: 'Remote',
          shiftType: 'Night Shift',
          sleepGoal: '8 hours',
          waterGoal: '3 liters',
          exerciseFrequency: '5 days',
          monthlyBudget: '3600',
          monthlyIncome: '5200',
          savingsGoal: 'Emergency fund',
          aiPersonality: 'Supportive',
          themePreference: 'Dark',
          notificationPreference: 'Daily Reminder',
        ).toJson(),
      ),
    );

    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('App Settings'), findsOneWidget);
    expect(find.text('AI Settings'), findsOneWidget);
  });
}
