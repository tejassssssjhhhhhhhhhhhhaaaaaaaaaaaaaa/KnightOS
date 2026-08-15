import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:collection/collection.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import '../domain/historical_sync_models.dart';
import 'sync_orchestrator.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../../internal/utils/knight_logger.dart';
import '../../services/google_auth_service.dart';

class _BatchResult {
  final int indexed;
  final int duplicates;
  _BatchResult({required this.indexed, required this.duplicates});
}

class GmailSyncOrchestrator extends SyncOrchestrator {
  GmailSyncOrchestrator({
    required super.db,
    required this.authService,
  }) : super(providerId: 'gmail_api');

  final GoogleAuthService authService;

  @override
  Future<void> executeSync() async {
    final stopwatch = Stopwatch()..start();
    final startTime = DateTime.now();
    await updateCursor('sync_start_time', startTime.toIso8601String());
    await updateCursor('sync_status', 'in_progress');

    try {
      final client = await authService.getAuthenticatedClient();
      final gmailApi = gmail.GmailApi(client);

      final lastHistoryId = await getCursor('last_history_id');
      final batchId = 'batch-${DateTime.now().millisecondsSinceEpoch}';

      if (lastHistoryId == null) {
        // --- Historical Deep Sync (D1.3.2 Sliced Implementation) ---
        await _runSlicedHistoricalSync(gmailApi, batchId);
      } else {
        // Incremental Sync (Forwards)
        await _runIncrementalSync(gmailApi, lastHistoryId, batchId);
      }

      final endTime = DateTime.now();
      final duration = stopwatch.elapsed;
      await updateCursor('sync_end_time', endTime.toIso8601String());
      await updateCursor('last_successful_sync', endTime.toIso8601String());
      await updateCursor('sync_duration_ms', duration.inMilliseconds.toString());
      await updateCursor('sync_status', 'idle');
      
      KnightLogger.info('[GMAIL] Sync cycle completed in ${duration.inSeconds}s');
    } catch (e) {
      await updateCursor('sync_status', 'failed');
      await updateCursor('last_sync_error', e.toString());
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// New sliced historical ingestion logic (D1.3.2).
  /// Replaces the legacy nested loop with a resumable temporal crawl.
  Future<void> _runSlicedHistoricalSync(gmail.GmailApi api, String batchId) async {
    HistoricalSyncState state = await getHistoricalState();

    // 1. Discovery / Initialization
    if (state.status == 'pending' || state.rangeStart == null) {
      final now = DateTime.now();
      final start = DateTime(now.year - 5, now.month, now.day);
      await initHistoricalJob(start, now);
      state = await getHistoricalState();
    }

    if (state.isCompleted) {
      KnightLogger.info('[GMAIL] Historical ingestion already completed.');
      await anchorToPresent();
      return;
    }

    KnightLogger.info('[GMAIL] Resuming historical crawl from ${state.nextSliceStart}');

    // 2. Process Slices (30-day windows)
    const sliceWindow = Duration(days: 30);
    
    while (!state.isCompleted) {
       final sliceStart = state.nextSliceStart!;
       final sliceEnd = state.calculateNextSliceEnd(sliceWindow)!;
       
       try {
         await _fetchAndProcessSlice(api, sliceStart, sliceEnd, batchId);
         
         // 3. Persistent Checkpoint
         await completeHistoricalSlice(sliceEnd);
         
         // Update local state for loop condition
         state = await getHistoricalState();
       } catch (e) {
         await recordHistoricalFailure(e.toString());
         rethrow;
       }

       // Yield to allow background worker to check for cancellation or handle other tasks
       await Future.delayed(const Duration(milliseconds: 100));
    }
    
    await anchorToPresent();
  }

  /// Fetches all messages within a specific temporal slice using pagination.
  Future<void> _fetchAndProcessSlice(
    gmail.GmailApi api, 
    DateTime start, 
    DateTime end, 
    String batchId
  ) async {
    // Gmail Query: YYYY/MM/DD (Note: Gmail is inclusive 'after' and exclusive 'before' usually)
    // We use a query that targets financial and general activity to build the life picture.
    final q = 'after:${start.year}/${start.month.toString().padLeft(2, '0')}/${start.day.toString().padLeft(2, '0')} '
              'before:${end.year}/${end.month.toString().padLeft(2, '0')}/${end.day.toString().padLeft(2, '0')} '
              '("credited" OR "debited" OR "spent" OR "transaction alert" OR "statement" OR "invoice" OR "order confirmation")';

    KnightLogger.info('[GMAIL] Fetching Slice: ${start.toIso8601String()} -> ${end.toIso8601String()}');

    String? pageToken;
    do {
      final listResponse = await api.users.messages.list(
        'me', 
        q: q, 
        pageToken: pageToken, 
        maxResults: 100
      );
      
      final messages = listResponse.messages ?? [];
      if (messages.isNotEmpty) {
        await _processMessageBatch(api, messages, batchId);
      }
      
      pageToken = listResponse.nextPageToken;
    } while (pageToken != null);
  }

  Future<void> anchorToPresent() async {
    final client = await authService.getAuthenticatedClient();
    final api = gmail.GmailApi(client);
    
    try {
      final profile = await api.users.getProfile('me');
      if (profile.historyId != null) {
        await updateCursor('last_history_id', profile.historyId!);
      }
      if (profile.messagesTotal != null) {
        await updateCursor('total_messages_on_google', profile.messagesTotal!.toString());
        KnightLogger.info('[GMAIL] Authoritative total on Google: ${profile.messagesTotal}');
      }
    } catch (e) {
      KnightLogger.error('[GMAIL] Failed to anchor to present', error: e);
    }
  }

  Future<void> _runPhasedSync(gmail.GmailApi api, int phase, String batchId) async {
    String query = '';
    switch (phase) {
      case 1: query = 'newer_than:30d'; break;
      case 2: query = 'newer_than:365d'; break;
      case 3: query = ''; break; // Entire mailbox
    }

    KnightLogger.info('[GMAIL] Running Sync Phase $phase ($query)');
    
    String? pageToken;
    int itemsIndexedInCycle = 0;
    int duplicatesPreventedInCycle = 0;

    do {
      final listResponse = await api.users.messages.list('me', q: query, pageToken: pageToken, maxResults: 100);
      final messages = listResponse.messages ?? [];

      if (messages.isNotEmpty) {
        final results = await _processMessageBatch(api, messages, batchId);
        itemsIndexedInCycle += results.indexed;
        duplicatesPreventedInCycle += results.duplicates;
      }

      pageToken = listResponse.nextPageToken;
      
      await _incrementCursor('total_emails_indexed', itemsIndexedInCycle);
      await _incrementCursor('total_duplicates_prevented', duplicatesPreventedInCycle);

      if (itemsIndexedInCycle >= 1000 && phase < 3) break; 
      
    } while (pageToken != null);

    if (pageToken == null) {
      if (phase < 3) {
        await updateCursor('sync_phase', (phase + 1).toString());
      }
    }

    final profile = await api.users.getProfile('me');
    if (profile.historyId != null) {
      await updateCursor('last_history_id', profile.historyId!);
    }
  }

  Future<void> _runIncrementalSync(gmail.GmailApi api, String startId, String batchId) async {
    KnightLogger.info('[GMAIL] Incremental sync since historyId: $startId');
    try {
      final historyResponse = await api.users.history.list('me', startHistoryId: startId);
      final historyItems = historyResponse.history ?? [];
      
      final Set<String> messageIds = {};
      for (final h in historyItems) {
        for (final m in h.messagesAdded ?? []) {
          if (m.message?.id != null) messageIds.add(m.message!.id!);
        }
      }

      if (messageIds.isNotEmpty) {
        final messages = messageIds.map((id) => gmail.Message()..id = id).toList();
        await _processMessageBatch(api, messages, batchId);
      }

      if (historyResponse.historyId != null) {
        await updateCursor('last_history_id', historyResponse.historyId!);
      }
    } catch (e) {
      KnightLogger.warn('[GMAIL] Incremental sync failed, falling back to Phase 1: $e');
      await _runPhasedSync(api, 1, batchId); 
    }
  }

  Future<_BatchResult> _processMessageBatch(gmail.GmailApi api, List<gmail.Message> partialMessages, String batchId) async {
    final accountEmail = authService.currentUser?.email ?? 'unknown';
    int indexed = 0;
    int duplicates = 0;

    fetchedCount += partialMessages.length;

    for (final partial in partialMessages) {
      if (partial.id == null) continue;

      // Yield to event loop to keep UI responsive
      await Future.delayed(Duration.zero);

      final existing = await db.gmailMessageDao.getByMessageId(partial.id!);
      if (existing != null) {
        duplicates++;
        skippedCount++;
        continue;
      }

      try {
        final message = await api.users.messages.get('me', partial.id!);
        
        KnightLogger.info('[GMAIL] Processing message: ${message.id} Subject: ${_getHeader(message.payload?.headers, 'Subject')}');

        await db.gmailMessageDao.upsertMessage(GmailMessageTableCompanion.insert(
          id: message.id!,
          threadId: message.threadId!,
          historyId: message.historyId!,
          subject: _getHeader(message.payload?.headers, 'Subject'),
          sender: _getHeader(message.payload?.headers, 'From'),
          recipients: _getHeader(message.payload?.headers, 'To'),
          messageDate: DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.internalDate ?? '0') ?? 0),
          labels: jsonEncode(message.labelIds ?? []),
          snippet: message.snippet ?? '',
          internalDate: BigInt.from(int.tryParse(message.internalDate ?? '0') ?? 0),
          originAccount: accountEmail,
          rawMetadata: Value(jsonEncode(message.toJson())),
          syncStatus: const Value('synced'),
        ));
        
        KnightLogger.info('[GMAIL] Successfully saved message to DB: ${message.id}');

        // P0: Create Journal Entry for Finance Audit Engine
        await db.into(db.financeSyncJournalTable).insert(
          FinanceSyncJournalTableCompanion.insert(
            id: message.id!,
            messageId: message.id!,
            parserVersion: '1.0.0',
            processingResult: 'Discovered',
            processedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );

        createdCount++;
        indexed++;

        await db.syncTaskDao.into(db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
          id: 'classify-${message.id}',
          providerId: providerId,
          taskType: 'classify_email',
          payload: jsonEncode({'messageId': message.id, 'batchId': batchId}),
          priority: const Value(3),
          updatedAt: Value(DateTime.now()),
        ), mode: InsertMode.insertOrIgnore);
      } catch (e) {
        KnightLogger.error('[GMAIL] Failed to process message ${partial.id}', error: e);
        failedCount++;
      }
    }

    return _BatchResult(indexed: indexed, duplicates: duplicates);
  }

