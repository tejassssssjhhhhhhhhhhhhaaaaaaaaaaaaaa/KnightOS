import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:knight_os/core/intelligence/knight_context_models.dart';
import 'package:knight_os/core/intelligence/knight_context_provider.dart';
import 'package:knight_os/features/finance/domain/finance_transaction.dart';
import 'package:knight_os/features/finance/presentation/finance_tracker_screen.dart';

void main() {
  test('finance transaction computes totals and balances', () {
    const income = FinanceTransaction(
      id: 'income-1',
      transactionDate: '2026-07-21',
      transactionType: 'Income',
      amount: 5000,
      category: 'Salary',
      paymentMethod: 'Bank Transfer',
      account: 'Salary Account',
      description: 'Monthly salary',
      notes: '',
    );

    const expense = FinanceTransaction(
      id: 'expense-1',
      transactionDate: '2026-07-22',
      transactionType: 'Expense',
      amount: 1200,
      category: 'Food',
      paymentMethod: 'Card',
      account: 'Checking',
      description: 'Groceries',
      notes: '',
    );

    final metrics = FinanceTransactionMetrics.fromTransactions([
      income,
      expense,
    ]);

    expect(metrics.totalIncome, 5000);
    expect(metrics.totalExpense, 1200);
    expect(metrics.netBalance, 3800);
    expect(metrics.savings, 3800);
    expect(metrics.weeklySpending, 1200);
    expect(metrics.monthlySpending, 1200);
    expect(metrics.topSpendingCategory, 'Food');
  });

  testWidgets('finance tracker screen renders the main form', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentContextNotifierProvider.overrideWith(MockContextNotifier.new),
        ],
        child: const MaterialApp(
          home: FinanceTrackerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('FINANCE'), findsOneWidget);
  });
}

class MockContextNotifier extends CurrentContextNotifier {
  @override
  Future<KnightContext> build() async {
    return KnightContext(
      registeredModules: [],
      currentScores: [],
      analyticsSummary: const KnightAnalyticsSummary(
        analyticsProviderCount: 0,
        snapshotsPlaceholder: '',
        weeklySummaryPlaceholder: '',
        monthlySummaryPlaceholder: '',
      ),
      recommendationSummary: const KnightRecommendationSummary(
        recommendationProviderCount: 0,
        recommendationCount: 0,
        topRecommendationPlaceholder: '',
      ),
      recentActivity: [],
      searchSummary: const KnightSearchSummary(
        searchProviderCount: 0,
        indexedModules: 0,
        lastSearchPlaceholder: '',
      ),
      moduleHealth: [],
      lastSyncTime: DateTime.now(),
      healthStatus: 'Optimal',
      dataFreshness: 'Live',
      applicationVersion: '1.0.0',
      fitnessSummary: const KnightFitnessSummary(
        gymProfileExists: false,
        equipmentCount: 0,
        capabilityPlaceholder: '',
        workoutPlaceholder: '',
      ),
      travelSummary: const KnightTravelSummary(
        visited: 0,
        wishlist: 0,
        planned: 0,
        favoritePlaces: 0,
        upcomingTripsPlaceholder: '',
      ),
      workSummary: const KnightWorkSummary(
        currentShiftPlaceholder: '',
        questions: 0,
        calls: 0,
        chats: 0,
        dailyTarget: 0,
        productivityPlaceholder: '',
      ),
      timestamp: DateTime.now(),
      greeting: 'Morning',
      sleepStatus: 'Optimal recovery',
      upcomingEvents: [],
      currentGoals: ['Test Goal'],
      healthSummary: 'Vital signs nominal',
      weather: 'Clear skies',
      focusScore: 0.87,
      totalBalance: 245000,
      steps: 8000,
      calories: 1200,
      waterIntake: 1.8,
    );
  }
}
