import 'calendar_connector.dart';
import 'weather_connector.dart';

class MockCalendarClient implements CalendarClient {
  @override
  Future<bool> checkAuth() async => true;

  @override
  Future<List<String>> getUpcomingEvents() async {
    return [
      'Project Alpha Review @ 10:00 AM',
      'System Architecture Deep Dive @ 2:00 PM',
    ];
  }
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
