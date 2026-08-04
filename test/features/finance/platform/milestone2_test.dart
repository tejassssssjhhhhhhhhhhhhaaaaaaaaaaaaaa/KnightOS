import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:drift/drift.dart' hide isNotNull;
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:drift/native.dart';
import 'package:knight_os/features/finance/platform/sync/historical_scanner_service.dart';
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
  late HistoricalScannerService scanner;
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

    scanner = HistoricalScannerService(
      db: db,
      authService: mockAuth,
      gmailApi: mockApi,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('HistoricalScannerService', () {
    test('startHistoricalScan fetches and stores messages', () async {
      // Mock list response
      final listResponse = gmail.ListMessagesResponse(
        messages: [gmail.Message(id: 'msg1', threadId: 't1')],
        nextPageToken: null,
      );
      
      when(() => mockMessages.list(
            'me',
            pageToken: any(named: 'pageToken'),
            maxResults: any(named: 'maxResults'),
            q: any(named: 'q'),
          )).thenAnswer((_) async => listResponse);

      // Mock get response
      final fullMsg = gmail.Message(
        id: 'msg1',
        threadId: 't1',
        historyId: 'h1',
        snippet: 'Your HDFC Bank account credited with Rs. 5000',
        internalDate: DateTime.now().millisecondsSinceEpoch.toString(),
        payload: gmail.MessagePart(
          headers: [
            gmail.MessagePartHeader(name: 'Subject', value: 'Transaction Alert'),
            gmail.MessagePartHeader(name: 'From', value: 'alerts@hdfcbank.net'),
          ],
        ),
      );
      
      when(() => mockMessages.get('me', 'msg1')).thenAnswer((_) async => fullMsg);

      await scanner.startHistoricalScan();

      final stored = await db.select(db.gmailMessageTable).get();
      expect(stored.length, 1);
      expect(stored.first.id, 'msg1');
      expect(stored.first.sender, 'alerts@hdfcbank.net');

      final journal = await db.select(db.financeSyncJournalTable).get();
      expect(journal.length, 1);
      expect(journal.first.processingResult, 'Discovered');
    });

    test('startHistoricalScan supports resume via checkpoint', () async {
      // Setup checkpoint in DB
      await db.into(db.providerSyncMetadataTable).insert(
        ProviderSyncMetadataTableCompanion.insert(
          id: 'finance_historical_scan_cursor',
          providerId: 'gmail',
          stateKey: 'finance_historical_scan_cursor',
          stateValue: 'token123',
          lastUpdated: Value(DateTime.now()),
        ),
      );

      final listResponse = gmail.ListMessagesResponse(messages: [], nextPageToken: null);
      when(() => mockMessages.list(
        'me',
        pageToken: 'token123',
        maxResults: 50,
        q: any(named: 'q'),
      )).thenAnswer((_) async => listResponse);

      await scanner.startHistoricalScan();

      verify(() => mockMessages.list(
        'me',
        pageToken: 'token123',
        maxResults: 50,
        q: any(named: 'q'),
      )).called(1);
    });
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
