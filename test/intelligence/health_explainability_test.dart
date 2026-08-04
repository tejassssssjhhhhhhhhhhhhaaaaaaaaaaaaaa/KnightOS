import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/health/health_engine.dart';
import 'package:knight_os/core/intelligence/domain/health_models.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/repositories/health_repository.dart';
import 'package:knight_os/core/intelligence/engines/health/health_context_engine.dart';
import 'package:knight_os/core/intelligence/services/knowledge_graph_service.dart';
import 'package:knight_os/core/intelligence/engines/verification_engine.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:mocktail/mocktail.dart';
import '../test_utils/mocktail_setup.dart';

class MockHealthRepository extends Mock implements HealthRepository {}
class MockHealthContextEngine extends Mock implements HealthContextEngine {}
class MockKnowledgeGraphService extends Mock implements KnowledgeGraphService {}
class MockVerificationEngine extends Mock implements VerificationEngine {}

void main() {
  late HealthEngine engine;
  late MockHealthRepository mockRepo;
  late MockHealthContextEngine mockContext;
  late MockKnowledgeGraphService mockGraph;
  late MockVerificationEngine mockVerification;

  setUpAll(() {
    setupMocktailFallbacks();
  });

  setUp(() {
    mockRepo = MockHealthRepository();
    mockContext = MockHealthContextEngine();
    mockGraph = MockKnowledgeGraphService();
    mockVerification = MockVerificationEngine();

    engine = HealthEngine(
      repository: mockRepo,
      contextEngine: mockContext,
      graphService: mockGraph,
      verificationEngine: mockVerification,
    );
  });

  test('ReasoningTrace generation includes evidence and thoughtChain', () async {
    when(() => mockRepo.getRecentSleep(limit: any(named: 'limit'))).thenAnswer((_) async => <SleepSessionData>[]);
    when(() => mockRepo.getWaterIntake(any())).thenAnswer((_) async => 1500);
    when(() => mockRepo.getRecentWorkouts(limit: any(named: 'limit'))).thenAnswer((_) async => <WorkoutSessionData>[]);
    when(() => mockRepo.getMealsForDay(any())).thenAnswer((_) async => <MealLogData>[]);
    when(() => mockRepo.getMetricsForType(any(), any())).thenAnswer((_) async => <HealthMetricData>[]);
    
    when(() => mockGraph.ensureNode(type: any(named: 'type'), label: any(named: 'label'))).thenAnswer((_) async => 'node-id');
    when(() => mockGraph.link(
      fromId: any(named: 'fromId'), 
      toId: any(named: 'toId'), 
      relationship: any(named: 'relationship'), 
      weight: any(named: 'weight')
    )).thenAnswer((_) async => {});

    when(() => mockVerification.triggerSensorVerification(
      metric: any(named: 'metric'),
      reason: any(named: 'reason'),
      confidence: any(named: 'confidence'),
    )).thenAnswer((_) async => {});

    final scores = await engine.calculateCurrentScores();

    expect(scores.hydrationScore.score, 75); // 1500/2000
    expect(scores.hydrationScore.trace.thoughtChain.any((s) => s.contains('1500ml')), isTrue);
    expect(scores.hydrationScore.trace.evidence, isNotEmpty);
    expect(scores.hydrationScore.trace.evidence.first.source, 'Manual Input');
    expect(scores.hydrationScore.trace.confidence, 1.0);
  });
}
