# Knight OS: Master Blueprint — Storage & Core Data Platform

This blueprint defines the long-term data architecture for Knight OS, evolving from a simple app storage layer into **Knight Core**—a scalable, reactive, and offline-first platform.

## 1. Architectural Vision
The goal is to remove the "data burden" from feature developers. In the future, adding a new module (e.g., "Health") should only require defining a table schema. All platform capabilities (reactivity, soft delete, backup, sync) must be inherited automatically.

## 2. Core Components

### A. Reactive Storage Engine (`lib/core/storage/`)
The `StorageEngine` interface is expanded to support continuous data streams (Reactivity).

```dart
abstract class StorageEngine {
  // Lifecycle
  Future<void> initialize();

  // Reactive Reads
  Stream<T?> watch<T extends KnightEntity>(String id);
  Stream<List<T>> watchAll<T extends KnightEntity>({QueryFilter? filter});

  // Standard CRUD
  Future<void> upsert<T extends KnightEntity>(T entity);
  Future<void> batchUpsert<T extends KnightEntity>(List<T> entities);
  Future<T?> get<T extends KnightEntity>(String id);

  // Transactions
  Future<R> transaction<R>(Future<R> Function() action);
}
```

### B. The Feature DAO Pattern
We will use **Data Access Objects (DAOs)** to encapsulate Drift-specific SQL logic, keeping the core database file clean.

- **`KnightTable`**: A base class for Drift tables including `id`, `createdAt`, `updatedAt`, `version`, `isDeleted`, `deletedAt`, `syncStatus`, and `deviceId`.

### C. Base Knight Repository (`lib/core/repositories/`)
A generic base class that implements the standard "Operating System" data rules.

```dart
abstract class KnightRepository<T extends KnightEntity> {
  // Every repository inherits:
  // 1. Automatic 'isDeleted' filtering.
  // 2. Automatic 'updatedAt' stamping.
  // 3. Validation hooks before write.
  // 4. Audit logging triggers.
  // 5. Reactive streams for UI.
}
```

## 3. Data Integrity & Safety

### Soft Delete & Recovery
Knight OS never deletes user data by default.
- `delete()` sets `isDeleted = true`.
- A global `TrashService` (Core) can query all tables for `isDeleted == true` to allow user-facing recovery.

### Verification Pipeline (The "Shadow" Migration)
To move from JSON files to SQLite safely:
1. **Backup**: Zip legacy JSON files.
2. **Transform**: Parse JSON and map to `KnightEntity`.
3. **Transaction**: Insert into SQLite.
4. **Verify**: Perform a row-count check. If counts match, rename JSON to `.migrated`.
5. **Ledger**: Record success in the `MigrationReports` table.

## 4. Decision Log: Why SQLite (Drift)?

| Requirement | Reason |
| :--- | :--- |
| **Why Relational?** | Knight OS is about "Connections." Relationships between your Sleep, Work, and Journal entries are better modeled with Foreign Keys than nested JSON. |
| **Why Drift?** | It offers the best balance of SQLite's reliability and Dart's type-safety. It has built-in support for Migrations and DAOs. |
| **Why not Isar?** | While fast, Isar 3.x has brittle dependencies on `analyzer` that conflict with modern Riverpod versions. SQLite is industry-standard and future-proof. |

## 5. Future-Proofing Strategy

- **AI Readiness**: Tables will include `embedding` columns (nullable) to support Vector Search for local LLM integration.
- **Sync Readiness**: The `version` and `syncStatus` fields enable **Optimistic Concurrency Control** for future cloud multi-device sync.
- **Privacy**: We will implement a `DataSensitivity` enum per table to decide which modules require additional encryption (SQLCipher).

## 6. Implementation Roadmap

1. **Infrastructure Refinement**: Update `StorageEngine` for reactivity.
2. **Schema Definition**: Create `KnightTable` and `KnightDatabase` with the first feature tables (Profile, Work).
3. **Migration Logic**: Implement the Idempotent Migration Pipeline.
4. **Feature Cutover**: Migrate `UserRepository` and `WorkRepository` to the new core.

---

**Master Blueprint V1 Complete.**
I am awaiting your review before beginning the transition of the first feature modules.
