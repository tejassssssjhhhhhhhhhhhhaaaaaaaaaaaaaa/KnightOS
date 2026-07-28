class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.transactionDate,
    required this.transactionType,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.account,
    required this.description,
    required this.notes,
  });

  final String id;
  final String transactionDate;
  final String transactionType;
  final double amount;
  final String category;
  final String paymentMethod;
  final String account;
  final String description;
  final String notes;

  bool get isIncome => transactionType.toLowerCase() == 'income';

  Map<String, Object> toJson() {
    return {
      'id': id,
      'transactionDate': transactionDate,
      'transactionType': transactionType,
      'amount': amount,
      'category': category,
      'paymentMethod': paymentMethod,
      'account': account,
      'description': description,
      'notes': notes,
    };
  }

  factory FinanceTransaction.fromJson(Map<String, Object?> json) {
    return FinanceTransaction(
      id: json['id'] as String? ?? '',
      transactionDate: json['transactionDate'] as String? ?? '',
      transactionType: json['transactionType'] as String? ?? 'Expense',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'Other',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      account: json['account'] as String? ?? '',
      description: json['description'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }
}

class FinanceTransactionMetrics {
  const FinanceTransactionMetrics({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.savings,
    required this.weeklySpending,
    required this.monthlySpending,
    required this.categorySpending,
    required this.averageDailySpending,
    required this.topSpendingCategory,
    required this.monthlyTrend,
  });

  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final double savings;
  final double weeklySpending;
  final double monthlySpending;
  final Map<String, double> categorySpending;
  final double averageDailySpending;
  final String topSpendingCategory;
  final double monthlyTrend;

  factory FinanceTransactionMetrics.fromTransactions(
    List<FinanceTransaction> transactions,
  ) {
    final income = transactions
        .where((transaction) => transaction.isIncome)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final expense = transactions
        .where((transaction) => !transaction.isIncome)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final spendingByCategory = <String, double>{};

    for (final transaction in transactions.where((item) => !item.isIncome)) {
      spendingByCategory.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final topSpendingCategory = spendingByCategory.entries.isEmpty
        ? 'No expenses'
        : spendingByCategory.entries
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;

    return FinanceTransactionMetrics(
      totalIncome: income,
      totalExpense: expense,
      netBalance: income - expense,
      savings: income - expense,
      weeklySpending: expense,
      monthlySpending: expense,
      categorySpending: spendingByCategory,
      averageDailySpending: expense > 0 ? expense / 30 : 0,
      topSpendingCategory: topSpendingCategory,
      monthlyTrend: expense > 0 ? income / expense : income,
    );
  }
}
