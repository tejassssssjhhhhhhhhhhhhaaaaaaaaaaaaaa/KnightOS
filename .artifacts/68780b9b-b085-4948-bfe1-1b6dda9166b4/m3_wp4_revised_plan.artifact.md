# Implementation Plan - M3-WP4: Google Calendar Connector (Revised)

This plan covers the implementation of the Google Calendar connector, adhering to the "Evidence-First" architecture.

## Architectural Refinements (Mandatory)

1.  **Evidence-First Ingestion:** The connector will *only* produce Evidence nodes. It will never write to the Timeline directly.
2.  **Deferred Timeline Projection:** The `NormalizationPipeline` will be refactored to support a two-stage process:
    *   Stage 1: **Ingestion** (Raw -> Evidence).
    *   Stage 2: **Projection** (Verified Evidence -> Timeline).
3.  **Event-Driven Projection:** A new `EvidenceVerified` event will trigger the Timeline creation.

## Proposed Changes

### [KnightOS Core]

#### [MODIFY] [integration_events.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/events/integration_events.dart)
Add `EvidenceVerified` event to the `EventBus`.

#### [MODIFY] [normalization_pipeline.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/normalization_pipeline.dart)
Split `process()` into `ingestRawData()` and `projectEvidenceToTimeline()`. Ensure projection only happens for verified evidence.

#### [MODIFY] [evidence_review_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/evidence_review_service.dart)
Publish `EvidenceVerified` event upon successful verification.

#### [NEW] [timeline_projection_listener.dart](file:///C:/Users/tejas/knight_os/lib/core/services/timeline_projection_listener.dart)
Listen for `EvidenceVerified` events and trigger the `NormalizationPipeline#projectEvidenceToTimeline`.

### [Google Calendar Connector]

#### [NEW] [google_calendar_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/connectors/implementations/google_calendar_connector.dart)
Implementation of `IConnector`. Handles OAuth2, `syncToken` management, and batch ingestion.

#### [NEW] [google_calendar_normalizer.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/normalizers/google_calendar_normalizer.dart)
Specialized normalizer to map `calendar#event` JSON to KnightOS UDS.

#### [NEW] [calendar_sync_state.dart](file:///C:/Users/tejas/knight_os/lib/core/domain/models/calendar_sync_state.dart)
Model for persisting `syncToken` and user-selected calendar IDs in `ProviderSyncMetadataTable`.

#### [NEW] [calendar_filter_ui.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/widgets/calendar_filter_ui.dart)
UI component to allow users to select which calendars to include in the sync.

## Specific Requirements Mapping

| Requirement | Implementation Detail |
| :--- | :--- |
| **Sync State** | Uses `ProviderSyncMetadataTable` to store `syncToken` and `lastSyncAt`. |
| **Normalizer** | `GoogleCalendarNormalizer` handles field-level mapping (summary -> title, etc.). |
| **Classification** | Heuristics in Normalizer to identify `meeting`, `work`, `personal` based on attendees. |
| **Duplicates** | Uses `CAID` (SHA-256 of `provider_id + event_id + sequence`) for atomic deduplication. |
| **Incremental Sync** | Implements the `syncToken` flow as per Google Calendar API v3. |
| **Recovery** | Atomic `syncToken` updates only after successful pipeline ingestion. |
| **Diagnostics** | Updates `ConnectorHealth` with latency, error counts, and API quota status. |

## Verification Plan

### Automated Tests
- Unit tests for `GoogleCalendarNormalizer` mapping accuracy.
- Integration tests: `Mock Calendar Sync` -> `Evidence Created (Pending)` -> `Verify Action` -> `Timeline Event Created`.
- Verification of `syncToken` persistence after partial failure.

### Manual Verification
- Verify Google OAuth consent flow.
- Verify user-selected calendars are respected during sync.
- Confirm events appear in `Evidence Inbox` before appearing on `Timeline`.
