import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:knight_os/features/sleep/domain/sleep_session.dart';
import 'package:knight_os/features/sleep/presentation/sleep_tracker_screen.dart';

void main() {
  test('sleep duration is calculated from bed and wake times', () {
    const session = SleepSession(
      id: '1',
      sleepDate: '2026-07-23',
      bedTime: '22:30',
      wakeTime: '06:30',
      sleepQuality: 8,
      wakeUps: 1,
      napDuration: 0,
      moodAfterWaking: 'Refreshed',
      energyLevel: 7,
      notes: '',
      sleepDuration: 0,
    );

    expect(session.calculatedSleepDuration, 8.0);
  });

  testWidgets('sleep tracker screen renders the main form', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SleepTrackerScreen()));
    await tester.pump();

    expect(find.text('Sleep Tracker'), findsOneWidget);
  });
}
