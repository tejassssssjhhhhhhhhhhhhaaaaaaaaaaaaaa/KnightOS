# Implementation Plan - Sprint C: Platform Stability & Universal Knowledge Graph (Milestone 4)

This plan outlines the critical stabilization of KnightOS (Phase 0) followed by the implementation of the Universal Knowledge Graph (Milestone 4).

## User Review Required

> [!IMPORTANT]
> **Phase 0 Stability Mandate**: We will not proceed to graph implementation until all `ProviderException: Bad state: No element` crashes are resolved. This involves replacing unsafe collection accesses across 30+ files.
>
> **Database Version 14**: This milestone involves a major schema evolution. We are introducing first-class Relationships, Provenance tracking, and a Trust Engine. This will be a non-destructive migration.
>
> **Universal Intelligence Contract (UIC)**: We are formalizing how data enters the system. No module will bypass the Classification -> Extraction -> Validation -> Graph pipeline.

## Proposed Changes

### Phase 0: Platform Stability
- **[MODIFY] Global Source Audit**: Replace `.first`, `.single`, `.firstWhere`, and `.singleWhere` with safe alternatives (`firstOrNull`, `orElse` blocks) in all identified intelligence engines and services.
- **[MODIFY] `lib/core/intelligence/services/data_provider_registry.dart`**:
    - Wrap every provider initialization in defensive try-catch blocks.
    - Ensure `connectionIntent` persistence doesn't trigger race conditions.
- **[MODIFY] `lib/app/screens/splash_screen.dart`**:
    - Implement a "Boot Diagnostic" that logs the status of each provider.

### Phase 1: Enterprise Database v14
- **[MODIFY] `lib/core/internal/storage/drift/tables/graph_nodes.dart`**:
    - Add Provenance: `createdByProvider`, `createdByParser`, `parserVersion`, `evidenceHash`.
    - Add Trust: `trustScore`, `trustReason`.
    - Add Governance: `retentionPolicy`, `visibility`, `sensitivityLevel`.
- **[MODIFY] `lib/core/internal/storage/drift/tables/graph_edges.dart`**:
    - Conceptually upgrade to `Relationships`. Add Trust, Provenance, and Versioning.
- **[NEW] `lib/core/internal/storage/drift/tables/graph_snapshots.dart`**:
    - Foundation for the Graph Time Machine.

### Phase 2: Graph & Intelligence Services
- **[NEW] `lib/core/intelligence/services/graph_query_service.dart`**:
    - The single interface for all modules to find nodes, relationships, and evidence.
- **[NEW] `lib/core/intelligence/domain/intelligence_contract.dart`**:
    - Formal definition of the 15-stage provider lifecycle.
- **[NEW] `lib/core/intelligence/services/trust_engine.dart`**:
    - Logic for cross-provider verification and trust score propagation.

### Phase 3: Developer Observability (Extension)
- **[MODIFY] `lib/features/settings/presentation/developer_mode_screen.dart`**:
    - Add **Provider Health** page.
    - Add **Graph Health** dashboard with trust and confidence distribution.
    - Add **Runtime Event Replay** for debugging background worker transitions.

## Verification Plan

### Automated Tests
- **Stability Test**: Unit tests to verify that `firstWhereOrNull` correctly handles empty lists without throwing.
- **Migration Test**: Verify v13 -> v14 data integrity.
- **Query Performance**: Benchmark `GraphQueryService` multi-hop traversals.

### Manual Verification (QA Protocol)
1. **Startup Audit**: Verify 0 exceptions in logcat during app boot.
2. **Provider Persistence**: Toggle Gmail -> Restart -> Verify stay connected.
3. **Graph Integrity**: Use Developer Mode to verify "Trust Score" correctly reflects evidence quality.
4. **Physical Device**: Validate entire pipeline (Sync -> Extract -> Graph) on Xiaomi 211033MI.
