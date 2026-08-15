# KNIGHTOS Data Hub Phase 1: Knight Core + Live Data Journey

Transform the existing Data Hub into a futuristic, calm, and secure KNIGHT Control Center. This phase focuses on the core entry experience, visual representation of the system, and real-time data processing visibility.

## User Review Required

> [!IMPORTANT]
> This phase will replace the existing list-based Data Hub UI with a centralized Core layout. Existing diagnostics and manual import tools will be moved to a secondary layer.

## Proposed Changes

### [Knight Core UI]

#### [NEW] [knight_core_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/knight_core_screen.dart)
A new screen that serves as the entry point for the Data Hub, featuring the Knight Core visualization and live data journey.

#### [NEW] [knight_shield_entrance.dart](file:///C:/Users/tejas/knight_os/lib/core/design_system/widgets/knight_shield_entrance.dart)
Specialized animation widget for the Data Hub opening experience.

#### [NEW] [data_pipeline_journey.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/widgets/data_pipeline_journey.dart)
Visualizer for the Source → Processing → Decision → Storage flow.

#### [MODIFY] [import_center_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/import_center_screen.dart)
Reorganize to serve as the "Technical Diagnostics" layer accessible from the new Core screen.

### [Data Pipeline & Events]

#### [MODIFY] [integration_events.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/events/integration_events.dart)
Add granular events for pipeline stages: `Fetched`, `Parsed`, `Normalized`, `Deduplicated`, `Categorized`, `Saved`.

#### [MODIFY] [normalization_pipeline.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/normalization_pipeline.dart)
Emit granular events during the normalization and projection process.

#### [MODIFY] [google_data_hub.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/services/google_data_hub.dart)
Update `HubProgress` and state management to track individual processing journeys.

### [Diagnostics & Errors]

#### [NEW] [diagnostic_layer.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/widgets/diagnostic_layer.dart)
Multi-layered explanation system (Human + Technical).

#### [NEW] [error_detail_view.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/widgets/error_detail_view.dart)
Detailed error breakdown with retry and safety context.

## Verification Plan

### Automated Tests
- Unit tests for new `KnightEvent` types.
- Widget tests for `KnightShieldEntrance` and `DataPipelineJourney`.
- Integration tests for the full sync flow visualization.
- `flutter analyze` to ensure code health.

### Manual Verification
- Deploy to Redmi Pad.
- Verify Shield entrance animation.
- Verify real source statuses (Gmail, Calendar, etc.).
- Verify live activity display during sync.
- Verify error state triggered by intentional connection failure.
- Verify privacy masking in technical details.
