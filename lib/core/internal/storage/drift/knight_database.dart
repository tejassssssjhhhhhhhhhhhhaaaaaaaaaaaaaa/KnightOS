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
import 'tables/work_sessions.dart';
import 'tables/import_history.dart';
import 'tables/financial_accounts.dart';
import 'tables/transactions.dart';
import 'tables/health_metrics.dart';
import 'tables/timeline_events.dart';
import 'tables/missions.dart';
import 'tables/goals.dart';
import 'tables/tasks.dart';
import 'tables/graph_nodes.dart';
import 'tables/graph_edges.dart';
import 'tables/workout_sessions.dart';
import 'tables/sleep_sessions.dart';
import 'tables/provider_sync_metadata.dart';
import 'tables/sync_task_queue.dart';
import 'tables/reminders.dart';
import 'tables/device_registry.dart';
import 'tables/parser_registry.dart';
import 'tables/security_metadata.dart';
import 'tables/gmail_messages.dart';
import 'tables/email_classifications.dart';
import 'tables/extracted_entities.dart';
import 'tables/entity_evidence.dart';
import 'tables/canonical_identities.dart';
import 'tables/entity_search_index.dart';
import 'tables/entity_history.dart';
import 'tables/extraction_analytics.dart';
import 'tables/extraction_previews.dart';
import 'tables/data_privacy_metadata.dart';
import 'tables/runtime_events.dart';
import 'tables/system_snapshots.dart';
import 'tables/provenance.dart';
import 'tables/trust_metrics.dart';
import 'tables/graph_history.dart';
import 'tables/data_governance.dart';
import 'tables/context_history.dart';
import 'tables/device_health.dart';
import 'tables/travel_foundation.dart';
import 'tables/nutrition.dart';
import 'tables/medications.dart';
import 'tables/body_measurements.dart';
import 'tables/health_trackers.dart';
import 'tables/workout_foundation.dart';
import 'tables/finance_sync_journal.dart';
import 'tables/finance_institution_metadata.dart';
import 'tables/finance_inbox_tasks.dart';
import 'tables/finance_extractions.dart';
import 'tables/finance_sync_history.dart';
import 'tables/finance_budgets.dart';
import 'tables/finance_goals.dart';
import 'tables/finance_reports.dart';

import 'daos/user_profile_dao.dart';
import 'daos/memory_dao.dart';
import 'daos/evidence_dao.dart';
import 'daos/import_dao.dart';
import 'daos/financial_dao.dart';
import 'daos/health_dao.dart';
import 'daos/timeline_dao.dart';
import 'daos/mission_dao.dart';
import 'daos/knowledge_graph_dao.dart';
import 'daos/work_tracker_dao.dart';
import 'daos/sync_metadata_dao.dart';
import 'daos/sync_task_dao.dart';
import 'daos/reminder_dao.dart';
import 'daos/device_dao.dart';
import 'daos/security_dao.dart';
import 'daos/gmail_message_dao.dart';
import 'daos/email_classification_dao.dart';
import 'daos/extracted_entity_dao.dart';
import 'daos/canonical_identity_dao.dart';
import 'daos/extraction_analytics_dao.dart';
import 'daos/privacy_dao.dart';
import 'daos/runtime_recorder_dao.dart';
import 'daos/snapshot_dao.dart';
import 'daos/travel_dao.dart';
import 'daos/nutrition_dao.dart';
import 'daos/medication_dao.dart';
import 'daos/health_tracker_dao.dart';
import 'daos/workout_foundation_dao.dart';
import 'daos/finance_platform_dao.dart';
import 'base_dao.dart';
import 'utils/type_converters.dart';

