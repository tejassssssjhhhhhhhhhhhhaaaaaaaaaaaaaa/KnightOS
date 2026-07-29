import '../../intelligence/domain/world_models.dart';
import 'calendar_connector.dart';
import 'weather_connector.dart';
import 'email_connector.dart';

class MockCalendarClient implements CalendarClient {
  @override
  Future<bool> checkAuth() async => true;

  @override
  Future<List<CalendarEvent>> fetchEvents(DateTime start, DateTime end) async {
    return [
      CalendarEvent(
        id: 'mock-cal-1',
        title: 'Project Alpha Review',
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      CalendarEvent(
        id: 'mock-cal-2',
        title: 'System Architecture Deep Dive',
        startTime: DateTime.now().add(const Duration(hours: 5)),
        endTime: DateTime.now().add(const Duration(hours: 7)),
      ),
    ];
  }

  @override
  Future<bool> createEvent(CalendarEvent event) async => true;
}

class MockEmailClient implements EmailClient {
  @override
  Future<bool> checkAuth() async => true;

  @override
  Future<List<EmailThread>> fetchRecentThreads() async {
    return [
      EmailThread(
        id: 'mock-msg-1',
        subject: 'Weekly Digest',
        sender: 'Newsletter',
        snippet: 'Here is what you missed this week...',
        receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<bool> sendDraft(String draftId) async => true;
}

class MockWeatherClient implements WeatherClient {
  @override
  Future<Map<String, dynamic>> getCurrentWeather() async {
    return {
      'temp': 22,
      'condition': 'Partly Cloudy',
      'humidity': 65,
    };
  }

  @override
  Future<bool> isOnline() async => true;
}
