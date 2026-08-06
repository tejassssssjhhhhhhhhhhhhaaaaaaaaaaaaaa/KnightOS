# Knight Data Platform Implementation Plan

Build a centralized Google Data Hub for KnightOS, featuring robust historical Gmail import, unified evidence storage, and a refactored Finance module that consumes centralized data.

## User Review Required

> [!IMPORTANT]
> This is a large-scale architectural change. Finance will no longer fetch data directly; it will rely on the background synchronization of the Data Hub.

## Proposed Changes

### Core Intelligence Services

#### [NEW] [google_data_hub.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/google_data_hub.dart)
Create a centralized orchestrator for all Google data sources (Gmail, Calendar, Drive, Contacts). It will handle unified authentication and trigger historical/incremental syncs across all providers.

#### [MODIFY] [gmail_sync_orchestrator.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/gmail_sync_orchestrator.dart)
- Implement `syncHistorical(DateTime start, DateTime end)` using granular year/month loops.
- Use `after:YYYY/MM/DD before:YYYY/MM/DD` Gmail queries for exhaustive import.
- Improve checkpointing to save progress per month.
- Enhance duplicate detection to prevent "Duplicate Journal" issues.

#### [MODIFY] [entity_extraction_service.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/entity_extraction_service.dart)
- Update to ingest extracted financial entities directly into the `TransactionTable` via `DataIngestionService`.
- Ensure `supportingEvidenceIds` links back to the original Gmail message.

---

### Finance Module Refactor

#### [MODIFY] [local_money_repository.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/data/local_money_repository.dart)
- Change from file-based JSON storage to Drift-backed `TransactionTable`.
- Implement queries for Dashboard, Timeline, and Analytics using the centralized database.

#### [DELETE] [historical_scanner_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/sync/historical_scanner_service.dart)
Remove direct Gmail fetching from the Finance module.

---

### Import & UI

#### [NEW] [import_center_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/import_center_screen.dart)
Build the "Live Import Center" dashboard showing:
- Connection and Auth status.
- Real-time progress (Year/Month/Batch).
- Counters for different email classifications.
- Transactions and Merchants imported.
- Background sync status.

#### [MODIFY] [sync_task_service.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/sync_task_service.dart)
- Add logic to monitor and report "Real-time" progress to the UI.
- Implement self-healing for corrupted checkpoints.

## Verification Plan

### Automated Tests
- `flutter test test/core/intelligence/gmail_historical_sync_test.dart` (to be created)
- `flutter test test/features/finance/data_consumption_test.dart` (to be created)

### Manual Verification
- Deploy to the connected Android device.
- Perform a full Gmail historical import.
- Verify that the Finance dashboard populates without manual triggers.
- Check the Live Import Center for real-time updates.
