import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/services/integration_hub.dart';
import 'package:knight_os/core/services/event_bus.dart';
import 'package:knight_os/core/domain/connectors/i_connector.dart';
import 'package:knight_os/core/domain/connectors/connector_manifest.dart';
import 'package:knight_os/core/domain/events/integration_events.dart';
import 'package:knight_os/core/storage/privacy_vault.dart';

class MockConnector extends Mock implements IConnector {}

void main() {
  late IntegrationHub hub;
  late EventBus eventBus;

  setUp(() {
    eventBus = EventBus.instance;
    hub = IntegrationHub.instance;
  });

  group('IntegrationHub Orchestration', () {
    test('register() adds connector and tracks health', () {
      final mock = MockConnector();
      const manifest = ConnectorManifest(
        id: 'test.connector',
        name: 'Test',
        version: '1.0.0',
        vendor: 'Test',
        supportedPlatforms: ['android'],
        authMethod: AuthMethod.none,
        supportedCapabilities: ['test'],
        syncModes: [SyncMode.manual],
        privacyClassification: PrivacyClassification.public,
      );

      when(() => mock.manifest).thenReturn(manifest);
      when(() => mock.onStatusChanged).thenAnswer((_) => const Stream.empty());

      hub.register(mock);

      expect(hub.getDiscoverableConnectors().any((m) => m.id == 'test.connector'), isTrue);
    });

    test('sync() publishes started and completed events', () async {
      final mock = MockConnector();
      const manifest = ConnectorManifest(
        id: 'test.sync',
        name: 'SyncTest',
        version: '1.0.0',
        vendor: 'Test',
        supportedPlatforms: ['android'],
        authMethod: AuthMethod.none,
        supportedCapabilities: ['test'],
        syncModes: [SyncMode.manual],
        privacyClassification: PrivacyClassification.public,
      );

      when(() => mock.manifest).thenReturn(manifest);
      when(() => mock.onStatusChanged).thenAnswer((_) => const Stream.empty());
      when(() => mock.sync(fullSync: false)).thenAnswer((_) async => const ConnectorResult(status: ConnectorStatus.completed, data: 5));

      hub.register(mock);

      final events = <IntegrationEvent>[];
      final subscription = eventBus.on<IntegrationEvent>().listen(events.add);

      await hub.sync('test.sync');
      
      // Give the stream a microtask to propagate
      await Future.delayed(Duration.zero);

      expect(events.any((e) => e is SyncStarted), isTrue);
      expect(events.any((e) => e is SyncCompleted && e.itemsProcessed == 5), isTrue);
      
      await subscription.cancel();
    });
  });
}
