# Next Task: World Engine - Real Connectors (Sprint 4.5)

**Status:** Ready  
**Owner:** AI Engineer

---

# Objective
Transition from mock perception to real-world integration by implementing concrete "Connectors" for Calendar and Mail, enabling Knight OS to read and write data to external services (simulated via API client interfaces).

# Requirements
- Implement `GoogleCalendarConnector`:
    - `fetchEvents(start, end)`
    - `createEvent(event)`
- Implement `EmailConnector`:
    - `fetchRecentThreads()`
    - `sendDraft(draftId)`
- Extend `WorldEngine` to aggregate data from these real connectors.
- Implement `ConnectorAuthorization`: Logic to handle OAuth flows (simulated for this sprint).
- Add "Connection Health" to the Device Hub: Show if external services are synchronized.

# Architecture
- **Adapter**: `CalendarConnector` and `MailConnector` extending `WorldConnector`.
- **Infrastructure**: `GoogleCalendarClient` (Interface) and `MockGoogleCalendarClient` (Implementation).
- **Service**: `WorldService` update to handle multi-connector registration.

# Definition of Done
- Mission Control shows real-world calendar events (from the connector).
- Autonomous plans can successfully create a calendar event via the connector.
- `flutter analyze` passes.
- Unit tests for connector data transformation pass.
