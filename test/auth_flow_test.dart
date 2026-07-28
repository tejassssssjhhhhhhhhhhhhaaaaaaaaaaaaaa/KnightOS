import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/features/onboarding/domain/onboarding_profile.dart';
import 'package:knight_os/core/storage/local_database.dart';
import 'package:knight_os/core/storage/storage_keys.dart';

const MethodChannel _pathProviderChannel = MethodChannel(
  'plugins.flutter.io/path_provider',
);
late Directory _authTestDirectory;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    _authTestDirectory = await Directory.systemTemp.createTemp(
      'knight_os_auth_test',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          _pathProviderChannel,
          (call) async => call.method == 'getApplicationSupportDirectory'
              ? _authTestDirectory.path
              : null,
        );
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pathProviderChannel, null);
    if (await _authTestDirectory.exists()) {
      await _authTestDirectory.delete(recursive: true);
    }
  });

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await const LocalDatabase().delete(StorageKeys.authAccounts);
    await const LocalDatabase().delete(StorageKeys.authSession);
  });

  test('sign in rejects unknown accounts with a clear message', () async {
    final repository = AuthenticationRepository();

    await expectLater(
      repository.signIn(email: 'missing@example.com', password: 'Password123'),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'No account exists with this email.',
        ),
      ),
    );
  });

  test('sign in rejects incorrect passwords with a clear message', () async {
    final repository = AuthenticationRepository();
    await repository.signUp(
      email: 'user@example.com',
      password: 'Password123',
      displayName: 'Knight User',
    );

    await expectLater(
      repository.signIn(email: 'user@example.com', password: 'wrong-password'),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'Incorrect email or password.',
        ),
      ),
    );
  });

  test('sign up creates an account and a session for future sign in', () async {
    final repository = AuthenticationRepository();

    final session = await repository.signUp(
      email: 'new@example.com',
      password: 'Password123',
      displayName: 'New User',
    );
    expect(session.email, 'new@example.com');

    final restored = await repository.signIn(
      email: 'new@example.com',
      password: 'Password123',
    );
    expect(restored.displayName, 'New User');
    expect(await repository.isAuthenticated(), isTrue);
  });

  test('new profiles default to INR currency', () {
    final profile = UserProfile(completedSteps: const []);

    expect(profile.currency, 'INR');
  });
}
