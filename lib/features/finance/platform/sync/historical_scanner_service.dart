import 'dart:async';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:drift/drift.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../../core/internal/utils/knight_logger.dart';
import '../interfaces/finance_sync.dart';

class HistoricalScannerService implements ISmartSyncEngine {
  HistoricalScannerService({
    required this.db,
    required this.authService,
    this.gmailApi,
  });

  final KnightDatabase db;
  final GoogleAuthService authService;
  final gmail.GmailApi? gmailApi;

  final _progressController = StreamController<SyncProgress>.broadcast();

  @override
  Stream<SyncProgress> get progress => _progressController.stream;

  @override
  Future<void> startSync() async {
    // Incremental sync implementation in milestone 5
    throw UnimplementedError('Real-time sync reserved for Milestone 5');
  }

  @override
  Future<void> startHistoricalScan() async {
    KnightLogger.info('[FINANCE] Starting Historical Gmail Scan');
    _progressController.add(SyncProgress(
      percentage: 0.0,
      currentStage: 'Initializing',
      status: 'Connecting to Gmail...',
    ));

    try {
      final api = gmailApi ?? gmail.GmailApi(await authService.getAuthenticatedClient());
      
      // Resume logic: Fetch last checkpoint
      final checkpoint = await (db.select(db.providerSyncMetadataTable)
            ..where((t) => t.providerId.equals('gmail'))
            ..where((t) => t.stateKey.equals('finance_historical_scan_cursor')))
          .getSingleOrNull();
      
      String? pageToken = checkpoint?.stateValue;
      if (pageToken != null) {
        KnightLogger.info('[FINANCE] Resuming Historical Scan from checkpoint');
      }

      int processedCount = 0;

      do {
        final listResponse = await api.users.messages.list(
          'me',
          pageToken: pageToken,
          maxResults: 50, // Batch size
          q: 'has:attachment OR "rs." OR "inr" OR "credited" OR "debited" OR "transaction" OR "statement"',
        );

        final messages = listResponse.messages ?? [];
        if (messages.isEmpty) break;

        for (final msg in messages) {
          final messageId = msg.id!;
          
          // 1. Check if already in Sync Journal
          final existing = await (db.select(db.financeSyncJournalTable)
                ..where((t) => t.messageId.equals(messageId)))
              .getSingleOrNull();

          if (existing != null) continue;

          // 2. Fetch full message
          final fullMsg = await api.users.messages.get('me', messageId);
          
          // 3. Store in GmailMessageTable for persistence and discovery
          await _storeMessage(fullMsg);

          // 4. Initial Journal Entry (Terminal State: Discovery)
          await db.into(db.financeSyncJournalTable).insert(
                FinanceSyncJournalTableCompanion.insert(
                  id: messageId,
                  messageId: messageId,
                  parserVersion: '0.0.0', // Not parsed yet
                  processingResult: 'Discovered',
                  processedAt: DateTime.now(),
                ),
              );

          processedCount++;
          _updateProgress(processedCount, pageToken != null);
        }

        pageToken = listResponse.nextPageToken;
        // Checkpoint: Save pageToken to resume if interrupted
        await _saveCheckpoint(pageToken);

      } while (pageToken != null);

      _progressController.add(SyncProgress(
        percentage: 1.0,
        currentStage: 'Completed',
        status: 'Historical scan finished. $processedCount messages discovered.',
      ));
    } catch (e) {
      KnightLogger.error('[FINANCE] Historical Scan failed', error: e);
      _progressController.add(SyncProgress(
        percentage: 0.0,
        currentStage: 'Failed',
        status: 'Error: ${e.toString()}',
      ));
      rethrow;
    }
  }

  @override
  Future<void> repair() async {
    // Repair logic in milestone 4
    throw UnimplementedError('Repair Engine reserved for Milestone 4');
  }

  Future<void> _storeMessage(gmail.Message msg) async {
    final internalDate = int.tryParse(msg.internalDate ?? '0') ?? 0;
    final date = DateTime.fromMillisecondsSinceEpoch(internalDate);

    final subject = _getHeader(msg, 'Subject') ?? '(No Subject)';
    final from = _getHeader(msg, 'From') ?? 'Unknown';

    await db.into(db.gmailMessageTable).insertOnConflictUpdate(
          GmailMessageTableCompanion.insert(
            id: msg.id!,
            threadId: msg.threadId!,
            historyId: msg.historyId!,
            subject: subject,
            sender: from,
            recipients: _getHeader(msg, 'To') ?? '',
            messageDate: date,
            labels: (msg.labelIds ?? []).join(','),
            snippet: msg.snippet ?? '',
            internalDate: BigInt.from(internalDate),
            originAccount: authService.currentUser?.email ?? 'unknown',
            rawMetadata: Value(msg.toJson().toString()),
          ),
        );
  }

  String? _getHeader(gmail.Message msg, String name) {
    final headers = msg.payload?.headers;
    if (headers == null) return null;
    try {
      return headers.firstWhere((h) => h.name?.toLowerCase() == name.toLowerCase()).value;
    } catch (_) {
      return null;
    }
  }

  void _updateProgress(int count, bool hasMore) {
    _progressController.add(SyncProgress(
      percentage: hasMore ? 0.5 : 0.9, // Simplified estimation
      currentStage: 'Scanning',
      status: 'Discovered $count potential financial emails...',
    ));
  }

  Future<void> _saveCheckpoint(String? pageToken) async {
    if (pageToken == null) return;
    // Save to ProviderSyncMetadataTable for KnightOS-wide sync tracking
    await db.into(db.providerSyncMetadataTable).insertOnConflictUpdate(
          ProviderSyncMetadataTableCompanion.insert(
            id: 'finance_historical_scan_cursor',
            providerId: 'gmail',
            stateKey: 'finance_historical_scan_cursor',
            stateValue: pageToken,
            lastUpdated: Value(DateTime.now()),
          ),
        );
  }
}
