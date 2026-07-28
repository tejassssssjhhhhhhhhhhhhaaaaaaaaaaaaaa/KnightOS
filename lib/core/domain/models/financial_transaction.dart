enum TransactionType { debit, credit, transfer }

class FinancialTransaction {
  const FinancialTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    this.type = TransactionType.debit,
    this.category = 'Uncategorized',
    this.merchant,
    this.reference,
    this.accountName,
    this.currency = 'INR',
    this.tags = const [],
  });

  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final TransactionType type;
  final String category;
  final String? merchant;
  final String? reference;
  final String? accountName;
  final String? currency;
  final List<String> tags;

  bool get isIncome => type == TransactionType.credit;
}
