import 'memory_engine.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_metadata.dart';

class VerificationMission {
  const VerificationMission({
    required this.memory,
    required this.priority,
    required this.type,
  });

  final KnightMemory memory;
  final int priority; // Lower is higher priority
  final VerificationType type;
}

enum VerificationType {
  /// Confirming a guess made by Knight.
  confirmation,

  /// Correcting outdated or incorrect info.
  correction,

  /// Periodic re-validation of critical facts.
  revalidation,
}

/// Identifies inferred knowledge that requires human confirmation.
class VerificationEngine {
  const VerificationEngine({required this.memoryEngine});

  final MemoryEngine memoryEngine;

  /// Returns a list of memories that should be verified by the owner.
  Future<List<VerificationMission>> getPendingVerifications() async {
    // 1. Fetch latest state of all memories
    // In a production environment, this would be a specialized DAO query
    final allMemories = await memoryEngine.search('');

    final missions = <VerificationMission>[];

    for (final memory in allMemories) {
      if (memory.state == KnowledgeState.deprecated) continue;

      // Detection Logic
      if (memory.state == KnowledgeState.inferred && !memory.verified) {
        // High confidence inferences get prioritized
        if (memory.confidence > 0.6) {
          missions.add(
            VerificationMission(
              memory: memory,
              priority: _calculatePriority(memory),
              type: VerificationType.confirmation,
            ),
          );
        }
      } else if (memory.state == KnowledgeState.userConfirmed &&
          memory.verified) {
        // Periodic Revalidation for critical info (e.g. Health goals, Career status)
        if (_needsRevalidation(memory)) {
          missions.add(
            VerificationMission(
              memory: memory,
              priority: 10, // Lower priority than new inferences
              type: VerificationType.revalidation,
            ),
          );
        }
      }
    }

    // Sort by priority (lower number first)
    missions.sort((a, b) => a.priority.compareTo(b.priority));

    return missions;
  }

  int _calculatePriority(KnightMemory memory) {
    // Base priority from importance (0.0 to 1.0) -> (0 to 100)
    int base = (100 * (1.0 - memory.importance)).toInt();

    // Confidence adjustment: higher confidence is easier to verify (lower number)
    int adjustment = (20 * (1.0 - memory.confidence)).toInt();

    return base + adjustment;
  }

  bool _needsRevalidation(KnightMemory memory) {
    if (memory.lastVerifiedAt == null) return false;

    final age = DateTime.now().difference(memory.lastVerifiedAt!);

    // Critical categories need revalidation every 90 days
    final criticalCategories = ['identity', 'career', 'health', 'finance'];

    if (criticalCategories.contains(memory.category.name.toLowerCase())) {
      return age.inDays > 90;
    }

    return false;
  }
}
