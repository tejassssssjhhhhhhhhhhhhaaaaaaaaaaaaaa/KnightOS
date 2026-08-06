import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../auth/gmail_connection_manager.dart';
import '../engine/finance_health_center.dart';
import '../engine/gmail_audit_engine.dart';
import '../engine/finance_evidence_vault.dart';
import '../engine/finance_parser_engine.dart';
import '../engine/repair_engine.dart';
import '../sync/smart_sync_engine.dart';
import '../sync/finance_inbox_service.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../../../core/services/google_auth_service.dart';

final financePlatformDaoProvider = Provider<FinancePlatformDao>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return FinancePlatformDao(db);
});

final gmailConnectionManagerProvider = Provider<GmailConnectionManager>((ref) {
  return GmailConnectionManager();
});

final financeHealthCenterProvider = Provider<FinanceHealthCenter>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  final connectionManager = ref.watch(gmailConnectionManagerProvider);
  return FinanceHealthCenter(db: db, connectionManager: connectionManager, dao: dao);
});

final gmailAuditEngineProvider = Provider<GmailAuditEngine>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  return GmailAuditEngine(db: db);
});

final financeParserEngineProvider = Provider<FinanceParserEngine>((ref) {
  return FinanceParserEngine();
});

final financeEvidenceVaultProvider = Provider<FinanceEvidenceVault>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  final parserEngine = ref.watch(financeParserEngineProvider);
  return FinanceEvidenceVault(db: db, parserEngine: parserEngine, dao: dao);
});

final repairEngineProvider = Provider<RepairEngine>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  final vault = ref.watch(financeEvidenceVaultProvider);
  return RepairEngine(db: db, dao: dao, vault: vault);
});

final smartSyncEngineProvider = Provider<SmartSyncEngine>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  final connectionManager = ref.watch(gmailConnectionManagerProvider);
  final vault = ref.watch(financeEvidenceVaultProvider);
  final repairEngine = ref.watch(repairEngineProvider);
  
  return SmartSyncEngine(
    db: db,
    dao: dao,
    connectionManager: connectionManager,
    vault: vault,
    repairEngine: repairEngine,
  );
});

final financeInboxServiceProvider = Provider<FinanceInboxService>((ref) {
  final db = ref.watch(knightDatabaseProvider);
  final dao = ref.watch(financePlatformDaoProvider);
  return FinanceInboxService(db: db, dao: dao);
});
