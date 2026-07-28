# Implementation Plan - KnightOS Experience & World Layer

This plan defines the development of the **Experience & World Layer**, enabling Knight to perceive and interact with the user's digital and physical environment.

## User Review Required

> [!IMPORTANT]
> The Experience & World Layer introduces **Observation & Automation**. Knight will now actively monitor system events (files, calendar, device state) and may proactively surface information via **Notification Intelligence**.

> [!CAUTION]
> This phase involves **Permissions & Privacy**. All external integrations (Google, Local Files) will require user consent and will be strictly governed by the Privacy Framework.

## Proposed Changes

### 1. World & Device Domain Layer
Define models for perception and connectivity.

#### [NEW] [world_models.dart](file:///C:/Users/tejas/knight_os/lib/core/world/domain/world_models.dart)
- `WorldContext`: Current state of the environment (Weather, Time, Activity).
- `DeviceInfo`: Abstract state of connected hardware (Battery, Network, Apps).
- `IntegrationConfig`: Connection metadata for external services.

### 2. Experience Engines (Intelligence Layer)
Expand the "Mind" to include perception.

#### [NEW] [world_context_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/world_context_engine.dart)
- Responsibility: Maintain the "What is happening now?" state.
- Injected into the `ContextPipeline`.

#### [NEW] [observation_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/observation_engine.dart)
- Responsibility: Detect changes in files, calendar, and metrics.
- Output: Candidate memories for the `MemoryEngine`.

#### [NEW] [notification_intelligence.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/notification_intelligence.dart)
- Responsibility: Decision logic for when and how to interrupt the user.

### 3. Integration & World Layer (Core World)
Frameworks for external world interaction.

#### [NEW] [integration_framework.dart](file:///C:/Users/tejas/knight_os/lib/core/world/integration_framework.dart)
- `ExternalIntegration` interface (e.g., `fetch()`, `push()`, `sync()`).
- Modular adapters for Google Calendar, Gmail, etc.

#### [NEW] [device_intelligence.dart](file:///C:/Users/tejas/knight_os/lib/core/world/device_intelligence.dart)
- Unified hardware abstraction layer.

#### [NEW] [automation_framework.dart](file:///C:/Users/tejas/knight_os/lib/core/world/automation_framework.dart)
- Orchestration for Morning Brief, Weekly Review, etc.

#### [NEW] [permissions_framework.dart](file:///C:/Users/tejas/knight_os/lib/core/world/permissions_framework.dart)
- Privacy enforcement and audit logs.

### 4. Advanced Data Management
Unified views and intelligence over files/history.

#### [NEW] [file_intelligence.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/file_intelligence.dart)
- Logic for document summarization and semantic indexing.

#### [NEW] [unified_search_layer.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/unified_search_layer.dart)
- Semantic search across all sources (Memories, Files, Timeline).

#### [NEW] [unified_timeline_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/engines/unified_timeline_engine.dart)
- Merges events from all engines into a single chronological life record.

### 5. Knowledge Base & Importers
Framework for bulk ingestion.

#### [MODIFY] [import_framework.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/importers/import_framework.dart)
- Add support for incremental Knowledge Base imports (YAML/Markdown).
- Implement `GoogleTakeoutImporter`.

## Verification Plan

### Automated Tests
- `world_context_test.dart`: Verify environment state updates.
- `observation_engine_test.dart`: Test candidate memory generation from mocked changes.
- `notification_logic_test.dart`: Verify "Urgency" and "Quiet Hours" decisions.

### Manual Verification
- **Integration Setup**: Verify a mocked Google Calendar sync populates the `Unified Timeline`.
- **Device Dashboard**: A debug UI to view connected device metrics (Battery, connectivity).
- **Global Search**: Search for a keyword found in both a Chat conversation and a local File.
