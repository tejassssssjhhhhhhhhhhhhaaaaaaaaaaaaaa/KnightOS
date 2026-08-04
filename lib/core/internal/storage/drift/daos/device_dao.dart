import 'package:drift/drift.dart';
import '../knight_database.dart';
import '../tables/device_registry.dart';

part 'device_dao.g.dart';

@DriftAccessor(tables: [DeviceRegistryTable])
class DeviceDao extends BaseDao<DeviceRegistryTable, DeviceRegistryData>
    with _$DeviceDaoMixin {
  DeviceDao(super.db);

  Future<List<DeviceRegistryData>> getAllDevices() => select(deviceRegistryTable).get();
}
