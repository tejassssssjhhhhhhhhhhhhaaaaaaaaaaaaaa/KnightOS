import '../domain/world_connector.dart';
import '../../intelligence/domain/world_models.dart';

/// Integration for OpenWeather API.
class OpenWeatherConnector implements WorldConnector {
  OpenWeatherConnector({required this.client});

  final WeatherClient client;

  @override
  String get id => 'open-weather';

  @override
  String get name => 'OpenWeather';

  @override
  WorldSource get source => const WorldSource(
        id: 'open-weather',
        name: 'OpenWeather',
        type: 'weather',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    final data = await client.getCurrentWeather();
    return {
      'current': '${data['temp']}°C, ${data['condition']}',
      'raw': data,
    };
  }

  @override
  Future<bool> isAvailable() => client.isOnline();
}

abstract class WeatherClient {
  Future<Map<String, dynamic>> getCurrentWeather();
  Future<bool> isOnline();
}
