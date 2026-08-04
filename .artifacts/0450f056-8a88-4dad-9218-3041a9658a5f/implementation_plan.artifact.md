# KnightOS Finance Platform Foundation (Phase A)

Implementation of a production-ready financial data platform using Gmail as the primary source of truth.

## User Review Required

> [!IMPORTANT]
> This plan focuses entirely on the **Finance Platform Foundation**. It does NOT include any user-facing dashboards, charts, or budgets, as per the mission statement.

> [!WARNING]
> We will be introducing a new set of tables in the Drift database to support the Sync Journal and Terminal States requirements. This may require a schema migration to v17.

## Proposed Changes

### [Database & Models]

#### [NEW] [finance_sync_journal.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/finance_sync_journal.dart)
Defines the `FinanceSyncJournalTable` to track every Gmail message's processing state.

#### [NEW] [finance_institution_metadata.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/finance_institution_metadata.dart)
Defines `FinanceInstitutionMetadataTable` for Module 3.

#### [MODIFY] [knight_database.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/knight_database.dart)
Register new tables and increment schema version to 17.

### [Module 1: Secure Gmail Connection]

#### [NEW] [gmail_connection_manager.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/auth/gmail_connection_manager.dart)
Handles OAuth via `google_sign_in`, secure token storage via `flutter_secure_storage`, and connection health.

### [Module 2: Historical Gmail Scanner]

#### [NEW] [historical_scanner_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/sync/historical_scanner_service.dart)
Implements the scanning logic, resume capability, and batch processing.

### [Module 3: Institution Discovery Engine]

#### [NEW] [institution_discovery_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/institution_discovery_engine.dart)
Logic to identify and store institution metadata from emails.

### [Module 4 & 5: Classification & Parser Engines]

#### [NEW] [finance_classification_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/finance_classification_engine.dart)
Refined classification into specific financial categories (Salary, Bill, etc.).

#### [NEW] [finance_parser_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/finance_parser_engine.dart)
High-precision extraction of amount, date, merchant, reference number, etc.

### [Module 6: Canonical Transaction Database]

#### [NEW] [canonical_transaction_repository.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/data/canonical_transaction_repository.dart)
Service to manage transactions with full metadata, linking back to Gmail evidence.

### [Module 7 & 8: Duplicate Detection & Sync Journal]

#### [NEW] [duplicate_detection_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/duplicate_detection_engine.dart)
Fingerprinting and merging logic.

#### [NEW] [sync_journal_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/sync/sync_journal_service.dart)
Manages the `FinanceSyncJournalTable` for idempotency and recovery.

### [Module 9 & 10: Real-Time Sync & Verification Engine]

#### [NEW] [real_time_sync_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/sync/real_time_sync_service.dart)
Automatically processes new messages post-historical scan.

#### [NEW] [finance_verification_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/finance_verification_engine.dart)
Ensures every financial email ends in a terminal state.

### [Module 11 & 12: Audit Engine & Developer Mode]

#### [NEW] [gmail_audit_engine.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/engine/gmail_audit_engine.dart)
Generates diagnostics and coverage statistics.

#### [NEW] [finance_developer_service.dart](file:///C:/Users/tejas/knight_os/lib/features/finance/platform/dev/finance_developer_service.dart)
Exposes internal pipeline metrics for the Developer Mode.

## Verification Plan

### Automated Tests
- `flutter test test/features/finance/platform/` (New test suite for the platform).
- Integration tests for Gmail connection (mocked).
- Parser accuracy tests using a set of sample financial emails.

### Manual Verification
- Verify Developer Mode metrics in the app (if UI is available or via logs).
- Check Drift database file to ensure `finance_sync_journal` is populated correctly.
