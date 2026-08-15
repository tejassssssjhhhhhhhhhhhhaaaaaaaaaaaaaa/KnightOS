# KNIGHT OS V1.0 - OVERNIGHT BUILD PLAN

This plan details the implementation of the Knight OS Version 1.0 scope, focusing on the Personal Data Foundation, Google Drive Persistence, Canonical Data Models, and feature polishing.

## User Review Required

> [!IMPORTANT]
> **Data Persistence Policy**: This plan assumes that the existing SQLite schema migrations are sufficient for version upgrades. We will NOT delete the database during upgrades.
> **Google Drive Sync**: We will move from a full-file backup approach to a more granular, structured canonical data sync to Drive, ensuring individual records are persistent and identifiable.

## Proposed Changes

### [Core] [Knight Database & Canonical Model]
- **[MODIFY] [knight_table.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/knight_table.dart)**: Ensure all canonical fields are present (stable ID, source, provenance, version, etc.). Add `domain` and `category` as first-class columns.
- **[MODIFY] [knight_database.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/knight_database.dart)**: Verify schema version 28 and ensure all feature tables are properly linked and indexed.
- **[MODIFY] [provenance.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/provenance.dart)**: Ensure it captures source record IDs and timestamps as required.

### [Core] [Storage & Google Drive Sync]
- **[NEW] [canonical_sync_service.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/canonical_sync_service.dart)**: A new service that exports modified canonical records to Google Drive as structured JSON files.
- **[MODIFY] [cloud_sync_service.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/cloud_sync_service.dart)**: Orchestrate both granular canonical sync and full encrypted backups.
- **[MODIFY] [google_auth_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/google_auth_service.dart)**: Ensure robust token management for background sync tasks.

### [Features] [Data Hub & Import]
- **[MODIFY] [import_manager.dart](file:///C:/Users/tejas/knight_os/lib/features/import/infrastructure/import_manager.dart)**: Implement the central routing logic for different domains (Finance, Health, etc.).
- **[NEW] [raw_data_cleanup_task.dart](file:///C:/Users/tejas/knight_os/lib/features/import/infrastructure/raw_data_cleanup_task.dart)**: A background task to implement the 7-day raw data retention policy.

### [Features] [Module Polishing]
- **[MODIFY] [Finance]**: Update dashboards to include all requested metrics (Runway, Cash Flow, Loans, Recurring, Subscriptions) and period filters.
- **[MODIFY] [Health]**: Ensure all real metrics (Steps, Sleep, Heart Rate, etc.) are visible with trends and last sync status.
- **[MODIFY] [Workout]**: Implement the configuration UI for equipment, goals, and experience. Add daily plan generation logic.
- **[MODIFY] [Travel]**: Polish the Timeline and Map views. Ensure all reservations (Flights, Hotels) are visible.
- **[MODIFY] [Home]**: Keep it clean; show only factual snapshots of other modules.

### [Documentation]
- **[MODIFY] [KNIGHT_OS_MASTER.txt](file:///C:/Users/tejas/knight_os/KNIGHT_OS_MASTER.txt)**: Append the V1.0 Release Scope, Policies, and Overnight Execution Log.

## Verification Plan

### Automated Tests
- Run `flutter test` on modified core logic.
- Verify `CanonicalSyncService` JSON generation.
- Verify `RawDataCleanupTask` deletion logic.

### Manual Verification
- Deploy to device/emulator.
- Perform a sample data import (e.g., Finance CSV).
- Verify data appears in the respective module and is uploaded to Google Drive.
- Check "Settings" for Sync status and Data Hub controls.
