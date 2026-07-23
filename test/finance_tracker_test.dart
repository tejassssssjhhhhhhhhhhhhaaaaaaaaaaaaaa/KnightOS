import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

    final metrics = FinanceTransactionMetrics.fromTransactions([income, expense]);

    expect(metrics.totalIncome, 5000);
    expect(metrics.totalExpense, 1200);
    expect(metrics.netBalance, 3800);
    expect(metrics.savings, 3800);
    expect(metrics.weeklySpending, 1200);
    expect(metrics.monthlySpending, 1200);
    expect(metrics.topSpendingCategory, 'Food');
  });

  testWidgets('finance tracker screen renders the main form', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FinanceTrackerScreen()));
    await tester.pump();

    expect(find.text('Finance Tracker'), findsOneWidget);
  });
}
