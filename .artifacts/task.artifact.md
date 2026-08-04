# Task Tracker - Sprint C: Stability & Universal Knowledge Graph (Milestone 4)

## Phase 0: Platform Stability
- [ ] **1. Collection Safety Pass**
    - [ ] lib/app/home_screen.dart
    - [ ] lib/core/intelligence/domain/*.dart (Confidence, Memory models)
    - [ ] lib/core/intelligence/engines/*.dart (AI Router, Autonomous, Discovery)
    - [ ] lib/core/intelligence/engines/health/*.dart (Fitness, Context, Medication, Nutrition)
    - [ ] lib/core/intelligence/engines/modules/*.dart (Daily Briefing, Insight, Mission, Recommendation)
    - [ ] lib/core/intelligence/engines/reasoning_engine.dart
    - [ ] lib/core/intelligence/engines/synthesis_engine.dart
    - [ ] lib/core/intelligence/knight_cognition.dart
    - [ ] lib/core/intelligence/knight_context_provider.dart
    - [ ] lib/core/intelligence/knight_context_service.dart
    - [ ] lib/core/intelligence/services/*.dart (Registry, Sync, Task)
    - [ ] lib/core/logic/engine/streak_engine.dart
    - [ ] lib/features/focus/presentation/focus_controller.dart
    - [ ] lib/features/knight/presentation/knight_controller.dart
    - [ ] lib/features/settings/presentation/*_dashboard.dart
- [ ] **2. Provider Defense**
    - [ ] Defensive `DataProviderRegistry` initialization
    - [ ] Fix toggle reset issue
    - [ ] Startup diagnostics in Splash
- [ ] **3. Stability Validation**
    - [ ] `flutter analyze`
    - [ ] Verify zero ProviderExceptions on boot

## Phase 1: Database v14 (Enterprise Graph)
- [ ] Update `graph_nodes.dart` & `graph_edges.dart`
- [ ] Create `graph_snapshots.dart`
- [ ] Implement v13 -> v14 Migration
- [ ] Create DAOs for new metadata fields

## Phase 2: Graph Services
- [ ] Implement `GraphQueryService` (Universal Query API)
- [ ] Implement `IntelligenceContract` (UIC)
- [ ] Implement `TrustEngine`
- [ ] Implement `GraphIntegrityEngine`

## Phase 3: Observability (Dev Mode)
- [ ] Build `ProviderHealthScreen`
- [ ] Build `GraphExplorerScreen`
- [ ] Build `TrustDistribution` Dashboard
- [ ] Update `ARCHITECTURE_MANIFEST.md`

## Phase 4: Final QA
- [ ] `flutter build apk`
- [ ] Physical device validation (Xiaomi 211033MI)
