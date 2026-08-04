// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_dao.dart';

// ignore_for_file: type=lint
mixin _$TravelDaoMixin on DatabaseAccessor<KnightDatabase> {
  $TripTableTable get tripTable => attachedDatabase.tripTable;
  $TravelBookingTableTable get travelBookingTable =>
      attachedDatabase.travelBookingTable;
  $EvidenceTableTable get evidenceTable => attachedDatabase.evidenceTable;
  $TravelEvidenceVaultTableTable get travelEvidenceVaultTable =>
      attachedDatabase.travelEvidenceVaultTable;
  $TravelMetricsTableTable get travelMetricsTable =>
      attachedDatabase.travelMetricsTable;
  $TravelGeographicEnrichmentTableTable get travelGeographicEnrichmentTable =>
      attachedDatabase.travelGeographicEnrichmentTable;
  TravelDaoManager get managers => TravelDaoManager(this);
}

class TravelDaoManager {
  final _$TravelDaoMixin _db;
  TravelDaoManager(this._db);
  $$TripTableTableTableManager get tripTable =>
      $$TripTableTableTableManager(_db.attachedDatabase, _db.tripTable);
  $$TravelBookingTableTableTableManager get travelBookingTable =>
      $$TravelBookingTableTableTableManager(
        _db.attachedDatabase,
        _db.travelBookingTable,
      );
  $$EvidenceTableTableTableManager get evidenceTable =>
      $$EvidenceTableTableTableManager(_db.attachedDatabase, _db.evidenceTable);
  $$TravelEvidenceVaultTableTableTableManager get travelEvidenceVaultTable =>
      $$TravelEvidenceVaultTableTableTableManager(
        _db.attachedDatabase,
        _db.travelEvidenceVaultTable,
      );
  $$TravelMetricsTableTableTableManager get travelMetricsTable =>
      $$TravelMetricsTableTableTableManager(
        _db.attachedDatabase,
        _db.travelMetricsTable,
      );
  $$TravelGeographicEnrichmentTableTableTableManager
  get travelGeographicEnrichmentTable =>
      $$TravelGeographicEnrichmentTableTableTableManager(
        _db.attachedDatabase,
        _db.travelGeographicEnrichmentTable,
      );
}
