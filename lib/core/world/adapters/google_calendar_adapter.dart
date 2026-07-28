import '../domain/integration_interfaces.dart';

/// Integration adapter for Google Calendar.
class GoogleCalendarAdapter implements ExternalIntegration {
  @override
  String get id => 'google-calendar';

  @override
  String get name => 'Google Calendar';

  @override
  Future<IntegrationStatus> getStatus() async {
    return IntegrationStatus.disconnected;
  }

  @override
  Future<void> sync() async {
    // 1. Fetch events via Google API
    // 2. Map to KnightMemory (Category: Upcoming/Event)
    // 3. Save via MemoryEngine
  }

  @override
  Future<void> disconnect() async {
    // Clean up OAuth tokens
  }
}
