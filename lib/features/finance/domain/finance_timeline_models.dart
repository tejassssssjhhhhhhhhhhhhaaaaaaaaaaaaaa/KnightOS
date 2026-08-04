import '../../../../core/internal/storage/drift/knight_database.dart';

class FinanceTimelinePeriod {
  final DateTime date;
  final double income;
  final double expenses;
  final double savings;
  final TransactionData? largestPurchase;
  final String? topCategory;
  final int transactionCount;
  final List<FinanceMemoryEvent> events;
  final String? aiSummary;

  FinanceTimelinePeriod({
    required this.date,
    required this.income,
    required this.expenses,
    required this.savings,
    this.largestPurchase,
    this.topCategory,
    required this.transactionCount,
    this.events = const [],
    this.aiSummary,
  });
}

enum FinanceMemoryEventType {
  firstSalary,
  salaryIncrease,
  largePurchase,
  newSubscription,
  loanClosed,
  investmentStarted,
  vacation,
  refundReceived,
}

class FinanceMemoryEvent {
  final DateTime date;
  final String title;
  final String description;
  final FinanceMemoryEventType type;
  final TransactionData? relatedTransaction;
  final double? impact;

  FinanceMemoryEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    this.relatedTransaction,
    this.impact,
  });
}
