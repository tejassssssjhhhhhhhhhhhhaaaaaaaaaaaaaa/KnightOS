import '../domain/world_connector.dart';
import '../../intelligence/domain/world_models.dart';

/// Integration for Google Calendar.
class GoogleCalendarConnector implements WorldConnector {
  GoogleCalendarConnector({required this.client});

  final CalendarClient client;

  @override
  String get id => 'google-calendar';

  @override
  String get name => 'Google Calendar';

  @override
  WorldSource get source => const WorldSource(
        id: 'google-calendar',
        name: 'Google Calendar',
        type: 'calendar',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    final events = await client.getUpcomingEvents();
    return {
      'items': events,
    };
  }

  @override
  Future<bool> isAvailable() => client.checkAuth();
}

abstract class CalendarClient {
  Future<List<String>> getUpcomingEvents();
  Future<bool> checkAuth();
}
