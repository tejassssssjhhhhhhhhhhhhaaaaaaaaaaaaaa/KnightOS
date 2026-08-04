import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../importers/base_parser.dart';
import '../services/data_ingestion_service.dart';

class EmailExtractionEngine {
  EmailExtractionEngine({
    required this.ingestionService,
  });

  final DataIngestionService ingestionService;

  /// Process recent emails and extract structured knowledge.
  Future<void> processEmails(List<Map<String, dynamic>> messages) async {
    final transactions = <TransactionTableCompanion>[];
    final timelineEvents = <TimelineEventTableCompanion>[];

    for (final msg in messages) {
      final subject = msg['subject'] as String? ?? '';
      final snippet = msg['snippet'] as String? ?? '';
      final messageId = msg['id'] as String;
      final date = msg['date'] as DateTime? ?? DateTime.now();

      final entities = _extractEntities(subject, snippet, date, messageId, 'gmail-sync');
      
      for (final entity in entities) {
        if (entity is TransactionTableCompanion) {
          transactions.add(entity);
        } else if (entity is TimelineEventTableCompanion) {
          timelineEvents.add(entity);
        }
      }
    }

    if (transactions.isNotEmpty || timelineEvents.isNotEmpty) {
      final parsedData = ParsedData(
        transactions: transactions,
        timelineEvents: timelineEvents,
        healthMetrics: [],
      );
      await ingestionService.ingestCloudData('gmail_api', parsedData);
    }
  }

  List<dynamic> _extractEntities(String subject, String snippet, DateTime date, String messageId, String importId) {
    final List<dynamic> entities = [];
    final text = '$subject $snippet'.toLowerCase();

    // 1. Finance: UPI/Bank Transactions
    if (text.contains('credited') || text.contains('debited') || text.contains('upi')) {
      final amount = _extractAmount(text);
      if (amount != null) {
        entities.add(TransactionTableCompanion.insert(
          id: 'gm-tx-$messageId',
          transactionId: 'gm-tx-$messageId',
          accountId: 'main-savings',
          merchant: 'Unknown',
          institution: 'Gmail',
          description: _cleanSubject(subject),
          amount: amount,
          transactionDate: date,
          type: text.contains('credited') ? 'income' : 'expense',
          category: 'finance',
          dedupeHash: 'gmail-$messageId',
          sourceProvider: const Value('gmail_api'),
          sourceIdentifier: Value(messageId),
          sourceImportId: Value(importId),
        ));
      }
    }

    // 2. Travel: Flights
    if (text.contains('flight') || text.contains('boarding pass') || text.contains('pnr')) {
      entities.add(TimelineEventTableCompanion.insert(
        id: 'gm-ev-$messageId',
        title: _cleanSubject(subject),
        startTime: date,
        endTime: date.add(const Duration(hours: 2)),
        type: 'travel',
        metadata: Value(snippet),
        sourceProvider: const Value('gmail_api'),
        sourceIdentifier: Value(messageId),
        sourceImportId: Value(importId),
      ));
    }

    // 3. Career: Offers/Payslips
    if (text.contains('offer letter') || text.contains('payslip')) {
       entities.add(TimelineEventTableCompanion.insert(
        id: 'gm-career-$messageId',
        title: _cleanSubject(subject),
        startTime: date,
        endTime: date,
        type: 'career',
        metadata: Value(snippet),
        sourceProvider: const Value('gmail_api'),
        sourceIdentifier: Value(messageId),
        sourceImportId: Value(importId),
      ));
    }

    return entities;
  }

  double? _extractAmount(String text) {
    // Basic regex for amount extraction like "Rs. 500" or "INR 1,200"
    final regExp = RegExp(r'(?:rs|inr)\.?\s*([\d,]+(?:\.\d{2})?)');
    final match = regExp.firstMatch(text);
    if (match != null) {
      final val = match.group(1)?.replaceAll(',', '');
      return double.tryParse(val ?? '');
    }
    return null;
  }

  String _cleanSubject(String subject) {
    return subject.replaceAll(RegExp(r'^(re|fwd|fwd): \s*', caseSensitive: false), '').trim();
  }
}
