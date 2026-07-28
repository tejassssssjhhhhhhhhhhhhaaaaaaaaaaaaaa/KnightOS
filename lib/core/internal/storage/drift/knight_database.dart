import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/migration_ledger.dart';
import 'tables/user_profiles.dart';
import 'tables/memories.dart';
import 'tables/memory_relations.dart';
import 'tables/evidence.dart';
import 'tables/attachments.dart';
import 'tables/audit_logs.dart';
import 'tables/sync_queue.dart';
import 'tables/question_statuses.dart';

import 'daos/user_profile_dao.dart';
import 'daos/memory_dao.dart';
import 'daos/evidence_dao.dart';
import 'base_dao.dart';
import 'utils/type_converters.dart';

export 'daos/user_profile_dao.dart';
export 'daos/memory_dao.dart';
export 'daos/evidence_dao.dart';

part 'knight_database.g.dart';

@DriftAccessor(tables: [MigrationLedger])
class MigrationDao extends BaseDao<MigrationLedger, MigrationLedgerData>
    with _$MigrationDaoMixin {
  MigrationDao(super.db);

  Future<MigrationLedgerData?> getByModule(String module) {
    return (select(
      migrationLedger,
    )..where((t) => t.module.equals(module))).getSingleOrNull();
  }
}

@DriftDatabase(
  tables: [
    MigrationLedger,
    UserProfileTable,
    MemoryTable,
    MemoryRelationTable,
    EvidenceTable,
    AttachmentTable,
    AuditLogTable,
    SyncQueueTable,
    QuestionStatusTable,
  ],
  daos: [MigrationDao, UserProfileDao, MemoryDao, EvidenceDao],
)
class KnightDatabase extends _$KnightDatabase {
  KnightDatabase() : super(_openConnection());
  KnightDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      debugPrint('KnightDatabase: Creating tables...');
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      debugPrint('KnightDatabase: Upgrading from $from to $to');
      if (from < 2) {
        debugPrint(
          'KnightDatabase: Performing v1 -> v2 migration (recreate tables)',
        );
        await m.deleteTable('memories');
        await m.deleteTable('memory_relations');
        await m.createTable(memoryTable);
        await m.createTable(memoryRelationTable);
        await m.createTable(evidenceTable);
        await m.createTable(attachmentTable);
        await m.createTable(auditLogTable);
        await m.createTable(syncQueueTable);
        await m.createTable(questionStatusTable);
      }
      if (from < 3) {
        debugPrint(
          'KnightDatabase: Performing v2 -> v3 migration (add columns)',
        );
        // Fix: Check if table was already created in v2 recreation block
        if (from == 2) {
          await m.addColumn(memoryTable, memoryTable.updatedAt);
          await m.addColumn(memoryTable, memoryTable.lastVerifiedAt);
          await m.addColumn(memoryTable, memoryTable.verificationHistory);
        }
      }
      if (from < 4) {
        debugPrint(
          'KnightDatabase: Performing v3 -> v4 migration (add indexes)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS memory_id_idx ON memories (memory_id);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS memory_latest_idx ON memories (memory_id, is_latest);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS category_idx ON memories (category_id);',
        );
      }
      debugPrint('KnightDatabase: Migration complete');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'knight_os_v2.sqlite'));
    return NativeDatabase(file);
  });
}
