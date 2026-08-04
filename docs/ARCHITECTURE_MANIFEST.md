# KnightOS Architecture Manifest

**Version**: 5.0.0
**Philosophy**: Private-first Digital Sovereignty

## 1. System Topology

KnightOS operates as a local-first Intelligence Platform that ingests data from a user's digital ecosystem and structures it into a unified Knowledge Graph.

### Layers
- **Atmosphere (UI Root)**: Persist global visual state and the Knight Companion.
- **Intelligence Bus**: Event-driven communication between modules.
- **Sync Orchestration**: Generalized incremental synchronization from cloud providers.
- **Knowledge Core**: Drift-backed SQLite storage with the Knowledge Graph and Life Atlas.

## 2. Synchronization Architecture

KnightOS uses a generalized, queue-based synchronization model to ingest data without impacting performance.

### Data Flow
1. **Provider Hook**: `DataProvider` (Gmail, Drive, etc.) connects via `GoogleAuthService`.
2. **Cursor Management**: `SyncOrchestrator` fetches `historyId` or `syncToken` from `ProviderSyncMetadata`.
3. **Change Detection**: Fetch only new/modified items since the last cursor.
4. **Task Queueing**: Raw items (e.g., Email IDs) are pushed to `SyncTaskQueue`.
5. **Processing**: Background workers pop tasks, perform extraction/reasoning, and update the Knowledge Graph.

## 3. Data Lineage & Sovereignty

Every piece of information in KnightOS must be traceable to its origin.

### Origin Metadata
- `originProviderId`: The source system (e.g., `gmail_api`).
- `originResourceId`: The source's unique ID (e.g., Message ID).
- `originThreadId`: Grouping ID (e.g., Email Thread).
- `syncBatchId`: Traceability to the specific sync operation.

### Confidence Framework
All extracted knowledge includes a confidence score (0-1.0) and a `VerificationState`:
- `UNVERIFIED`: Raw extraction.
- `LIKELY`: High confidence, pending silent verification.
- `VERIFIED`: Confirmed by system rules or secondary source.
- `USER_CONFIRMED`: Explicitly validated by the owner.

## 4. Developer & Stability Platform (Milestone 3.5)

### Runtime Recorder (Black Box)
- Persistent table `runtime_events` for critical system transitions.
- Supports session replay and post-mortem analysis.

### Time Machine (Snapshot Engine)
- Periodic snapshots of system metrics in `system_snapshots`.
- Allows historical inspection of Knowledge Depth and Health trends.

### System Health Dashboard
- Granular health scoring for Subsystems (Auth, DB, Sync, Workers).
- Auto-repair logic for recovering stalled workers or corrupted queues.

### Developer Mode
- In-app Live Log stream with category filtering.
- Raw database and extraction telemetry.
- Debug utilities (Force Sync, Snapshot, Diagnostics Export).

## 5. Intelligence Modules

### Email Intelligence
- **Phase**: Extraction (Active).
- **Parsers**: Finance, Travel, Shopping, Bill, Subscription, Promotion, Document, Personal, Calendar.
- **Deduplication**: Message-ID based pre-insertion prevention.
- **Evidence Vault**: No extraction is committed without linked evidence snippets.

## 6. Security Protocol
- **Encryption**: AES-256 for local SQLite and cloud backups.
- **Authentication**: Local biometric/PIN + OAuth 2.0 with incremental scoping.
- **Privacy**: No user data leaves the device except for encrypted backups to the user's own Drive.
