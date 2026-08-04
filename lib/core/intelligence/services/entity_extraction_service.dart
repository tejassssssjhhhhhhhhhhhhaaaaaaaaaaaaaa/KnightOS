import 'dart:convert';
import 'package:drift/drift.dart';
import '../../internal/storage/drift/knight_database.dart';
import '../engines/parsers/entity_extractor.dart';
import '../engines/parsers/financial_extractor.dart';
import '../engines/parsers/travel_extractor.dart';
import '../engines/parsers/order_extractor.dart';
import '../engines/workspace_extraction_engine.dart';
import 'identity_resolution_service.dart';
import 'data_ingestion_service.dart';
import '../../internal/utils/knight_logger.dart';

class EntityExtractionService {
  EntityExtractionService({
    required this.db,
    required this.identityService,
    required this.workspaceEngine,
    required this.ingestionService,
  });

  final KnightDatabase db;
  final IdentityResolutionService identityService;
  final WorkspaceExtractionEngine workspaceEngine;
  final DataIngestionService ingestionService;

  final List<EntityExtractor> _extractors = [
    FinancialExtractor(),
    TravelExtractor(),
    OrderExtractor(),
  ];

  Future<void> extractEntitiesFromEmail(String messageId, String batchId) async {
    final message = await db.gmailMessageDao.getByMessageId(messageId);
    final classification = await db.emailClassificationDao.getByMessageId(messageId);

    if (message == null || classification == null) {
      KnightLogger.warn('[EXTRACT] Pre-requisites missing for $messageId');
      return;
    }

    final rawMeta = jsonDecode(message.rawMetadata ?? '{}') as Map<String, dynamic>;
    final category = classification.category;

    final List<ExtractionResult> allResults = [];

    for (final extractor in _extractors) {
      if (extractor.canHandle(category)) {
        KnightLogger.info('[EXTRACT] Using extractor: ${extractor.name} for category: $category', category: KnightLogCategory.intelligence);
        final results = await extractor.extract(message.subject, message.snippet, rawMeta);
        allResults.addAll(results);
      }
    }

    if (allResults.isEmpty) {
      KnightLogger.info('[EXTRACT] No entities extracted from: ${message.subject} (Category: $category)', category: KnightLogCategory.intelligence);
      return;
    }

    await db.transaction(() async {
      for (final res in allResults) {
        // 1. Resolve Canonical Identity
        String? merchant = res.searchTokens['merchant'] ?? res.searchTokens['airline'] ?? res.searchTokens['bank'];
        String? canonicalId;
        if (merchant != null) {
          canonicalId = await identityService.resolve(merchant, res.subtype);
        }

        // 2. Create Entity
        final entityId = 'ent-${DateTime.now().microsecondsSinceEpoch}';
        await db.extractedEntityDao.upsertEntity(ExtractedEntityTableCompanion.insert(
          id: entityId,
          entityType: res.type,
          entitySubtype: res.subtype,
          canonicalId: Value(canonicalId),
          title: res.title,
          summary: Value(res.summary),
          eventTimestamp: res.timestamp,
          receivedTimestamp: message.messageDate,
          parserName: res.extractorName,
          parserVersion: res.extractorVersion,
          confidenceScore: Value(res.confidence),
          confidenceReason: Value(res.reason),
          syncBatchId: Value(batchId),
          extractionTimestamp: Value(DateTime.now()),
        ));

        // 3. Store Evidence
        await db.into(db.entityEvidenceTable).insert(EntityEvidenceTableCompanion.insert(
          id: 'ev-$entityId',
          entityId: entityId,
          originMessageId: Value(messageId),
          originThreadId: Value(message.threadId),
          originAccountId: Value(message.originAccount),
          subject: Value(message.subject),
          snippet: Value(message.snippet),
          matchedRule: Value(res.evidence.matchedRule),
          matchedPattern: Value(res.evidence.matchedPattern),
        ));

        // 4. Update Search Index
        for (final entry in res.searchTokens.entries) {
          await db.into(db.entitySearchIndexTable).insert(EntitySearchIndexTableCompanion.insert(
            id: 'idx-$entityId-${entry.key}',
            entityId: entityId,
            searchToken: entry.value,
            tokenType: entry.key,
          ));
        }
      }
    });

    // 5. Create Workspace Memory for Reasoning
    final workspaceMemory = workspaceEngine.extractEmail({
      'id': message.id,
      'threadId': message.threadId,
      'subject': message.subject,
      'sender': message.sender,
      'snippet': message.snippet,
      'date': message.messageDate,
      'labels': jsonDecode(message.labels),
    }, accountEmail: message.originAccount);

    await ingestionService.ingestWorkspaceMemories([workspaceMemory]);

    KnightLogger.info('[EXTRACT] Extracted ${allResults.length} entities and workspace memory from: ${message.subject}');
  }
}
