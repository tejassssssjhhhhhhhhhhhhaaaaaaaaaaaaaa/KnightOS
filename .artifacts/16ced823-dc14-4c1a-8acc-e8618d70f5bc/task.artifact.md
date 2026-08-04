# Task List - Milestone 4: Universal Knowledge Graph Engine

## Phase 0: Platform Stability
- [ ] Fix `flutter analyze` issues
    - [ ] Resolve `dataProviderRegistryProvider` undefined in `splash_screen.dart`
    - [ ] Resolve `latestSteps` undefined in `knight_context_provider.dart`
    - [ ] Resolve unused import in `intelligence_providers.dart`
    - [ ] Resolve `avoid_print` in `runtime_recorder_service.dart`
    - [ ] Fix null-safety issue in `streak_engine.dart`
    - [ ] Fix `BuildContext.push` and `AppRoutes` in `developer_mode_screen.dart`
- [ ] Audit and fix unsafe collection access (`first`, `single`, `firstWhere`, `singleWhere`)
- [ ] Verify Provider initialization and startup stability

## Phase 1: Enterprise Database v14
- [ ] Define `ProvenanceTable`
- [ ] Define `TrustMetricsTable`
- [ ] Define `TemporalHistoryTable`
- [ ] Update `GraphNodeTable` and `GraphEdgeTable` with v14 fields
- [ ] Implement Migration v14 in `KnightDatabase`
- [ ] Implement Rollback/Migration History support

## Phase 2: Universal Graph Platform
- [ ] Implement `GraphQueryService`
- [ ] Implement `UniversalIntelligenceContract`
- [ ] Implement `CapabilityRegistry`
- [ ] Implement `ProviderRegistry`
- [ ] Refactor existing providers to use `GraphQueryService`

## Phase 3: Knowledge Graph Validation
- [ ] Implement `GraphIntegrityEngine`
- [ ] Implement Relationship and Evidence Validation
- [ ] Implement Trust Calculation logic
- [ ] Setup Background Validators

## Phase 4: Developer Platform (Observability)
- [ ] Expand Developer Mode with Graph Explorer
- [ ] Implement Runtime Event Replay UI
- [ ] Add Provider Health and Diagnostics
- [ ] Add Sync Timeline and Queue Inspector

## Phase 5: Performance Optimization
- [ ] Optimize SQLite indexes for graph queries
- [ ] Implement caching for frequent traversals
- [ ] Optimize background worker throughput

## Phase 6: Quality Assurance
- [ ] Final `flutter analyze` and `flutter test` run
- [ ] Build and validate APK
