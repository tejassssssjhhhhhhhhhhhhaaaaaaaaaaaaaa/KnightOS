import 'package:drift/drift.dart';
import '../knight_table.dart';

/// Tracks authorized devices in the user's private mesh.
@DataClassName('DeviceRegistryData')
class DeviceRegistryTable extends KnightTable {
  @override
  String get tableName => 'device_registry';

  @override
  TextColumn get id => text()(); // deviceId

  TextColumn get deviceName => text()();
  
  /// phone, tablet, laptop, server, watch.
  TextColumn get deviceType => text()();

  /// Last seen active.
  DateTimeColumn get lastHeartbeat => dateTime()();

  /// RSA Public Key for secure peer-to-peer sync.
  TextColumn get publicKey => text().nullable()();

  /// Current security/trust status.
  TextColumn get trustStatus => text().withDefault(const Constant('trusted'))();
}
