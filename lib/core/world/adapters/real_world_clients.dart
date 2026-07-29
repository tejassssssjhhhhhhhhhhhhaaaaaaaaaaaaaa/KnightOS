import 'dart:convert';
import 'package:http/http.dart' as http;
import 'calendar_connector.dart';
import 'weather_connector.dart';

class GoogleCalendarClientImpl implements CalendarClient {
  @override
  Future<bool> checkAuth() async {
    // Future: Check OAuth2 token via secure storage
    return true;
  }

  @override
  Future<List<String>> getUpcomingEvents() async {
    // Simulation of real API call
    try {
      // final response = await http.get(Uri.parse('https://www.googleapis.com/calendar/v3/...'));
      // if (response.statusCode == 200) { ... }
      return [
        'Real-world Sync Test @ 9:00 PM',
        'System Calibration @ 11:30 PM',
      ];
    } catch (_) {
      return [];
    }
  }
}

class OpenWeatherClientImpl implements WeatherClient {
  @override
  Future<Map<String, dynamic>> getCurrentWeather() async {
    // Simulation of real API call
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
