import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../knight_database.dart';
import '../tables/memories.dart';
import '../tables/memory_relations.dart';
import '../tables/attachments.dart';
import '../base_dao.dart';

part 'memory_dao.g.dart';

@DriftAccessor(tables: [MemoryTable, MemoryRelationTable, AttachmentTable])
class MemoryDao extends BaseDao<MemoryTable, MemoryTableData>
    with _$MemoryDaoMixin {
  MemoryDao(super.db);

  /// Retrieves the latest version of a specific memory by its logical ID.
  Future<MemoryTableData?> getLatestByMemoryId(String memoryId) {
    return (select(memoryTable)
          ..where((t) => t.memoryId.equals(memoryId))
          ..where((t) => t.isLatest.equals(true)))
        .getSingleOrNull();
  }

  /// Retrieves all versions of a specific memory chain.
  Future<List<MemoryTableData>> getVersionHistory(String memoryId) {
    return (select(memoryTable)
          ..where((t) => t.memoryId.equals(memoryId))
          ..orderBy([(t) => OrderingTerm.desc(t.version)]))
        .get();
  }

  /// Retrieves current facts for a specific domain.
  Future<List<MemoryTableData>> getLatestByDomain(int domainId) {
    return (select(memoryTable)
          ..where((t) => t.domainId.equals(domainId))
          ..where((t) => t.isLatest.equals(true)))
        .get();
  }

  /// Retrieves current facts for a specific category.
  Future<List<MemoryTableData>> getLatestByCategory(int categoryId) {
    return (select(memoryTable)
          ..where((t) => t.categoryId.equals(categoryId))
          ..where((t) => t.isLatest.equals(true)))
        .get();
  }

  /// Search logic using LIKE on summary, content, and tags.
  Future<List<MemoryTableData>> searchMemories(String query) {
    if (query.isEmpty) {
      return (select(memoryTable)..where((t) => t.isLatest.equals(true))).get();
    }
    final pattern = '%$query%';
    return (select(memoryTable)
          ..where(
            (t) =>
                t.summary.like(pattern) |
                t.content.like(pattern) |
                t.tags.like(pattern),
          )
          ..where((t) => t.isLatest.equals(true)))
        .get();
  }

  /// Specialized upsert that enforces immutability and versioning.
  Future<void> saveWithVersioning(MemoryTableCompanion companion) async {
    await transaction(() async {
      final memId = companion.memoryId.value;

      // 1. Mark previous version as no longer latest
      await (update(memoryTable)..where((t) => t.memoryId.equals(memId))).write(
        const MemoryTableCompanion(isLatest: Value(false)),
      );

      // 2. Insert new version
      await into(memoryTable).insert(
        companion.copyWith(
          id: Value(const Uuid().v4()),
          isLatest: const Value(true),
          recordedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Bulk upsert for improved performance during migrations.
  Future<void> saveBatchWithVersioning(
    List<MemoryTableCompanion> companions,
  ) async {
    await transaction(() async {
      final List<String> memoryIds = companions
          .map((c) => c.memoryId.value)
          .toList();

      // 1. Mark all previous versions in the batch as no longer latest
      await (update(memoryTable)..where((t) => t.memoryId.isIn(memoryIds)))
          .write(const MemoryTableCompanion(isLatest: Value(false)));

      // 2. Insert new versions
      final now = DateTime.now();
      for (final companion in companions) {
        await into(memoryTable).insert(
          companion.copyWith(
            id: Value(const Uuid().v4()),
            isLatest: const Value(true),
            recordedAt: Value(now),
          ),
        );
      }
    });
  }

  /// Links memories in the graph.
  Future<void> link(
    String sourceId,
    String targetId,
    String type, {
    double strength = 1.0,
  }) {
    return into(memoryRelationTable).insert(
      MemoryRelationTableCompanion.insert(
        id: const Uuid().v4(),
        sourceId: sourceId,
        targetId: targetId,
        type: type,
        strength: Value(strength),
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Attachment management.
  Future<void> attach(String memoryId, String caid, {String? fragment}) {
    return into(attachmentTable).insert(
      AttachmentTableCompanion.insert(
        id: const Uuid().v4(),
        memoryId: memoryId,
        caid: caid,
        fragment: Value(fragment),
      ),
    );
  }

  Future<List<AttachmentTableData>> getAttachments(String memoryId) {
    return (select(
      attachmentTable,
    )..where((t) => t.memoryId.equals(memoryId))).get();
  }

  Future<List<AttachmentTableData>> getAttachmentsForMemories(
    List<String> memoryIds,
  ) {
    return (select(
      attachmentTable,
    )..where((t) => t.memoryId.isIn(memoryIds))).get();
  }

  /// Retrieves all memories related to the given ID.
  Future<List<MemoryRelationData>> getRelations(String memoryId) {
    return (select(memoryRelationTable)..where(
          (t) => t.sourceId.equals(memoryId) | t.targetId.equals(memoryId),
        ))
        .get();
  }

  /// Retrieves all edges in the knowledge graph.
  Future<List<MemoryRelationData>> getAllRelations() {
    return select(memoryRelationTable).get();
  }

  // --- Reactive Methods ---

  /// Watches the latest version of a specific memory.
  Stream<MemoryTableData?> watchLatestByMemoryId(String memoryId) {
    return (select(memoryTable)
          ..where((t) => t.memoryId.equals(memoryId))
          ..where((t) => t.isLatest.equals(true)))
        .watchSingleOrNull();
  }

  /// Watches current facts for a specific domain.
  Stream<List<MemoryTableData>> watchLatestByDomain(int domainId) {
    return (select(memoryTable)
          ..where((t) => t.domainId.equals(domainId))
          ..where((t) => t.isLatest.equals(true)))
        .watch();
  }

  /// Watches current facts for a specific category.
  Stream<List<MemoryTableData>> watchLatestByCategory(int categoryId) {
    return (select(memoryTable)
          ..where((t) => t.categoryId.equals(categoryId))
          ..where((t) => t.isLatest.equals(true)))
        .watch();
  }
}
