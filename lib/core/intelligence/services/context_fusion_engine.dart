import '../domain/context_platform_models.dart';
import '../knight_context_models.dart';

/// Logic to merge multiple context contributions into a single unified state.
class ContextFusionEngine {
  const ContextFusionEngine();

  /// Fuses a set of contributions into the target context.
  KnightContext fuse(List<ContextContribution> contributions, KnightContext base) {
    var result = base;

    // Group contributions by field
    final grouped = <String, List<ContextContribution>>{};
    for (final c in contributions) {
      grouped.putIfAbsent(c.field, () => []).add(c);
    }

    for (final field in grouped.keys) {
      final fieldContributions = grouped[field]!;
      final fusion = _fuseField(field, fieldContributions);
      result = _applyFusion(result, fusion);
    }

    return result;
  }

  ContextFusionResult _fuseField(String field, List<ContextContribution> contributions) {
    // Strategy: For foundation, we take the one with the highest confidence.
    // If ties, take the latest.
    
    contributions.sort((a, b) {
      final confComp = b.confidence.compareTo(a.confidence);
      if (confComp != 0) return confComp;
      return b.timestamp.compareTo(a.timestamp);
    });

    final winner = contributions.first;

    return ContextFusionResult(
      field: field,
      fusedValue: winner.value,
      overallConfidence: winner.confidence,
      contributions: contributions,
      method: 'highest_confidence',
    );
  }

  KnightContext _applyFusion(KnightContext context, ContextFusionResult fusion) {
    switch (fusion.field) {
      case 'energyLevel':
        return context.copyWith(energyLevel: fusion.fusedValue as String);
      case 'mood':
        return context.copyWith(mood: fusion.fusedValue as String);
      case 'steps':
        return context.copyWith(steps: fusion.fusedValue as int);
      case 'focusScore':
        return context.copyWith(focusScore: fusion.fusedValue as double);
      case 'waterIntake':
        return context.copyWith(waterIntake: fusion.fusedValue as double);
      case 'calories':
        return context.copyWith(calories: fusion.fusedValue as int);
      case 'healthStatus':
        return context.copyWith(healthStatus: fusion.fusedValue as String);
      case 'weather':
        return context.copyWith(weather: fusion.fusedValue as String);
      default:
        return context;
    }
  }
}
