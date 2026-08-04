# Implementation Plan - M3-WP2: Manual Evidence Import

This plan covers the implementation of the Manual Evidence Import feature using the `IntegrationHub`.

## Proposed Changes

### [KnightOS Core]

#### [MODIFY] [integration_hub.dart](file:///C:/Users/tejas/knight_os/lib/core/services/integration_hub.dart)
Ensure `ManualConnector` is automatically registered or provided as a core plugin.

#### [NEW] [manual_import_controller.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/controllers/manual_import_controller.dart)
Riverpod notifier to manage the UI state of the import process.

#### [NEW] [manual_import_screen.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/screens/manual_import_screen.dart)
UI for selecting file types and triggering the import via the `IntegrationHub`.

#### [NEW] [import_history_provider.dart](file:///C:/Users/tejas/knight_os/lib/features/import/presentation/providers/import_history_provider.dart)
Provider to fetch and display the history of imported evidence.

#### [MODIFY] [mission_service.dart](file:///C:/Users/tejas/knight_os/lib/core/services/mission_service.dart)
Enhance the `EvidenceImported` listener to propose "Mission Suggestions" based on the imported type (e.g., "Resume" -> "Update Career DNA").

## Verification Plan

### Automated Tests
- Unit tests for `ManualImportController` state transitions.
- Integration tests: `File Selected` -> `IntegrationHub#importFile` -> `Evidence Node Created` -> `Timeline Event Created`.

### Manual Verification
- Launch the `Manual Import` screen.
- Select a "Resume" (Simulated path).
- Verify the "Evidence Created" event appears in the log.
- Verify the "Timeline" shows a new entry.
