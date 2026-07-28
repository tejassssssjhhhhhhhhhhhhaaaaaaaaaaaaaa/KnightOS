# ADR-002: Reactive Platform Core

## Status
Accepted

## Context
Knight OS requires a live, responsive user interface that reflects data changes across multiple modules (Work, Health, AI) without manual page refreshes or complex state invalidation logic.

## Decision
All storage and repository operations will support `Stream` responses by default. The `StorageEngine` and `KnightRepository` interfaces are expanded to include `watch()` and `watchAll()` methods. 

For the **Knight Memory Engine**, this is implemented via:
- `Stream<KnightMemory?> watchLatest(String memoryId)`
- `Stream<List<KnightMemory>> watchByCategory(BookCategory category)`
- `Stream<List<KnightMemory>> watchByDomain(MemoryDomain domain)`

## Implementation (Phase 7.5)
- **Persistence**: Drift `watch()` and `watchSingleOrNull()` on the `MemoryTable`.
- **Logic**: `MemoryEngine` exposes these streams, allowing feature modules to bind UI directly to canonical facts.
- **SSoT**: Updates to any memory record automatically trigger all active stream listeners across all modules.
1. **Developer Experience**: Feature developers can bind UI to data streams once, reducing the need for manual refresh logic.
2. **Platform Uniformity**: Ensures that automated background tasks (e.g., AI insights) can update the UI instantly.
3. **Consistency**: Eliminates "stale data" bugs by ensuring the UI always reflects the database's current state.

## Alternatives Considered
- **Manual Invalidation (Riverpod `ref.invalidate`)**: Harder to maintain as the app grows; prone to missed refreshes.
- **Poll-based Refresh**: Battery intensive and provides a sub-par user experience.

## Trade-offs
- **Memory**: Keeping multiple active database streams can increase memory usage.
- **Complexity**: Requires a reactive-capable storage engine (Drift/SQLite).

## Future Impact
Enables real-time collaboration and cross-device sync where changes from other devices appear instantly on the local UI.
