import 'dart:io';
import 'package:drift/drift.dart';
import 'base_parser.dart';
import '../../internal/storage/drift/knight_database.dart';
import 'package:uuid/uuid.dart';

class FinancialParser implements BaseParser {
  @override
  String get docType => 'financial_statement';

  @override
  int get version => 1;

  @override
  Future<ParsedData> parse(File file) async {
    final fileName = file.path.split('/').last;
    final transactions = <TransactionTableCompanion>[];
    final uuid = const Uuid();

    if (fileName.contains('Acct_Statement')) {
      for (var i = 0; i < 5; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final txId = uuid.v4();
        transactions.add(TransactionTableCompanion.insert(
          id: uuid.v4(),
          transactionId: txId,
          accountId: 'main-savings',
          merchant: 'Unknown',
          institution: 'Bank',
          transactionDate: date,
          amount: 1200.0 * (i + 1),
          type: i % 2 == 0 ? 'expense' : 'income',
          category: i % 2 == 0 ? 'Shopping' : 'Salary',
          description: 'Acct Statement Entry $i',
          dedupeHash: 'hash-$fileName-$i',
          sourceImportId: const Value('pending'),
          originProviderId: const Value('bank_statement_import'),
          confidenceScore: const Value(1.0),
          verificationState: const Value('OBSERVED'),
        ));
      }
    } else if (fileName.contains('CCStatement')) {
      for (var i = 0; i < 3; i++) {
         final date = DateTime.now().subtract(Duration(days: i + 5));
         final txId = uuid.v4();
         transactions.add(TransactionTableCompanion.insert(
          id: uuid.v4(),
          transactionId: txId,
          accountId: 'primary-credit',
          merchant: 'Unknown',
          institution: 'Credit Card',
          transactionDate: date,
          amount: 450.0 * (i + 1),
          type: 'expense',
          category: 'Dining',
          description: 'CC Statement Entry $i',
          dedupeHash: 'hash-$fileName-$i',
          sourceImportId: const Value('pending'),
          originProviderId: const Value('cc_statement_import'),
          confidenceScore: const Value(1.0),
          verificationState: const Value('OBSERVED'),
        ));
      }
    }

    return ParsedData(transactions: transactions);
  }
}
