import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('sign in rejects unknown accounts with a clear message', () async {
    final repository = AuthenticationRepository();

    await expectLater(
      repository.signIn(email: 'missing@example.com', password: 'Password123'),
      throwsA(isA<ArgumentError>().having((error) => error.message, 'message', 'No account exists with this email.')),
    );
  });

  test('sign in rejects incorrect passwords with a clear message', () async {
    final repository = AuthenticationRepository();
    await repository.signUp(email: 'user@example.com', password: 'Password123', displayName: 'Knight User');

    await expectLater(
      repository.signIn(email: 'user@example.com', password: 'wrong-password'),
      throwsA(isA<ArgumentError>().having((error) => error.message, 'message', 'Incorrect email or password.')),
    );
  });

  test('sign up creates an account and a session for future sign in', () async {
    final repository = AuthenticationRepository();

    final session = await repository.signUp(email: 'new@example.com', password: 'Password123', displayName: 'New User');
    expect(session.email, 'new@example.com');

    final restored = await repository.signIn(email: 'new@example.com', password: 'Password123');
    expect(restored.displayName, 'New User');
    expect(await repository.isAuthenticated(), isTrue);
  });

  test('new profiles default to INR currency', () {
    const profile = OnboardingProfile(completedSteps: []);

    expect(profile.currency, 'INR');
  });
}
