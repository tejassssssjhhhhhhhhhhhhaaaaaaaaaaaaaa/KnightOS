import 'package:drift/drift.dart';
import '../knight_table.dart';
import '../utils/type_converters.dart';

@DataClassName('UserProfileTableData')
class UserProfileTable extends KnightTable {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get role => text().withDefault(const Constant(''))();
  TextColumn get focusArea => text().withDefault(const Constant('Focus'))();
  TextColumn get workStyle => text().withDefault(const Constant('Deep work'))();
  TextColumn get healthGoal => text().withDefault(const Constant('Sleep'))();
  TextColumn get financeGoal =>
      text().withDefault(const Constant('Save more'))();
  TextColumn get goalText => text().withDefault(const Constant(''))();
  TextColumn get aiTone => text().withDefault(const Constant('Balanced'))();
  TextColumn get aiDepth => text().withDefault(const Constant('Medium'))();

  TextColumn get completedSteps => text().map(const StringListConverter())();

  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get preferredName => text().withDefault(const Constant(''))();
  TextColumn get dateOfBirth => text().withDefault(const Constant(''))();
  TextColumn get gender => text().withDefault(const Constant(''))();
  TextColumn get height => text().withDefault(const Constant(''))();
  TextColumn get weight => text().withDefault(const Constant(''))();
  TextColumn get country => text().withDefault(const Constant(''))();
  TextColumn get timeZone => text().withDefault(const Constant(''))();

  TextColumn get occupation => text().withDefault(const Constant(''))();
  TextColumn get company => text().withDefault(const Constant(''))();
  TextColumn get workType => text().withDefault(const Constant(''))();
  TextColumn get shiftType => text().withDefault(const Constant(''))();
  TextColumn get workHours => text().withDefault(const Constant(''))();

  TextColumn get sleepGoal => text().withDefault(const Constant(''))();
  TextColumn get waterGoal => text().withDefault(const Constant(''))();
  TextColumn get exerciseFrequency => text().withDefault(const Constant(''))();
  TextColumn get fitnessLevel => text().withDefault(const Constant(''))();
  TextColumn get healthGoals => text().map(const StringListConverter())();

  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get monthlyIncome => text().withDefault(const Constant(''))();
  TextColumn get monthlyBudget => text().withDefault(const Constant(''))();
  TextColumn get savingsGoal => text().withDefault(const Constant(''))();
  TextColumn get financialPriorities =>
      text().map(const StringListConverter())();

  TextColumn get lifeGoals => text().withDefault(const Constant(''))();
  TextColumn get learningGoals => text().withDefault(const Constant(''))();
  TextColumn get focusAreas => text().withDefault(const Constant(''))();
  TextColumn get reminderPreference => text().withDefault(const Constant(''))();

  TextColumn get aiPersonality =>
      text().withDefault(const Constant('Professional'))();
  TextColumn get notificationPreference =>
      text().withDefault(const Constant(''))();
  TextColumn get themePreference => text().withDefault(const Constant(''))();
  TextColumn get privacyPreference => text().withDefault(const Constant(''))();
}
