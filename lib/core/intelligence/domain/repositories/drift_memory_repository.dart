import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import '../knight_memory.dart';
import '../memory_metadata.dart';
import '../memory_version.dart';
import '../memory_domain.dart';
import '../memory_category.dart';
import '../memory_relation.dart';
import '../evidence.dart';
import 'memory_repository.dart';

/// Implementation of [MemoryRepository] using Drift (SQLite) as the engine.
class DriftMemoryRepository implements MemoryRepository {
  DriftMemoryRepository({required MemoryDao memoryDao}) : _dao = memoryDao;

  final MemoryDao _dao;

  @override
  Future<KnightMemory?> getLatest(String memoryId) async {
    final data = await _dao.getLatestByMemoryId(memoryId);
    if (data == null) return null;
    return await _mapToDomain(data);
  }

  @override
  Future<List<KnightMemory>> getByDomain(MemoryDomain domain) async {
    final list = await _dao.getLatestByDomain(domain.id);
    return await _mapList(list);
  }

  @override
  Future<List<KnightMemory>> getByCategory(BookCategory category) async {
    final list = await _dao.getLatestByCategory(category.id);
    return await _mapList(list);
  }

  @override
  Future<List<KnightMemory>> getHistory(String memoryId) async {
    final list = await _dao.getVersionHistory(memoryId);
    return await _mapList(list);
  }

  @override
  Future<void> save(KnightMemory memory) async {
    final companion = _mapToCompanion(memory);
    await _dao.saveWithVersioning(companion);

    // Save attachments (SourceLinks)
    for (final link in memory.sourceLinks) {
      await _dao.attach(
        memory.metadata.memoryId,
        link.caid,
        fragment: link.fragment,
      );
    }
  }

  @override
  Future<void> saveAll(List<KnightMemory> memories) async {
    final companions = memories.map(_mapToCompanion).toList();
    await _dao.saveBatchWithVersioning(companions);

    // Save attachments in bulk if needed
    for (final memory in memories) {
      for (final link in memory.sourceLinks) {
        await _dao.attach(
          memory.metadata.memoryId,
          link.caid,
          fragment: link.fragment,
        );
      }
    }
  }

  @override
  Future<List<KnightMemory>> search(String query, {int? limit}) async {
    final list = await _dao.searchMemories(query, limit: limit);
    return await _mapList(list);
  }

  @override
  Future<List<KnightMemory>> searchByDateRange(DateTime start, DateTime end) async {
    final list = await _dao.getByDateRange(start, end);
    return await _mapList(list);
  }

  @override
  Future<void> delete(String memoryId) async {
    // Soft delete or hard delete based on policy.
  }

  @override
  Future<void> link(
    String sourceId,
    String targetId,
    String type, {
    double strength = 1.0,
  }) => _dao.link(sourceId, targetId, type, strength: strength);

  @override
  Future<List<KnightMemory>> getRelated(String memoryId) async {
    final relations = await _dao.getRelations(memoryId);
    final List<KnightMemory> related = [];

    for (final rel in relations) {
      final otherId = rel.sourceId == memoryId ? rel.targetId : rel.sourceId;
      final memory = await getLatest(otherId);
      if (memory != null) related.add(memory);
    }

    return related;
  }

  @override
  Future<List<MemoryRelation>> getAllRelations() async {
    final list = await _dao.getAllRelations();
    return list.map((d) => MemoryRelation(
      id: d.id,
      sourceId: d.sourceId,
      targetId: d.targetId,
      type: MemoryRelationType.values.byName(d.type),
      strength: d.strength,
      createdAt: d.createdAt,
    )).toList();
  }

  @override
  Stream<KnightMemory?> watchLatest(String memoryId) {
    return _dao.watchLatestByMemoryId(memoryId).asyncMap((data) async {
      if (data == null) return null;
      return await _mapToDomain(data);
    });
  }

