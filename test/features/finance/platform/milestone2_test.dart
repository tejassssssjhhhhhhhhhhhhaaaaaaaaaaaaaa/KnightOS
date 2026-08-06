import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:drift/drift.dart' hide isNotNull;
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:knight_os/features/finance/platform/engine/institution_discovery_engine.dart';
import 'package:knight_os/features/finance/platform/engine/finance_classification_engine.dart';
import 'package:knight_os/core/services/google_auth_service.dart';
import 'package:knight_os/features/finance/platform/interfaces/finance_classification.dart';

class MockGmailApi extends Mock implements gmail.GmailApi {}
class MockUsersResource extends Mock implements gmail.UsersResource {}
class MockMessagesResource extends Mock implements gmail.UsersMessagesResource {}
class MockGoogleAuthService extends Mock implements GoogleAuthService {}

void main() {
  late KnightDatabase db;
  late MockGmailApi mockApi;
  late MockMessagesResource mockMessages;
  late MockGoogleAuthService mockAuth;

  setUp(() {
    db = KnightDatabase.forTesting(NativeDatabase.memory());
    mockApi = MockGmailApi();
    mockMessages = MockMessagesResource();
    mockAuth = MockGoogleAuthService();
    
    final mockUsers = MockUsersResource();
    when(() => mockApi.users).thenReturn(mockUsers);
    when(() => mockUsers.messages).thenReturn(mockMessages);
  });

  tearDown(() async {
    await db.close();
  });

  group('InstitutionDiscoveryEngine', () {
    test('discoverInstitutions identifies common banks', () async {
      await db.into(db.gmailMessageTable).insert(
        GmailMessageTableCompanion.insert(
          id: 'msg1',
          threadId: 't1',
          historyId: 'h1',
          subject: 'ICICI Bank Statement',
          sender: 'statements@icicibank.com',
          recipients: 'me@gmail.com',
          messageDate: DateTime.now(),
          labels: '',
          snippet: 'Your monthly statement',
          internalDate: BigInt.from(0),
          originAccount: 'me@gmail.com',
        ),
      );

      final discovery = InstitutionDiscoveryEngine(db: db);
      await discovery.discoverInstitutions();

      final institutions = await db.select(db.financeInstitutionMetadataTable).get();
      expect(institutions.any((i) => i.name == 'ICICI Bank'), true);
      expect(institutions.firstWhere((i) => i.name == 'ICICI Bank').type, 'Bank');
    });
  });

  group('FinanceClassificationEngine', () {
    test('classifyAll terminal intent mapping', () async {
      await db.into(db.gmailMessageTable).insert(
        GmailMessageTableCompanion.insert(
          id: 'msg-upi',
          threadId: 't1',
          historyId: 'h1',
          subject: 'UPI Transaction',
          sender: 'upi@bank.com',
          recipients: 'me@gmail.com',
          messageDate: DateTime.now(),
          labels: '',
          snippet: 'Paid Rs. 100 via UPI',
          internalDate: BigInt.from(0),
          originAccount: 'me@gmail.com',
        ),
      );

      await db.into(db.financeSyncJournalTable).insert(
                FinanceSyncJournalTableCompanion.insert(
                  id: 'msg-upi',
                  messageId: 'msg-upi',
                  parserVersion: '0.0.0',
                  processingResult: 'Discovered',
                  processedAt: DateTime.now(),
                ),
              );

      final classifier = FinanceClassificationEngine(db: db);
      await classifier.classifyAll();

      final journal = await (db.select(db.financeSyncJournalTable)..where((t) => t.messageId.equals('msg-upi'))).getSingle();
      expect(journal.processingResult, 'Classified');
      expect(journal.errorLog, FinanceCategory.upi.name);

      final classifications = await db.select(db.emailClassificationTable).get();
      expect(classifications.length, 1);
      expect(classifications.first.category, FinanceCategory.upi.name);
    });
  });
}
