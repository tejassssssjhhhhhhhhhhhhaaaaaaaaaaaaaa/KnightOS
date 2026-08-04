import '../domain/entities/insight.dart';
import '../internal/utils/knight_logger.dart';

/// Ensures all AI outputs meet the KnightOS Explainability Standard.
class ExplainabilityEngine {
  /// Validates that an insight has sufficient explanation components.
  bool validate(Insight insight) {
    final path = insight.reasoningPath;
    
    if (path.steps.isEmpty) {
      KnightLogger.warn('[EXPLAIN] Insight ${insight.id} has no logic steps.');
      return false;
    }

    if (insight.confidence == ConfidenceLevel.low && path.missingInformation.isEmpty) {
      KnightLogger.warn('[EXPLAIN] Low confidence insight ${insight.id} should specify missing info.');
    }

    return true;
  }

  /// Formats an insight for presentation, highlighting evidence.
  String formatReasoning(Insight insight) {
    final buffer = StringBuffer();
    buffer.writeln('### Reasoning for: ${insight.title}');
    buffer.writeln('**Recommendation:** ${insight.recommendation}');
    buffer.writeln('**Confidence:** ${insight.confidence.name.toUpperCase()}');
    buffer.writeln('\n**Logic Steps:**');
    
    for (var i = 0; i < insight.reasoningPath.steps.length; i++) {
      final step = insight.reasoningPath.steps[i];
      buffer.writeln('${i + 1}. ${step.description}');
      if (step.evidenceIds.isNotEmpty) {
        buffer.writeln('   - Supported by evidence: ${step.evidenceIds.join(', ')}');
      }
    }

    if (insight.reasoningPath.assumptions.isNotEmpty) {
      buffer.writeln('\n**Assumptions:**');
      for (final a in insight.reasoningPath.assumptions) {
        buffer.writeln('- $a');
      }
    }

    if (insight.reasoningPath.risks.isNotEmpty) {
      buffer.writeln('\n**Risks:**');
      for (final r in insight.reasoningPath.risks) {
        buffer.writeln('- $r');
      }
    }

    return buffer.toString();
  }
}
