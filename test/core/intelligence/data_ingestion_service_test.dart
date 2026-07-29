import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/engines/memory_engine.dart';
import 'package:knight_os/core/intelligence/engines/knowledge_graph.dart';
import 'package:knight_os/core/intelligence/engines/discovery_engine.dart';
import 'package:knight_os/core/intelligence/services/data_ingestion_service.dart';
import 'package:knight_os/core/intelligence/services/json_validation_service.dart';
import 'package:knight_os/core/intelligence/domain/repositories/memory_repository.dart';

class MockMemoryRepository extends Fake implements MemoryRepository {
  final List<KnightMemory> savedMemories = [];

  @override
  Future<void> saveAll(List<KnightMemory> memories) async {
    savedMemories.addAll(memories);
  }

  @override
  Future<void> save(KnightMemory memory) async {
    savedMemories.add(memory);
  }

  @override
  Future<List<KnightMemory>> search(String query) async => savedMemories;
}

class MockJsonValidationService extends Fake implements JsonValidationService {
  @override
  Future<void> validate(MemoryDomain domain, Map<String, dynamic> content) async {}
}

class MockKnowledgeGraph extends Fake implements KnowledgeGraph {}
class MockDiscoveryEngine extends Fake implements DiscoveryEngine {}

void main() {
  late DataIngestionService service;
  late MockMemoryRepository repository;

  setUp(() {
    repository = MockMemoryRepository();
    final memoryEngine = MemoryEngine(
      repository: repository,
      validationService: MockJsonValidationService(),
    );
    service = DataIngestionService(
      memoryEngine: memoryEngine,
      knowledgeGraph: MockKnowledgeGraph(),
      discoveryEngine: MockDiscoveryEngine(),
    );
  });

  group('DataIngestionService', () {
    test('ingestAllHistoricalData returns report and populates repository', () async {
      final report = await service.ingestAllHistoricalData();
      
      expect(report, contains('finance'));
      expect(report['errors'], isA<List>());
      
      // Even if files are missing, finance is currently simulated/mocked in ported logic
      expect(repository.savedMemories, isNotEmpty);
    });

    test('ingestCareerHistory creates memories for career domain', () async {
      await service.ingestAllHistoricalData();
      
      final careerMemories = repository.savedMemories.where((m) => m.metadata.domain == MemoryDomain.career);
      expect(careerMemories, isNotEmpty);
      expect(careerMemories.first.summary, contains('Career Document'));
    });
  });
}
