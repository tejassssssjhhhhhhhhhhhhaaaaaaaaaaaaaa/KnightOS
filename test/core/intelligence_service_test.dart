import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/services/intelligence_service.dart';
import 'package:knight_os/core/intelligence/model_router.dart';
import 'package:knight_os/core/storage/privacy_vault.dart';

void main() {
  late IntelligenceService intelligenceService;

  setUp(() {
    intelligenceService = IntelligenceService();
  });

  group('IntelligenceService Routing', () {
    test('Queries with highlySensitive data route to localSLM (Simulated)', () async {
      final insight = await intelligenceService.query(
        title: 'Salary Analysis',
        prompt: 'Analyze my current salary',
        classification: PrivacyClassification.highlySensitive,
      );

      expect(insight.recommendation, contains('localSLM'));
    });

    test('Public queries route to cloudLLM (Simulated)', () async {
      final insight = await intelligenceService.query(
        title: 'Weather Outfit',
        prompt: 'What should I wear today?',
        classification: PrivacyClassification.public,
      );

      expect(insight.recommendation, contains('cloudLLM'));
    });
  });
}
