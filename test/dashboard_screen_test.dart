import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/app/screens/dashboard_screen.dart';
import 'package:knight_os/features/onboarding/domain/onboarding_profile.dart';

const MethodChannel _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
late Directory _tempDirectory;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _tempDirectory = await Directory.systemTemp.createTemp('knight_os_dashboard_test');
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

  testWidgets('Dashboard displays onboarding profile values from storage', (tester) async {
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
          fitnessLevel: 'Intermediate',
          currency: 'USD',
          monthlyIncome: '5200',
          monthlyBudget: '3600',
          savingsGoal: 'Emergency fund',
          lifeGoals: 'Build a calm, focused life',
          learningGoals: 'Finish a Flutter mastery plan',
          focusAreas: 'Deep work',
          reminderPreference: 'Morning and evening',
          aiPersonality: 'Supportive',
        ).toJson(),
      ),
    );

    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining(', Maya'), findsOneWidget);
    expect(find.textContaining('Remote'), findsOneWidget);
    expect(find.textContaining('Night Shift'), findsOneWidget);
    expect(find.textContaining('3 liters'), findsOneWidget);
  });
}
