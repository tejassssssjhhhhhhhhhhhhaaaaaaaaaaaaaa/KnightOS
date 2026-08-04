import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/travel_models.dart';
import 'package:knight_os/core/intelligence/travel/engines/travel_identity_engine.dart';

void main() {
  late TravelIdentityEngine engine;

  setUp(() {
    engine = TravelIdentityEngine();
  });

  group('TravelIdentityEngine', () {
    test('should resolve My Travel for single passenger (user)', () async {
      final metadata = {
        'passengers': ['John Doe'],
      };
      final result = await engine.resolve(
        metadata: metadata,
        userName: 'John Doe',
      );
      expect(result, TravelIdentity.myTravel);
    });

    test('should resolve Family Travel for multiple passengers with family', () async {
      final metadata = {
        'passengers': ['John Doe', 'Jane Doe'],
      };
      final result = await engine.resolve(
        metadata: metadata,
        userName: 'John Doe',
        familyNames: ['Jane Doe'],
      );
      expect(result, TravelIdentity.familyTravel);
    });

    test('should resolve Shared Travel for multiple passengers without family', () async {
      final metadata = {
        'passengers': ['John Doe', 'Bob Smith'],
      };
      final result = await engine.resolve(
        metadata: metadata,
        userName: 'John Doe',
        familyNames: ['Jane Doe'],
      );
      expect(result, TravelIdentity.sharedTravel);
    });

    test('should resolve Unknown when no passengers and different recipient', () async {
      final metadata = {
        'recipient': 'someone@else.com',
      };
      final result = await engine.resolve(
        metadata: metadata,
        userName: 'John Doe',
      );
      expect(result, TravelIdentity.unknown);
    });
  });
}
