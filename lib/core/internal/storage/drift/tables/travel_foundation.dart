import 'package:drift/drift.dart';
import '../knight_table.dart';
import 'evidence.dart';

@DataClassName('TripData')
class TripTable extends KnightTable {
  @override
  String get tableName => 'trips';

  TextColumn get transactionId => text()(); // Logical ID for versioning
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  
  /// flight, hotel, train, etc.
  TextColumn get primaryType => text()();
  
  TextColumn get metadata => text().nullable()();

  /// Ownership: My Travel, Family Travel, Shared Travel, Unknown
  TextColumn get identity => text().withDefault(const Constant('unknown'))();

  /// Lifecycle: Evidence Found, Building, Verifying, Verified, Completed, Archived
  TextColumn get lifecycleState => text().withDefault(const Constant('evidence_found'))();

  RealColumn get confidenceScore => real().withDefault(const Constant(0.0))();
  TextColumn get confidenceReason => text().nullable()();
  TextColumn get parserVersion => text().nullable()();
}

@DataClassName('TravelBookingData')
class TravelBookingTable extends KnightTable {
  @override
  String get tableName => 'travel_bookings';

  TextColumn get transactionId => text().nullable()(); // Logical ID
  TextColumn get tripId => text().nullable()();
  
  /// flight, hotel, train, car, bus
  TextColumn get type => text()();
  
  TextColumn get provider => text()();
  TextColumn get reference => text()();
  
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  
  TextColumn get origin => text().nullable()();
  TextColumn get destination => text().nullable()();
  
  TextColumn get status => text().withDefault(const Constant('confirmed'))();

  RealColumn get confidenceScore => real().withDefault(const Constant(0.0))();
  TextColumn get identity => text().withDefault(const Constant('unknown'))();
  TextColumn get parserVersion => text().nullable()();
}

@DataClassName('TravelEvidenceVaultData')
class TravelEvidenceVaultTable extends KnightTable {
  @override
  String get tableName => 'travel_evidence_vault';

  /// Link to immutable file in Evidence Vault
  TextColumn get caid => text().references(EvidenceTable, #caid)();
  
  TextColumn get sourceConnector => text()(); // gmail, photos, etc.
  
  @override
  TextColumn get sourceIdentifier => text()(); // messageId, fileId
  
  /// Original payload/metadata captured at time of import
  TextColumn get rawPayload => text()();
  
  DateTimeColumn get detectedAt => dateTime()();
  TextColumn get parserVersion => text()();
}

@DataClassName('TravelMetricsData')
class TravelMetricsTable extends KnightTable {
  @override
  String get tableName => 'travel_metrics';

  TextColumn get metricKey => text().unique()(); // total_trips, total_distance, etc.
  RealColumn get metricValue => real()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get metadata => text().nullable()(); // JSON for snapshots or breakdowns
}

@DataClassName('TravelGeographicEnrichmentData')
class TravelGeographicEnrichmentTable extends KnightTable {
  @override
  String get tableName => 'travel_geo_enrichment';

  TextColumn get placeId => text().unique()(); // Normalized place ID
  TextColumn get country => text()();
  TextColumn get state => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get timezone => text().nullable()();
  
  /// Complete hierarchy: [Country, State, District, City]
  TextColumn get administrativeHierarchy => text().nullable()(); 
  
  /// Type: UNESCO, National Park, Beach, etc.
  TextColumn get category => text().nullable()(); 
  
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
}
