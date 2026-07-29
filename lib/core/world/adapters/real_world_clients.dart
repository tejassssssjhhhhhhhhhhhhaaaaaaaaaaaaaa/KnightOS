import 'package:http/http.dart' as http;
import '../../intelligence/domain/world_models.dart';
import 'calendar_connector.dart';
import 'weather_connector.dart';
import 'email_connector.dart';

class GoogleCalendarClientImpl implements CalendarClient {
  @override
  Future<bool> checkAuth() async {
    // Future: Check OAuth2 token via secure storage
    return true;
  }

  @override
  Future<List<CalendarEvent>> fetchEvents(DateTime start, DateTime end) async {
    try {
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 400));
      
      return [
        CalendarEvent(
          id: 'cal-1',
          title: 'Autonomous Perception Review',
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 3)),
          location: 'Neural Link Bridge',
        ),
        CalendarEvent(
          id: 'cal-2',
          title: 'System Calibration',
          startTime: DateTime.now().add(const Duration(hours: 5)),
          endTime: DateTime.now().add(const Duration(hours: 6)),
        ),
      ];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> createEvent(CalendarEvent event) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true; // Success
  }
}

class GoogleEmailClientImpl implements EmailClient {
  @override
  Future<bool> checkAuth() async => true;

  @override
  Future<List<EmailThread>> fetchRecentThreads() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      EmailThread(
        id: 'msg-1',
        subject: 'Security Alert: New Login',
        sender: 'Google Security',
        snippet: 'A new login was detected on your account...',
        receivedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      EmailThread(
        id: 'msg-2',
        subject: 'Sprint 5 Planning',
        sender: 'Project Alpha',
        snippet: 'Please find the agenda for our next session...',
        receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  @override
  Future<bool> sendDraft(String draftId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }
}

class OpenWeatherClientImpl implements WeatherClient {
  @override
  Future<Map<String, dynamic>> getCurrentWeather() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'temp': 24,
      'condition': 'Clear Skies',
      'humidity': 40,
    };
  }

  @override
  Future<bool> isOnline() async {
    try {
      final result = await http.head(Uri.parse('https://google.com')).timeout(const Duration(seconds: 2));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
