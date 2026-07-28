import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/cognitive_models.dart';
import 'package:knight_os/core/intelligence/engines/intent_engine.dart';

void main() {
  const engine = IntentEngine();

  group('IntentEngine', () {
    test('detects decision intent', () {
      expect(
        engine.detectIntent('Should I buy a new laptop?'),
        KnightIntent.decision,
      );
      expect(
        engine.detectIntent('I need to make a choice about my career'),
        KnightIntent.decision,
      );
    });

    test('detects planning intent', () {
      expect(
        engine.detectIntent('Help me plan my week'),
        KnightIntent.planning,
      );
      expect(
        engine.detectIntent('How to achieve my fitness goals?'),
        KnightIntent.planning,
      );
    });

    test('detects reminder intent', () {
      expect(
        engine.detectIntent('Remind me to call Mom at 5pm'),
        KnightIntent.reminder,
      );
      expect(
        engine.detectIntent('Don\'t forget the milk'),
        KnightIntent.reminder,
      );
    });

    test('defaults to conversation for casual input', () {
      expect(
        engine.detectIntent('Hello Knight, how are you?'),
        KnightIntent.conversation,
      );
    });
  });
}
