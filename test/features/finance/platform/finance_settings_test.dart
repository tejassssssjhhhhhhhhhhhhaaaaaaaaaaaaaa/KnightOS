import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:knight_os/features/finance/platform/sync/finance_settings_service.dart';
import 'package:knight_os/features/finance/domain/finance_settings_models.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late FinanceSettingsService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = FinanceSettingsService(mockPrefs);
  });

  group('FinanceSettingsService', () {
    test('loadSettings returns defaults when no prefs exist', () async {
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);

      final settings = await service.loadSettings();

      expect(settings.isSmartSyncEnabled, true);
      expect(settings.syncFrequency, 'daily');
      expect(settings.isDeveloperMode, false);
    });

    test('saveSettings persists all fields', () async {
      final settings = FinanceSettings(
        isSmartSyncEnabled: false,
        syncFrequency: 'weekly',
        isDeveloperMode: true,
      );

      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);

      await service.saveSettings(settings);

      verify(() => mockPrefs.setBool('knight_finance_smart_sync', false)).called(1);
      verify(() => mockPrefs.setString('knight_finance_sync_freq', 'weekly')).called(1);
      verify(() => mockPrefs.setBool('knight_finance_dev_mode', true)).called(1);
    });
  });
}
