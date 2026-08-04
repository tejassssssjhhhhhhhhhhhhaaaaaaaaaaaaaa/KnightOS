import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/features/work_tracker/presentation/work_tracker_screen.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';

void main() {
  testWidgets('Work tracker renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentContextNotifierProvider.overrideWith(() => MockContextNotifier()),
        ],
        child: const MaterialApp(
          home: WorkTrackerScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('CAREER'), findsOneWidget);
  });
}

class MockContextNotifier extends CurrentContextNotifier {
  @override
  Future<KnightContext> build() async {
    return KnightContext(
      workSummary: const KnightWorkSummary(
        currentShiftPlaceholder: 'Mock Shift',
        questions: 0,
        calls: 0,
        chats: 0,
        dailyTarget: 8,
        productivityPlaceholder: 'Mock Productivity',
      ),
    );
  }
}