  @override
  Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain) {
    return _dao.watchLatestByDomain(domain.id).asyncMap(_mapList);
  }

  @override
  Stream<List<KnightMemory>> watchByCategory(BookCategory category) {
    return _dao.watchLatestByCategory(category.id).asyncMap(_mapList);
  }

  // --- Mapping Helpers ---

  Future<List<KnightMemory>> _mapList(List<MemoryTableData> list) async {
    if (list.isEmpty) return [];

    final versionIds = list.map((e) => e.id).toList();
    final memoryIds = list.map((e) => e.memoryId).toList();

    // Batch fetch attachments and relations to avoid N+1 query problem
    final allAttachments = await _dao.getAttachmentsForMemories(memoryIds);
    final allRelations = await _dao.getRelationsForMemories(memoryIds);

    final Map<String, List<AttachmentTableData>> attachmentMap = {};
    for (final a in allAttachments) {
      // In _mapToDomain it uses data.id (versionId), but getAttachments takes memoryId?
      // Wait, let's check getAttachments in MemoryDao.
      // Future<List<AttachmentTableData>> getAttachments(String memoryId) {
      //   return (select(attachmentTable)..where((t) => t.memoryId.equals(memoryId))).get();
      // }
      // It seems it takes memoryId.
      attachmentMap.putIfAbsent(a.memoryId, () => []).add(a);
    }

    final Map<String, List<MemoryRelationData>> relationMap = {};
    for (final r in allRelations) {
      relationMap.putIfAbsent(r.sourceId, () => []).add(r);
      relationMap.putIfAbsent(r.targetId, () => []).add(r);
    }

    return list.map((data) => _mapToDomainSync(data, attachmentMap[data.memoryId] ?? [], relationMap[data.memoryId] ?? [])).toList();
  }

  Future<KnightMemory> _mapToDomain(MemoryTableData data) async {
    final attachments = await _dao.getAttachments(data.memoryId);
    final relations = await _dao.getRelations(data.memoryId);
    return _mapToDomainSync(data, attachments, relations);
  }

  KnightMemory _mapToDomainSync(MemoryTableData data, List<AttachmentTableData> attachments, List<MemoryRelationData> relations) {
    return KnightMemory(
      metadata: MemoryMetadata(
        memoryId: data.memoryId,
        versionId: data.id,
        effectiveAt: data.effectiveAt,
        recordedAt: data.recordedAt,
        updatedAt: data.updatedAt,
        confidence: data.confidence,
        source: MemorySource.values.byName(data.source),
        provenance: data.provenance,
        domain: MemoryDomain.fromId(data.domainId),
        category: BookCategory.fromId(data.categoryId),
        isLatest: data.isLatest,
        verified: data.verified,
        lastVerifiedAt: data.lastVerifiedAt,
        verificationHistory: (data.verificationHistory != null && data.verificationHistory!.isNotEmpty)
            ? (jsonDecode(data.verificationHistory!) as List<dynamic>)
                  .cast<Map<String, dynamic>>()
            : const [],
        questionId: data.questionId,
        tags: data.tags.isEmpty ? [] : data.tags.split(','),
        knowledgeState: KnowledgeState.values.byName(data.knowledgeState),
        explanation: data.explanation,
        embedding: (data.embedding != null && data.embedding!.isNotEmpty)
            ? (jsonDecode(data.embedding!) as List<dynamic>).cast<double>()
            : null,
      ),
      version: MemoryVersion(
        versionNumber: data.version,
        previousVersionId: data.prevVersionId,
        changeType: ChangeType.values.byName(data.changeType),
        reasoning: data.reasoning,
        delta: (data.delta != null && data.delta!.isNotEmpty) ? jsonDecode(data.delta!) : {},
      ),
      content: jsonDecode(data.content),
      summary: data.summary,
      importance: data.importance,
      sourceLinks: attachments
          .map((a) => SourceLink(caid: a.caid, fragment: a.fragment))
          .toList(),
      relationships: relations.map((rel) => MemoryRelation(
        id: rel.id,
        sourceId: rel.sourceId,
        targetId: rel.targetId,
        type: MemoryRelationType.values.byName(rel.type),
        strength: rel.strength,
        createdAt: rel.createdAt,
      )).toList(),
    );
  }

  MemoryTableCompanion _mapToCompanion(KnightMemory memory) {
    return MemoryTableCompanion(
      memoryId: Value(memory.metadata.memoryId),
      categoryId: Value(memory.metadata.category.id),
      domainId: Value(memory.metadata.domain.id),
      type: Value(
        memory.metadata.effectiveAt == memory.metadata.recordedAt
            ? 'event'
            : 'identity',
      ),
      content: Value(jsonEncode(memory.content)),
      summary: Value(memory.summary),
      importance: Value(memory.importance),
      confidence: Value(memory.metadata.confidence),
      source: Value(memory.metadata.source.name),
      provenance: Value(memory.metadata.provenance),
      version: Value(memory.version.versionNumber),
      prevVersionId: Value(memory.version.previousVersionId),
      verified: Value(memory.metadata.verified),
      questionId: Value(memory.metadata.questionId),
      knowledgeState: Value(memory.metadata.knowledgeState.name),
      explanation: Value(memory.metadata.explanation),
      tags: Value(memory.metadata.tags.join(',')),
      embedding: Value(
        memory.metadata.embedding != null
            ? jsonEncode(memory.metadata.embedding)
            : null,
      ),
      effectiveAt: Value(memory.metadata.effectiveAt),
      updatedAt: Value(memory.metadata.updatedAt),
      lastVerifiedAt: Value(memory.metadata.lastVerifiedAt),
      verificationHistory: Value(
        memory.metadata.verificationHistory.isNotEmpty
            ? jsonEncode(memory.metadata.verificationHistory)
            : null,
      ),
      changeType: Value(memory.version.changeType.name),
      reasoning: Value(memory.version.reasoning),
      delta: Value(jsonEncode(memory.version.delta)),
    );
  }
}
