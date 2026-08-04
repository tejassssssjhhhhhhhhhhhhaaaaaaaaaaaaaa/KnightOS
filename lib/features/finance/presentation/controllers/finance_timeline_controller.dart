import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../domain/finance_timeline_models.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/providers/database_provider.dart';

final financeTimelineProvider = AsyncNotifierProvider<FinanceTimelineController, List<FinanceTimelinePeriod>>(
  FinanceTimelineController.new,
);

class FinanceTimelineController extends AsyncNotifier<List<FinanceTimelinePeriod>> {
  @override
  Future<List<FinanceTimelinePeriod>> build() async {
    return _generateTimeline();
  }

  Future<List<FinanceTimelinePeriod>> _generateTimeline() async {
    final db = ref.watch(knightDatabaseProvider);
    
    // Fetch all canonical transactions
    final txs = await (db.select(db.transactionTable)
          ..where((t) => t.isLatest.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();

    if (txs.isEmpty) return [];

    // Group by Month
    final grouped = groupBy(txs, (TransactionData t) => DateTime(t.transactionDate.year, t.transactionDate.month));

    final periods = <FinanceTimelinePeriod>[];

    for (final date in grouped.keys) {
      final periodTxs = grouped[date]!;
      double income = 0;
      double expenses = 0;
      TransactionData? largest;
      final categoryCounts = <String, double>{};

      for (final tx in periodTxs) {
        if (tx.type == 'income') {
          income += tx.amount;
        } else {
          expenses += tx.amount;
          if (largest == null || tx.amount > largest.amount) {
            largest = tx;
          }
          categoryCounts[tx.category] = (categoryCounts[tx.category] ?? 0) + tx.amount;
        }
      }

      final topCategory = categoryCounts.entries.isNotEmpty 
          ? categoryCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key 
          : null;

      periods.add(FinanceTimelinePeriod(
        date: date,
        income: income,
        expenses: expenses,
        savings: income - expenses,
        largestPurchase: largest,
        topCategory: topCategory,
        transactionCount: periodTxs.length,
        events: _detectEvents(periodTxs, date),
        aiSummary: _generateSummary(income, expenses, topCategory),
      ));
    }

    return periods;
  }

  List<FinanceMemoryEvent> _detectEvents(List<TransactionData> txs, DateTime periodDate) {
    final events = <FinanceMemoryEvent>[];
    
    for (final tx in txs) {
      // Large Purchase (> 50k)
      if (tx.amount > 50000 && tx.type == 'expense') {
        events.add(FinanceMemoryEvent(
          date: tx.transactionDate,
          title: 'Significant Purchase',
          description: 'Acquired ${tx.merchant} for ₹${tx.amount.toStringAsFixed(0)}',
          type: FinanceMemoryEventType.largePurchase,
          relatedTransaction: tx,
        ));
      }
      
      // Refund
      if (tx.type == 'refund' || (tx.type == 'income' && tx.category.toLowerCase().contains('refund'))) {
         events.add(FinanceMemoryEvent(
          date: tx.transactionDate,
          title: 'Refund Received',
          description: '₹${tx.amount.toStringAsFixed(0)} from ${tx.merchant} returned to vault.',
          type: FinanceMemoryEventType.refundReceived,
          relatedTransaction: tx,
        ));
      }

      // Salary
      if (tx.category.toLowerCase() == 'salary') {
         events.add(FinanceMemoryEvent(
          date: tx.transactionDate,
          title: 'Payroll Ingested',
          description: 'Monthly compensation from ${tx.merchant} received.',
          type: FinanceMemoryEventType.firstSalary,
          relatedTransaction: tx,
        ));
      }
    }
    
    return events;
  }

  String _generateSummary(double income, double expenses, String? topCategory) {
    if (income == 0 && expenses == 0) return 'No activity recorded.';
    final savingsRate = income > 0 ? ((income - expenses) / income * 100).toInt() : 0;
    return 'Saved $savingsRate% of income. Primary outflow: $topCategory.';
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _generateTimeline());
  }
}
