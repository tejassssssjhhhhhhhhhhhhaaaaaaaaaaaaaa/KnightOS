import '../interfaces/finance_parser.dart';

class ExtractionResult {
  final String messageId;
  final String? transactionId;
  final double? amount;
  final DateTime? date;
  final String? merchant;
  final String? referenceNumber;
  final String? account;
  final String? card;
  final double? balance;
  final String? currency;
  final String? statementPeriod;
  final String? paymentMethod;
  final String? institution;
  final String parserVersion;
  final ConfidenceLevel confidenceLevel;
  final double confidenceScore;
  final Map<String, dynamic> rawExtractedData;

  ExtractionResult({
    required this.messageId,
    this.transactionId,
    this.amount,
    this.date,
    this.merchant,
    this.referenceNumber,
    this.account,
    this.card,
    this.balance,
    this.currency,
    this.statementPeriod,
    this.paymentMethod,
    this.institution,
    required this.parserVersion,
    required this.confidenceLevel,
    required this.confidenceScore,
    this.rawExtractedData = const {},
  });
}
