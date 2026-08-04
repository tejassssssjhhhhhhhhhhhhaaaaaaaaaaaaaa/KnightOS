# Phase 1: Travel Evidence Foundation

Implement the core infrastructure for discovering, importing, normalizing, and verifying travel evidence from multiple sources.

## User Review Required

> [!IMPORTANT]
> This implementation focuses exclusively on the "Evidence Foundation" (Phase 1). No user-facing dashboards (besides the Import Tracker) or AI summaries will be built.

## Proposed Changes

### [Travel Domain & Storage]

Expand the travel storage layer to support unified evidence, confidence scoring, and identity resolution.

#### [MODIFY] [travel_foundation.dart](file:///C:/Users/tejas/knight_os/lib/core/internal/storage/drift/tables/travel_foundation.dart)
- Add `TravelEvidenceTable` to store normalized evidence links.
- Add `identity` column to `TripTable` and `TravelBookingTable`.
- Add confidence scoring columns.

#### [MODIFY] [travel_models.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/domain/travel_models.dart)
- Update `Trip` and `TravelBooking` to reflect new storage fields.
- Add `TravelEvidence` and `TravelIdentity` models.

---

### [Travel Intelligence Engines]

Implement the specialized engines for processing travel data.

#### [NEW] [travel_evidence_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/engines/travel_evidence_engine.dart)
- Normalizes raw data from connectors into `TravelEvidence`.
- Ensures no information loss by preserving raw payloads.

#### [NEW] [travel_identity_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/engines/travel_identity_engine.dart)
- Resolves ownership (My Travel, Family, Shared, Unknown).
- Implements rules-based classification for Gmail/Calendar records.

#### [NEW] [travel_confidence_engine.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/engines/travel_confidence_engine.dart)
- Calculates confidence scores based on multi-source verification (e.g., Gmail + Photos).

#### [NEW] [travel_knowledge_graph.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/engines/travel_knowledge_graph.dart)
- Links related evidence (Flights, Hotels, Photos) into unified `Trips`.

---

### [Connectors]

Implement pluggable connectors for various travel data sources.

#### [NEW] [gmail_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/gmail_travel_connector.dart)
- Scans emails for travel-related confirmations.

#### [NEW] [google_photos_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/google_photos_travel_connector.dart)
- Extracts GPS and timestamp metadata from photos to detect trip clusters.

#### [NEW] [google_maps_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/google_maps_travel_connector.dart)
- Imports location history and visited places.

#### [NEW] [google_calendar_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/google_calendar_travel_connector.dart)
- Imports travel-related calendar events.

#### [NEW] [finance_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/finance_travel_connector.dart)
- Links travel expenses from the existing Finance module.

#### [NEW] [manual_travel_connector.dart](file:///C:/Users/tejas/knight_os/lib/core/intelligence/travel/connectors/manual_travel_connector.dart)
- Supports PDF and document imports.

---

### [Import Dashboard]

#### [NEW] [travel_import_dashboard.dart](file:///C:/Users/tejas/knight_os/lib/features/travel/presentation/travel_import_dashboard.dart)
- Real-time tracker for import status, counts, and failures.
- Replaces or supplements existing manual input UI for Phase 1.

---

## Verification Plan

### Automated Tests
- Unit tests for `TravelIdentityResolutionEngine` ensuring correct classification.
- Integration tests for `TravelKnowledgeGraph` verifying evidence linking.
- Mock connector tests to verify end-to-end import flow.

### Manual Verification
- Deploy to device and trigger a mock Gmail import.
- Verify Import Dashboard updates in real-time.
- Check database for normalized records with confidence scores.
