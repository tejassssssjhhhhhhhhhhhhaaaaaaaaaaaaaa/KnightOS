import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knight_os/core/repositories/authentication_repository.dart';
import 'package:knight_os/core/repositories/user_repository.dart';
import 'package:knight_os/core/repositories/work_repository.dart';
import 'package:knight_os/core/storage/local_database.dart';
import 'package:knight_os/features/onboarding/domain/onboarding_profile.dart';
import 'package:knight_os/features/work_tracker/domain/work_session.dart';

const MethodChannel _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
late Directory _tempDirectory;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _tempDirectory = await Directory.systemTemp.createTemp('knight_os_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      _pathProviderChannel,
      (call) async {
        if (call.method == 'getApplicationDocumentsDirectory' || call.method == 'getApplicationSupportDirectory') {
          return _tempDirectory.path;
        }
        return null;
      },
    );
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_pathProviderChannel, null);
    if (await _tempDirectory.exists()) {
      await _tempDirectory.delete(recursive: true);
    }
  });

  test('UserRepository saves and loads profile locally', () async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/onboarding_profile.json');
    if (await file.exists()) {
      await file.delete();
    }

    final repository = UserRepository(
      authenticationRepository: AuthenticationRepository(
        secureStorage: _InMemorySecureStorage(),
        localDatabase: const LocalDatabase(),
      ),
    );
    final profile = const OnboardingProfile(completedSteps: ['personal'], fullName: 'Ada');

    await repository.saveProfile(profile);
    final loaded = await repository.loadProfile();

    expect(loaded?.fullName, 'Ada');

    await repository.clearProfile();
  });

  test('AuthenticationRepository preserves accounts across repository instances', () async {
    final database = const LocalDatabase();
    final storage = _InMemorySecureStorage();
    final repository = AuthenticationRepository(secureStorage: storage, localDatabase: database);

    await repository.signUp(
      email: 'ada@example.com',
      password: 'password123',
      displayName: 'Ada',
    );

    final secondRepository = AuthenticationRepository(secureStorage: _InMemorySecureStorage(), localDatabase: database);
    final session = await secondRepository.signIn(email: 'ada@example.com', password: 'password123');

    expect(session.email, 'ada@example.com');
  });

  test('LocalDatabase stores and loads string values across instances', () async {
    const database = LocalDatabase();
    await database.writeString('recovery_test_value', 'persisted');

    const reloadedDatabase = LocalDatabase();
    final value = await reloadedDatabase.readString('recovery_test_value');

    expect(value, 'persisted');
  });

  test('WorkRepository saves and loads sessions locally', () async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/work_sessions.json');
    if (await file.exists()) {
      await file.delete();
    }

    final repository = WorkRepository();
    final session = WorkSession(
      id: '1',
      workDate: '2026-07-23',
      startTime: '09:00',
      endTime: '17:00',
      shiftType: 'Day Shift',
      questionsCompleted: 12,
      callsHandled: 4,
      chatsHandled: 7,
      breakDuration: 30,
      focusRating: 8,
      stressRating: 3,
      energyRating: 7,
      notes: 'Focus block',
      totalHours: 7.5,
      productiveHours: 6.0,
      callsPercentage: 35.0,
      chatsPercentage: 65.0,
      questionsPerHour: 1.6,
      weeklyAverage: 10.0,
      monthlyAverage: 9.0,
    );

    await repository.saveSession(session);
    final sessions = await repository.loadSessions();

    expect(sessions.single.id, '1');
    await repository.deleteSession('1');
  });
}

class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<String?> read({AndroidOptions? aOptions, AppleOptions? iOptions, required String key, LinuxOptions? lOptions, AppleOptions? mOptions, WindowsOptions? wOptions, WebOptions? webOptions}) async => _values[key];

  @override
  Future<void> write({AndroidOptions? aOptions, AppleOptions? iOptions, required String key, LinuxOptions? lOptions, AppleOptions? mOptions, required String? value, WindowsOptions? wOptions, WebOptions? webOptions}) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<void> delete({AndroidOptions? aOptions, AppleOptions? iOptions, required String key, LinuxOptions? lOptions, AppleOptions? mOptions, WindowsOptions? wOptions, WebOptions? webOptions}) async => _values.remove(key);

  @override
  Future<void> deleteAll({AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, List<String>? keys, WindowsOptions? wOptions, WebOptions? webOptions}) async {
    if (keys == null) {
      _values.clear();
      return;
    }
    for (final key in keys) {
      _values.remove(key);
    }
  }
}
