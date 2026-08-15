import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knight_os/core/intelligence/providers/journey_provider.dart';
import 'package:knight_os/core/domain/events/integration_events.dart';
import 'package:knight_os/core/services/event_bus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('JourneyNotifier tracks pipeline stages correctly', () async {
    // Listen to the provider to initialize it
    container.listen(journeyProvider, (_, __) {});
    
    // Initial state
    expect(container.read(journeyProvider), isNull);

    // Start received stage
    EventBus.instance.publish(PipelineStageStarted(
      connectorId: 'gmail',
      timestamp: DateTime.now(),
      stage: 'received',
      humanExplanation: 'Human explanation',
      technicalDetail: 'Technical detail',
      resourceId: 'res_123',
    ));

    await Future.delayed(Duration.zero);
    
    final journey = container.read(journeyProvider);
    expect(journey, isNotNull);
    expect(journey!.resourceId, 'res_123');
    expect(journey.stages[0].status, JourneyStageStatus.active);
    expect(journey.stages[0].humanExplanation, 'Human explanation');

    // Complete received stage
    EventBus.instance.publish(PipelineStageCompleted(
      connectorId: 'gmail',
      timestamp: DateTime.now(),
      stage: 'received',
      humanExplanation: 'Completed explanation',
      technicalDetail: 'Completed detail',
      resourceId: 'res_123',
    ));

    await Future.delayed(Duration.zero);

    expect(container.read(journeyProvider)!.stages[0].status, JourneyStageStatus.completed);
    expect(container.read(journeyProvider)!.stages[0].humanExplanation, 'Completed explanation');

    // Fail checked stage
    EventBus.instance.publish(PipelineStageFailed(
      connectorId: 'gmail',
      timestamp: DateTime.now(),
      stage: 'checked',
      humanExplanation: 'Failed explanation',
      technicalDetail: 'Failed detail',
      error: 'CRITICAL_ERROR',
      resourceId: 'res_123',
    ));

    await Future.delayed(Duration.zero);

    expect(container.read(journeyProvider)!.stages[1].status, JourneyStageStatus.failed);
    expect(container.read(journeyProvider)!.stages[1].error, 'CRITICAL_ERROR');
    expect(container.read(journeyProvider)!.isFailed, isTrue);
  });
}
