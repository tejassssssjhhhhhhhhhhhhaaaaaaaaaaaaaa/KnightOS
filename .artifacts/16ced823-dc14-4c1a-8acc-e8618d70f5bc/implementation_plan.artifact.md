# Implementation Plan - Milestone 4: Universal Knowledge Graph Engine

This plan covers the implementation of Milestone 4, starting with Phase 0 (Platform Stability) and proceeding to Phase 1 (Database v14) and Phase 2 (Universal Graph).

## User Review Required

> [!IMPORTANT]
> **Database Migration v14**: This update introduces several new tables and columns to existing graph tables. While designed to be non-destructive, a backup is recommended before first run.
>
> **Architecture Shift**: We are moving away from direct DAO access in modules towards a centralized `GraphQueryService`. This will eventually be the only way for feature modules to interact with the Knowledge Graph.

## Open Questions
1. Should `UniversalNodeRegistry` be a new table or an enhancement of `GraphNodeTable`? (Proposed: Enhancement for better migration).
2. For "Temporal Graph", should we use a full event-sourcing approach or a simple `VersionHistoryTable`? (Proposed: `VersionHistoryTable` for current requirements).

## Proposed Changes

### Phase 0: Platform Stability

#### [MODIFY] [splash_screen.dart](file:///C:/Users/tejas/knight_os/lib/app/screens/splash_screen.dart)
- Add missing import for `intelligence_providers.dart` to resolve `dataProviderRegistryProvider` error.

#### [MODIFY] [knight_context_provider.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/knight_context_provider.dart)
- Define `latestSteps` by fetching it from `healthDao` before usage.
- Fix potentially unsafe `firstOrNull` usage.

#### [MODIFY] [streak_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/logic/engine/streak_engine.dart)
- Fix null safety issue with `previousDate` in `calculateStreak`.

#### [MODIFY] [developer_mode_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/settings/presentation/developer_mode_screen.dart)
- Add missing imports for `go_router` and `AppRoutes`.
- Guard `context` usage across async gaps.

#### [AUDIT] Unsafe Collection Usage
- Scan for and fix unsafe `.first()`, `.single()`, `.firstWhere()`, `.singleWhere()` without `orElse` or null checks across the project.

---

### Phase 1: Database v14 (Enterprise Schema)

#### [MODIFY] [knight_database.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/knight_database.dart)
- Increment `schemaVersion` to 14.
- Add migration logic for v14.

#### [MODIFY] [graph_nodes.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/graph_nodes.dart)
- Add `provenanceId` (FK to ProvenanceTable).
- Add `trustScore` (Real).
- Add `isCanonical` (Bool).
- Add `canonicalId` (FK to CanonicalIdentityTable).
- Add `governanceLabel` (Text).

#### [MODIFY] [graph_edges.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/graph_edges.dart)
- Add `provenanceId` (FK to ProvenanceTable).
- Add `trustScore` (Real).
- Add `evidenceId` (FK to EvidenceTable).
- Add `temporalStart` & `temporalEnd` (DateTime).

#### [NEW] [provenance.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/provenance.dart)
- Define `ProvenanceTable`: `id`, `sourceType`, `sourceUri`, `ingestionMethod`, `ingestedAt`, `agentId`.

#### [NEW] [trust_metrics.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/trust_metrics.dart)
- Define `TrustMetricsTable`: `id`, `targetId` (Node/Edge), `score`, `confidence`, `lastCalculated`, `algorithmVersion`.

#### [NEW] [temporal_history.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/temporal_history.dart)
- Define `TemporalHistoryTable`: `id`, `entityId`, `entityType`, `previousState` (JSON), `newState` (JSON), `changedAt`, `reason`.

---

### Phase 2: Universal Graph Engine

#### [NEW] [graph_query_service.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/graph_query_service.dart)
- Centralized service for graph traversals and queries.

#### [NEW] [capability_registry.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/capability_registry.dart)
- Managing system capabilities and feature flags.

#### [MODIFY] [data_provider_registry.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/data_provider_registry.dart)
- Enhance to support Milestone 4 requirements (Module Dependency Graph).

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure all current errors are resolved.
- Run `flutter test` to verify no regressions in existing logic.
- Implement new unit tests for `GraphQueryService` and v14 migrations.

### Manual Verification
- Deploy to Android device and verify startup succeeds with migration.
- Check Developer Mode -> Database tab for new schema version and health metrics.
- Verify Gmail/Calendar/Drive sync continues to work.