export 'daos/user_profile_dao.dart';
export 'daos/memory_dao.dart';
export 'daos/evidence_dao.dart';
export 'daos/import_dao.dart';
export 'daos/financial_dao.dart';
export 'daos/health_dao.dart';
export 'daos/timeline_dao.dart';
export 'daos/mission_dao.dart';
export 'daos/knowledge_graph_dao.dart';
export 'daos/work_tracker_dao.dart';
export 'daos/sync_metadata_dao.dart';
export 'daos/sync_task_dao.dart';
export 'daos/reminder_dao.dart';
export 'daos/device_dao.dart';
export 'daos/security_dao.dart';
export 'daos/gmail_message_dao.dart';
export 'daos/email_classification_dao.dart';
export 'daos/extracted_entity_dao.dart';
export 'daos/canonical_identity_dao.dart';
export 'daos/extraction_analytics_dao.dart';
export 'daos/privacy_dao.dart';
export 'daos/runtime_recorder_dao.dart';
export 'daos/snapshot_dao.dart';
export 'daos/travel_dao.dart';
export 'daos/finance_platform_dao.dart';
export 'base_dao.dart';

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
    WorkSessionTable,
    ImportHistoryTable,
    FinancialAccountTable,
    TransactionTable,
    HealthMetricTable,
    TimelineEventTable,
    MissionTable,
    GoalTable,
    TaskTable,
    GraphNodeTable,
    GraphEdgeTable,
    WorkoutSessionTable,
    SleepSessionTable,
    ProviderSyncMetadataTable,
    SyncTaskQueueTable,
    ReminderTable,
    DeviceRegistryTable,
    ParserRegistryTable,
    SecurityMetadataTable,
    GmailMessageTable,
    EmailClassificationTable,
    ExtractedEntityTable,
    EntityEvidenceTable,
    CanonicalIdentityTable,
    IdentityAliasTable,
    EntitySearchIndexTable,
    EntityHistoryTable,
    ExtractionAnalyticsTable,
    ExtractionPreviewTable,
    DataPrivacyMetadataTable,
    RuntimeEventsTable,
    SystemSnapshotsTable,
    ProvenanceTable,
    TrustMetricsTable,
    GraphHistoryTable,
    DataGovernanceTable,
    ContextHistoryTable,
    ContextSnapshotsTable,
    DeviceHealthTable,
    TripTable,
    TravelBookingTable,
    TravelEvidenceVaultTable,
    TravelMetricsTable,
    TravelGeographicEnrichmentTable,
    NutritionFoodTable,
    NutritionMealTable,
    MedicationTable,
    MedicationLogTable,
    BodyMeasurementTable,
    HealthTrackerTable,
    ExerciseLibraryTable,
    EquipmentProfileTable,
    FinanceSyncJournalTable,
    FinanceInstitutionMetadataTable,
    FinanceInboxTaskTable,
    FinanceExtractionTable,
    FinanceSyncHistoryTable,
    FinanceBudgetTable,
    FinanceGoalTable,
    FinanceReportTable,
  ],
  daos: [
    MigrationDao,
    UserProfileDao,
    MemoryDao,
    EvidenceDao,
    ImportDao,
    FinancialDao,
    HealthDao,
    TimelineDao,
    MissionDao,
    KnowledgeGraphDao,
    WorkTrackerDao,
    SyncMetadataDao,
    SyncTaskDao,
    ReminderDao,
    DeviceDao,
    SecurityDao,
    GmailMessageDao,
    EmailClassificationDao,
    ExtractedEntityDao,
    CanonicalIdentityDao,
    ExtractionAnalyticsDao,
    PrivacyDao,
    RuntimeRecorderDao,
    SnapshotDao,
    TravelDao,
    NutritionDao,
    MedicationDao,
    HealthTrackerDao,
    WorkoutFoundationDao,
    FinancePlatformDao,
  ],
)
class KnightDatabase extends _$KnightDatabase {
  KnightDatabase() : super(_openConnection());
  KnightDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 26;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      debugPrint('KnightDatabase: Creating tables...');
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      debugPrint('KnightDatabase: Upgrading from $from to $to');
      if (from < 2) {
        debugPrint('KnightDatabase: Performing v1 -> v2 migration');
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
        if (from == 2) {
          await m.addColumn(memoryTable, memoryTable.updatedAt);
          await m.addColumn(memoryTable, memoryTable.lastVerifiedAt);
          await m.addColumn(memoryTable, memoryTable.verificationHistory);
        }
      }
      if (from < 4) {
        await customStatement('CREATE INDEX IF NOT EXISTS memory_id_idx ON memories (memory_id);');
      }
      if (from < 5) {
        await m.createTable(importHistoryTable);
        await m.createTable(financialAccountTable);
        await m.createTable(transactionTable);
        await m.createTable(healthMetricTable);
        await m.createTable(timelineEventTable);
      }
      if (from < 6) {
        await m.addColumn(memoryTable, memoryTable.sourceProvider);
        await m.addColumn(userProfileTable, userProfileTable.sourceProvider);
        await m.addColumn(importHistoryTable, importHistoryTable.sourceProvider);
        await m.addColumn(financialAccountTable, financialAccountTable.sourceProvider);
        await m.addColumn(transactionTable, transactionTable.sourceProvider);
        await m.addColumn(healthMetricTable, healthMetricTable.sourceProvider);
        await m.addColumn(timelineEventTable, timelineEventTable.sourceProvider);
      }
      if (from < 7) {
        await m.createTable(missionTable);
        await m.createTable(goalTable);
        await m.createTable(taskTable);
      }
      if (from < 8) {
        await m.createTable(graphNodeTable);
        await m.createTable(graphEdgeTable);
      }
      if (from < 9) {
        await m.createTable(workoutSessionTable);
        await m.createTable(sleepSessionTable);
      }
      if (from < 10) {
        await m.createTable(providerSyncMetadataTable);
        await m.createTable(syncTaskQueueTable);
        await m.createTable(reminderTable);
        await m.createTable(deviceRegistryTable);
        await m.createTable(parserRegistryTable);
        await m.createTable(securityMetadataTable);
      }
      if (from < 11) {
        await m.createTable(gmailMessageTable);
        await m.createTable(emailClassificationTable);
      }
      if (from < 12) {
        await m.createTable(extractedEntityTable);
        await m.createTable(entityEvidenceTable);
        await m.createTable(canonicalIdentityTable);
        await m.createTable(identityAliasTable);
        await m.createTable(entitySearchIndexTable);
        await m.createTable(entityHistoryTable);
        await m.createTable(extractionAnalyticsTable);
        await m.createTable(extractionPreviewTable);
        await m.createTable(dataPrivacyMetadataTable);
      }
      if (from < 13) {
        await m.createTable(runtimeEventsTable);
        await m.createTable(systemSnapshotsTable);
      }
      if (from < 14) {
        await m.createTable(provenanceTable);
        await m.createTable(trustMetricsTable);
        await m.createTable(graphHistoryTable);
        await m.createTable(dataGovernanceTable);
      }
      if (from < 15) {
        await m.createTable(contextHistoryTable);
        await m.createTable(contextSnapshotsTable);
        await m.createTable(deviceHealthTable);
        await m.createTable(tripTable);
        await m.createTable(travelBookingTable);
      }
      if (from < 16) {
        await m.createTable(nutritionFoodTable);
        await m.createTable(nutritionMealTable);
        await m.createTable(medicationTable);
        await m.createTable(medicationLogTable);
        await m.createTable(bodyMeasurementTable);
        await m.createTable(healthTrackerTable);
        await m.createTable(exerciseLibraryTable);
        await m.createTable(equipmentProfileTable);
      }
      if (from < 17) {
        await m.createTable(financeSyncJournalTable);
        await m.createTable(financeInstitutionMetadataTable);
        await m.createTable(financeInboxTaskTable);
      }
      if (from < 18) {
        await m.createTable(financeExtractionTable);
        await m.createTable(travelEvidenceVaultTable);
        await m.createTable(travelMetricsTable);
        await m.createTable(travelGeographicEnrichmentTable);
      }
      if (from < 19) {
        await m.createTable(financeSyncHistoryTable);
      }
      if (from < 20) {
        try {
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.resolution);
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.resolvedAt);
        } catch (e) { debugPrint('v20 fail: $e'); }
      }
      if (from < 21) {
        try {
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.description);
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.priority);
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.confidence);
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.institution);
          await m.addColumn(financeInboxTaskTable, financeInboxTaskTable.engineSource);
        } catch (e) { debugPrint('v21 fail: $e'); }
      }
      if (from < 22) {
        await m.createTable(financeBudgetTable);
      }
      if (from < 23) {
        await m.createTable(financeGoalTable);
      }
      if (from < 25) {
        await m.createTable(financeReportTable);
      }
      if (from < 26) {
        debugPrint('KnightDatabase: Performing v25 -> v26 migration (Finance Indexes)');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions (transaction_date);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_cat ON transactions (category);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_merc ON transactions (merchant);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions (type);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_latest ON transactions (is_latest);');
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
