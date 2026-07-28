# Knight OS: Chief Architect's Storage Foundation Review

As Chief Architect, I have completed a deep-dive review of the Phase 1 storage infrastructure. While the shift to **Drift (SQLite)** is technically sound and resolves immediate blockers, the current implementation contains "day-one" patterns that will not scale to a lifetime personal operating system.

## 1. Identified Risks & Bottlenecks

### A. The "Companion Bottleneck"
The `DriftStorageEngine` currently uses a switch-case `_convertToCompanion` method.
- **Risk**: As we add Health, Finance, Journal, etc., this method will grow to hundreds of lines.
- **Maintenance**: Adding a new feature will require modifying the core `StorageEngine` implementation, violating the **Open-Closed Principle**.

### B. Reactive Gap
The `StorageEngine` interface is purely `Future`-based.
- **Risk**: Knight OS needs a "live" UI. If a background task updates a fitness goal, the dashboard should react immediately.
- **Missing**: We lack a standard for `watch<T>` or `streamAll<T>` in the abstraction.

### C. Repository Duplication
Legacy repositories (`UserRepository`, `WorkRepository`) are handling their own JSON mapping and file I/O.
- **Risk**: Moving to Drift will likely lead to developers duplicating "IsDeleted" checks and "UpdatedAt" logic in every feature repository.

## 2. Recommended Improvements (Blueprint Goals)

### I. Data Access Objects (DAOs)
Instead of a single monolithic `StorageEngine` handling every table, we should adopt a **Feature DAO** pattern.
- Each module (e.g., `WorkModule`) provides its own DAO to the core database.
- The `StorageEngine` becomes a thin coordinator of these DAOs.

### II. The "Knight Repository" Base
Create a generic `KnightRepository<TEntity, TTable>` that:
- Automatically filters out `isDeleted == true` in queries.
- Injects `deviceId` and `updatedAt` on every write.
- Provides standard `Stream` support for reactive UI.

### III. Optimized Migration Orchestrator
The migration from JSON to Drift shouldn't just be a "copy-paste." It needs to be an **Idempotent Pipeline**:
- Support "re-runnable" migrations if the app crashes mid-process.
- Use a `MigrationLedger` table to track progress at a granular level (e.g., "Work Sessions migrated, Fitness pending").

## 3. Architectural Trade-offs

| Choice | Pro | Con |
| :--- | :--- | :--- |
| **Strict Interface Abstraction** | Can replace Drift with NoSQL/Cloud in future. | Adds boilerplate for mapping objects to tables. |
| **Relational (SQLite)** | Data integrity, complex queries, industry standard. | Schema migrations require more discipline than raw JSON. |
| **Soft Delete by Default** | User can recover "accidental" deletions; better for AI training. | Database file size grows over time (requires a vacuum strategy). |

## 4. Strategic Decision: Reactive Foundation
I am proposing that the `StorageEngine` interface be expanded to support **Reactivity (Streams)**. This is essential for a modern OS experience where data changes in one module (e.g., a voice capture) should ripple through the entire system without a manual refresh.

---

**Architectural Review Complete.**
I am now standing by for the **Master Blueprint** which will define the exact contracts for these DAOs and the Base Repository before we begin migrating user data.
