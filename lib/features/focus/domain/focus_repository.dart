import 'focus_area.dart';

/// Contract for fetching and updating user focus areas.
abstract class FocusRepository {
  /// Fetches the current list of focus areas.
  Future<List<FocusArea>> getFocusAreas();

  /// Updates a specific focus area.
  Future<void> updateFocusArea(FocusArea area);
}
