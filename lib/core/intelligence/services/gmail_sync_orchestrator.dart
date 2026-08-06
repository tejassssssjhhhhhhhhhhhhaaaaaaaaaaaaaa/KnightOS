import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:collection/collection.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
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
      final headers = await authService.getAuthHeaders();
      final client = _AuthenticatedClient(headers, http.Client());
      final gmailApi = gmail.GmailApi(client);

      final lastHistoryId = await getCursor('last_history_id');
      final batchId = 'batch-${DateTime.now().millisecondsSinceEpoch}';

      if (lastHistoryId == null) {
        // Fallback to phased if no historyId
        final currentPhase = int.tryParse(await getCursor('sync_phase') ?? '1') ?? 1;
        await _runPhasedSync(gmailApi, currentPhase, batchId);
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

  Future<void> syncMonth(int year, int month) async {
    final headers = await authService.getAuthHeaders();
    final client = _AuthenticatedClient(headers, http.Client());
    final api = gmail.GmailApi(client);
    final batchId = 'historical-$year-$month';

    final end = DateTime(year, month + 1, 1).subtract(const Duration(seconds: 1));
    
    // P0: Deep target financial transaction alerts to ensure Dashboard populates first
    final query = 'after:${year}/${month.toString().padLeft(2, '0')}/01 '
                  'before:${end.year}/${end.month.toString().padLeft(2, '0')}/${end.day.toString().padLeft(2, '0')} '
                  '("credited" OR "debited" OR "spent" OR "transaction alert" OR "statement" OR "invoice" OR "order confirmation")';

    KnightLogger.info('[GMAIL] Syncing Month: $year-$month Query: $query');

    String? pageToken;
    do {
      final listResponse = await api.users.messages.list('me', q: query, pageToken: pageToken, maxResults: 100);
      final messages = listResponse.messages ?? [];

      if (messages.isNotEmpty) {
        await _processMessageBatch(api, messages, batchId);
      }

      pageToken = listResponse.nextPageToken;
    } while (pageToken != null);
  }

  Future<void> anchorToPresent() async {
    final headers = await authService.getAuthHeaders();
    final client = _AuthenticatedClient(headers, http.Client());
    final api = gmail.GmailApi(client);
    
    final profile = await api.users.getProfile('me');
    if (profile.historyId != null) {
      await updateCursor('last_history_id', profile.historyId!);
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

    for (final partial in partialMessages) {
      if (partial.id == null) continue;

      // Yield to event loop to keep UI responsive
      await Future.delayed(Duration.zero);

      final existing = await db.gmailMessageDao.getByMessageId(partial.id!);
      if (existing != null) {
        duplicates++;
        continue;
      }

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

      indexed++;

      await db.syncTaskDao.into(db.syncTaskQueueTable).insert(SyncTaskQueueTableCompanion.insert(
        id: 'classify-${message.id}',
        providerId: providerId,
        taskType: 'classify_email',
        payload: jsonEncode({'messageId': message.id, 'batchId': batchId}),
        priority: const Value(3),
        updatedAt: Value(DateTime.now()),
      ), mode: InsertMode.insertOrIgnore);
    }

    return _BatchResult(indexed: indexed, duplicates: duplicates);
  }

  Future<void> repairDuplicates() async {
    KnightLogger.info('[GMAIL] Running self-healing: Duplicate Journal Elimination');
    final allMessages = await db.select(db.gmailMessageTable).get();
    final grouped = groupBy(allMessages, (m) => m.id);
    
    for (final entry in grouped.entries) {
      if (entry.value.length > 1) {
        final toDelete = entry.value.skip(1);
        for (final d in toDelete) {
          await (db.delete(db.gmailMessageTable)..where((t) => t.id.equals(d.id))).go();
        }
      }
    }

    final journal = await db.select(db.financeSyncJournalTable).get();
    final journalGrouped = groupBy(journal, (j) => j.messageId);
    for (final entry in journalGrouped.entries) {
      if (entry.value.length > 1) {
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

class _AuthenticatedClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner;

  _AuthenticatedClient(this._headers, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
