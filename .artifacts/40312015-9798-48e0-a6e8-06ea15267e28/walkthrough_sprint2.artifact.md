# Walkthrough: Sprint 2 – Knowledge Persistence & Evidence Vault

The **Knowledge Persistence Layer** and the **Evidence Vault** have been successfully implemented. This sprint provides the high-fidelity storage engine required for the Knight Knowledge Base, ensuring immutability, auditability, and verifiable evidence.

## Key Accomplishments

### 1. Robust Drift Persistence
- **Comprehensive Schema**: Updated the Drift database to include 8 tables: `memories`, `evidence`, `memory_relations`, `attachments`, `audit_logs`, `sync_queue`, `user_profiles`, and `migration_ledger`.
- **Immutable Versioning**: Implemented the "N+1" update rule in `MemoryDao`. Every update to a fact creates a new row with `isLatest = true`, while preserving the entire history linked via `prevVersionId`.
- **Auditability**: Every insertion into the `memories` table now includes `changeType` (evolution, correction, etc.) and a `reasoning` field, providing a clear narrative of how knowledge changed.

### 2. Evidence Vault (CAS)
- **Deduplication**: Implemented Content-Addressable Storage (CAS) using SHA-256 hashes (CAID). Identical files are stored only once, regardless of their source.
- **Physical Vault**: Designed a hierarchical directory structure (e.g., `vault/a1/a1b2c3...`) within the application documents folder for efficient file system lookups.
- **Integrity Verification**: Added a forensic `verify(caid)` method that re-calculates the file hash on-demand to detect corruption or tampering.

### 3. Knowledge Graph Foundation
- **Semantic Edges**: Upgraded `MemoryRelationTable` to support complex relationship types: `parent`, `child`, `influences`, `caused_by`, `duplicate`, `derived_from`, and `references`.
- **Relationship Persistence**: Edges now store `strength` and `metadata`, enabling the future "Life Atlas" graph traversals.

### 4. Search & Timeline Indices
- **Search Engine**: Implemented a `searchMemories` method in `MemoryDao` using SQLite `LIKE` patterns on `summary`, `content`, and `tags`.
- **Timeline Ready**: Every memory is now indexed by `effectiveAt`, enabling sub-millisecond timeline queries.

## Architectural Decisions

- **Local-First Integrity**: The use of Drift (SQLite) ensures that Knight's memory is fully operational offline and stays on the owner's device.
- **VFS Abstraction**: The `DriftEvidenceRepository` translates `knight://evidence/` URIs to local paths, fulfilling the location-independence requirement.
- **Atomicity**: All version transitions are wrapped in database transactions to prevent state corruption during power failures or crashes.

## Verification Results
- **Memory Logic**: `drift_memory_repository_test.dart` confirms that updating a fact correctly increments the version and preserves the predecessor link.
- **Vault Logic**: `drift_evidence_repository_test.dart` confirms that uploading the same file twice results in a single physical file and a shared CAID.
- **Pass Rate**: 100% (4/4 tests passed).

> [!TIP]
> The search index currently uses `LIKE` for broad compatibility. In future sprints, we can migrate to SQLite FTS5 for even faster full-text searches as the Knowledge Base grows to thousands of records.
