import '../../domain/intelligence_module.dart';
import '../../domain/intelligence_events.dart';
import '../../domain/intelligence_models.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_domain.dart';
import '../memory_retrieval_engine.dart';
import '../../../world/engines/device_intelligence.dart';
import '../../../world/domain/world_models.dart';

class WorldContextModule extends IntelligenceModule {
  WorldContextModule({
    required this.retrieval,
    required this.deviceIntelligence,
  });

  final MemoryRetrievalEngine retrieval;
  final DeviceIntelligence deviceIntelligence;

  WorldContext _currentContext = WorldContext(
    timestamp: DateTime.now(),
    timezone: 'UTC',
    locationLabel: 'Unknown',
  );

  @override
  String get id => 'world_context';

  @override
  List<BookCategory> get inputCategories => [
    BookCategory.history,
    BookCategory.identity,
  ];

  @override
  double get priority => 1.0; // High priority as others depend on context

  @override
  Future<void> onEvent(IntelligenceEvent event) async {
    if (event is DataChangedEvent) {
      // Check if any location/activity memories changed
      final hasRelevantChanges = event.memories.any(
        (m) =>
            m.metadata.domain == MemoryDomain.travel ||
            m.metadata.domain == MemoryDomain.identity,
      );

      if (hasRelevantChanges) {
        await _updateContext();
      }
    }
  }

  Future<void> _updateContext() async {
    final now = DateTime.now();
    final device = await deviceIntelligence.getLocalDeviceInfo();

    // In a real app, we'd query the latest visit from MemoryRetrievalEngine
    final latestVisit = await retrieval.getLatest('anchor-home');

    _currentContext = _currentContext.copyWith(
      timestamp: now,
      currentActivity: _inferActivity(now, device),
      locationLabel: latestVisit?.content['type'] ?? 'Unknown',
    );
  }

  String _inferActivity(DateTime now, DeviceInfo device) {
    if (now.hour >= 23 || now.hour < 6) return 'Sleeping';
    if (device.activeApps.contains('zoom')) return 'Working';
    return 'Active';
  }

  @override
  Future<List<IntelligenceResult>> getInsights() async {
    return []; // Context module primarily provides state, not insights
  }

  @override
  Future<List<IntelligenceResult>> getRecommendations() async {
    return [];
  }

  @override
  Future<List<String>> getBriefingItems() async {
    return [
      'Current State: ${_currentContext.currentActivity} at ${_currentContext.locationLabel}',
    ];
  }

  WorldContext get currentContext => _currentContext;
}
