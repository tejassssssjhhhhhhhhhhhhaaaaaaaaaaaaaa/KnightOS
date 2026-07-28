import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/memory_category.dart';
import '../../../../core/intelligence/domain/health_models.dart';
import '../../../../core/intelligence/domain/knight_memory.dart';

class HealthTimelineWidget extends ConsumerWidget {
  const HealthTimelineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retrieval = ref.watch(memoryRetrievalEngineProvider);

    return FutureBuilder<List<KnightMemory>>(
      future: retrieval.getByCategory(BookCategory.health),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final healthMemories = snapshot.data!
          ..sort((a, b) => b.effectiveAt.compareTo(a.effectiveAt));

        if (healthMemories.isEmpty) {
          return const Center(child: Text('No health events recorded.'));
        }

        return Column(
          children: healthMemories
              .map((m) => _buildTimelineItem(context, m))
              .toList(),
        );
      },
    );
  }

  Widget _buildTimelineItem(BuildContext context, KnightMemory memory) {
    final type = memory.healthDataType;
    final config = _getEventConfig(type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, color: config.color, size: 20),
              ),
              Container(
                width: 2,
                height: 40,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(memory),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  memory.summary ?? 'No summary available.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(memory.effectiveAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(KnightMemory memory) {
    switch (memory.healthDataType) {
      case HealthDataType.sleep:
        return 'Sleep Session';
      case HealthDataType.exercise:
        return 'Workout Logged';
      case HealthDataType.vital:
        return 'Vitals Recorded';
      case HealthDataType.hydration:
        return 'Hydration Update';
      case HealthDataType.nutrition:
        return 'Meal Logged';
      case HealthDataType.medication:
        return 'Medication Adherence';
      case HealthDataType.medicalRecord:
        return 'Medical Record';
      case HealthDataType.symptom:
        return 'Symptom Reported';
      default:
        return 'Health Event';
    }
  }

  _EventConfig _getEventConfig(HealthDataType? type) {
    switch (type) {
      case HealthDataType.sleep:
        return const _EventConfig(Icons.bedtime_rounded, Colors.indigo);
      case HealthDataType.exercise:
        return const _EventConfig(Icons.fitness_center_rounded, Colors.orange);
      case HealthDataType.vital:
        return const _EventConfig(Icons.favorite_rounded, Colors.red);
      case HealthDataType.hydration:
        return const _EventConfig(Icons.water_drop_rounded, Colors.blue);
      case HealthDataType.nutrition:
        return const _EventConfig(Icons.restaurant_rounded, Colors.green);
      case HealthDataType.medication:
        return const _EventConfig(Icons.medication_rounded, Colors.teal);
      case HealthDataType.medicalRecord:
        return const _EventConfig(Icons.assignment_rounded, Colors.purple);
      case HealthDataType.symptom:
        return const _EventConfig(Icons.thermostat_rounded, Colors.redAccent);
      default:
        return const _EventConfig(Icons.health_and_safety_rounded, Colors.grey);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return 'Today, ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}/${time.year}';
  }
}

class _EventConfig {
  const _EventConfig(this.icon, this.color);
  final IconData icon;
  final Color color;
}
