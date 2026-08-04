import 'package:flutter/foundation.dart';

enum FinancialAccountType { bank, creditCard, wallet, investment, loan }

@immutable
class FinancialAccount {
  const FinancialAccount({
    required this.id,
    required this.name,
    required this.institution,
    required this.type,
    required this.balance,
    required this.currency,
    this.lastSyncAt,
  });

  final String id;
  final String name;
  final String institution;
  final FinancialAccountType type;
  final double balance;
  final String currency;
  final DateTime? lastSyncAt;
}

@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.currency,
    required this.merchant,
    required this.category,
    required this.timestamp,
    this.description,
    this.isSubscription = false,
    this.isEmi = false,
  });

  final String id;
  final String accountId;
  final double amount;
  final String currency;
  final String merchant;
  final String category;
  final DateTime timestamp;
  final String? description;
  final bool isSubscription;
  final bool isEmi;
}

@immutable
class Budget {
  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.period, // e.g., 'monthly'
  });

  final String id;
  final String category;
  final double limit;
  final double spent;
  final String period;
}

@immutable
class Bill {
  const Bill({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.category,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  final String? category;
}
