import '../../intelligence/domain/world_models.dart';

/// Standard interface for all external data providers.
abstract class WorldConnector {
  /// Unique identifier for the connector (e.g. "weather-api").
  String get id;

  /// Human-readable name.
  String get name;

  /// Descriptive metadata for this source.
  WorldSource get source;

  /// Fetches the latest data and returns a raw map for normalization.
  Future<Map<String, dynamic>> fetchData();

  /// Validates the current connection status.
  Future<bool> isAvailable();
}
