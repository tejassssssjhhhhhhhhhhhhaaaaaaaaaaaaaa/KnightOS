import '../../intelligence/domain/world_models.dart';
import '../domain/world_connector.dart';

class MockCalendarConnector implements WorldConnector {
  @override
  String get id => 'calendar';

  @override
  String get name => 'Google Calendar (Mock)';

  @override
  WorldSource get source => const WorldSource(
        id: 'google-calendar',
        name: 'Google Calendar',
        type: 'calendar',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    return {
      'items': [
        'Architecture Review with Tejas @ 10:00 AM',
        'Sprint Planning @ 2:00 PM',
        'Gym Session @ 6:00 PM',
      ],
    };
  }

  @override
  Future<bool> isAvailable() async => true;
}

class MockWeatherConnector implements WorldConnector {
  @override
  String get id => 'weather';

  @override
  String get name => 'OpenWeather (Mock)';

  @override
  WorldSource get source => const WorldSource(
        id: 'open-weather',
        name: 'OpenWeather',
        type: 'weather',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    return {
      'current': 'Sunny, 24°C',
      'forecast': 'Clear skies for the next 4 hours.',
    };
  }

  @override
  Future<bool> isAvailable() async => true;
}

class MockFinanceConnector implements WorldConnector {
  @override
  String get id => 'finance';

  @override
  String get name => 'Market Data (Mock)';

  @override
  WorldSource get source => const WorldSource(
        id: 'finance-api',
        name: 'Finance API',
        type: 'finance',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    return {
      'market': 'Open',
      'portfolio_delta': '+1.2%',
    };
  }

  @override
  Future<bool> isAvailable() async => true;
}
