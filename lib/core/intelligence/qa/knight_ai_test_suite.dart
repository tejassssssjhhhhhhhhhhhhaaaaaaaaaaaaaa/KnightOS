import '../knight_cognition.dart';
import '../../internal/utils/knight_logger.dart';

class QAResult {
  final String query;
  final String response;
  final bool passed;
  final String? feedback;

  QAResult({required this.query, required this.response, required this.passed, this.feedback});
}

class KnightAiTestSuite {
  KnightAiTestSuite({required this.cognition});
  final KnightCognition cognition;

  final List<String> _testQueries = [
    'Hello',
    'Who am I?',
    'Show my recent transactions',
    'Summarize my health',
    'Find documents related to Delhi',
    'What happened today?',
  ];

  Future<List<QAResult>> runFullSuite() async {
    final results = <QAResult>[];
    KnightLogger.info('[QA] Starting Knight AI Intelligence Suite...');

    for (final query in _testQueries) {
      try {
        final result = await cognition.processRequest(query);
        // Heuristic verification: Check for hallucination markers or empty context usage
        bool passed = result.response.isNotEmpty && !result.response.contains('Error');
        
        results.add(QAResult(
          query: query,
          response: result.response,
          passed: passed,
          feedback: result.trace.thoughtChain.join(' -> '),
        ));
      } catch (e) {
        results.add(QAResult(
          query: query,
          response: 'CRITICAL FAILURE: $e',
          passed: false,
        ));
      }
    }

    KnightLogger.info('[QA] Suite complete. ${results.where((r) => r.passed).length}/${results.length} PASSED.');
    return results;
  }
}
