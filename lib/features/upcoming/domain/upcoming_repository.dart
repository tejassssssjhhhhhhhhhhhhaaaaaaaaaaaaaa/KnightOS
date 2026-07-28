import 'upcoming_item.dart';

abstract class UpcomingRepository {
  Future<List<UpcomingItem>> getUpcomingItems();
  Future<void> saveUpcomingItem(UpcomingItem item);
  Future<void> deleteUpcomingItem(String id);
}