  Future<void> repairDuplicates() async {
    KnightLogger.info('[GMAIL] Running self-healing: Duplicate Journal Elimination');
    final allMessages = await db.select(db.gmailMessageTable).get();
    final grouped = groupBy(allMessages, (m) => m.id);
    
    for (final entry in grouped.entries) {
      if (entry.value.isNotEmpty && entry.value.length > 1) {
        final toDelete = entry.value.skip(1);
        for (final d in toDelete) {
          await (db.delete(db.gmailMessageTable)..where((t) => t.id.equals(d.id))).go();
        }
      }
    }

    final journal = await db.select(db.financeSyncJournalTable).get();
    final journalGrouped = groupBy(journal, (j) => j.messageId);
    for (final entry in journalGrouped.entries) {
      if (entry.value.isNotEmpty && entry.value.length > 1) {
        final toDelete = entry.value.skip(1);
        for (final d in toDelete) {
          await (db.delete(db.financeSyncJournalTable)..where((t) => t.id.equals(d.id))).go();
        }
      }
    }
  }

  Future<void> _incrementCursor(String key, int amount) async {
    final currentStr = await getCursor(key);
    final current = int.tryParse(currentStr ?? '0') ?? 0;
    await updateCursor(key, (current + amount).toString());
  }

  String _getHeader(dynamic headers, String name) {
    if (headers == null) return '';
    final header = (headers as List).firstWhereOrNull((h) => h.name == name);
    return header?.value ?? '';
  }
}
