import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/engines/ai_router.dart';
import 'package:knight_os/core/intelligence/engines/multi_ai_providers.dart';
import 'package:knight_os/core/intelligence/domain/ai_models.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';

void main() {
  late AiRouter router;

  setUp(() {
    router = AiRouter();
    router.registerProvider(
      FlashModelProvider(),
      const ModelManifest(
        id: 'fast',
        name: 'Fast',
        capabilities: [AiCapability.fast],
        providerName: 'Test',
      ),
    );
    router.registerProvider(
      GeminiProvider(),
      const ModelManifest(
        id: 'precise',
        name: 'Precise',
        capabilities: [AiCapability.precise],
        providerName: 'Test',
      ),
    );
  });

  group('Multi-Model AI Integration (Sprint 2.1)', () {
    test('selectProvider chooses fast model for simple questions', () {
      final provider = router.selectProvider(KnightIntent.question);
      expect(provider, isA<FlashModelProvider>());
    });

    test('selectProvider chooses precise model for strategic planning', () {
      final provider = router.selectProvider(KnightIntent.planning);
      expect(provider, isA<GeminiProvider>());
    });
  });
}
