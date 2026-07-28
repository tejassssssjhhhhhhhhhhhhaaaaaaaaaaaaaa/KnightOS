import '../../../core/platform/storage/knight_entity.dart';

class UserProfile extends KnightEntity {
  UserProfile({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.version,
    super.isDeleted,
    super.deletedAt,
    super.syncStatus,
    super.deviceId,
    required this.completedSteps,
    this.name = '',
    this.role = '',
    this.focusArea = 'Focus',
    this.workStyle = 'Deep work',
    this.healthGoal = 'Sleep',
    this.financeGoal = 'Save more',
    this.goalText = '',
    this.aiTone = 'Balanced',
    this.aiDepth = 'Medium',
    this.fullName = '',
    this.preferredName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.height = '',
    this.weight = '',
    this.country = '',
    this.timeZone = '',
    this.occupation = '',
    this.company = '',
    this.workType = '',
    this.shiftType = '',
    this.workHours = '',
    this.sleepGoal = '',
    this.waterGoal = '',
    this.exerciseFrequency = '',
    this.fitnessLevel = '',
    this.healthGoals = const [],
    this.currency = 'INR',
    this.monthlyIncome = '',
    this.monthlyBudget = '',
    this.savingsGoal = '',
    this.financialPriorities = const [],
    this.lifeGoals = '',
    this.learningGoals = '',
    this.focusAreas = '',
    this.reminderPreference = '',
    this.aiPersonality = 'Professional',
    this.notificationPreference = '',
    this.themePreference = '',
    this.privacyPreference = '',
  });

  final String name;
  final String role;
  final String focusArea;
  final String workStyle;
  final String healthGoal;
  final String financeGoal;
  final String goalText;
  final String aiTone;
  final String aiDepth;
  final List<String> completedSteps;

  final String fullName;
  final String preferredName;
  final String dateOfBirth;
  final String gender;
  final String height;
  final String weight;
  final String country;
  final String timeZone;

  final String occupation;
  final String company;
  final String workType;
  final String shiftType;
  final String workHours;

  final String sleepGoal;
  final String waterGoal;
  final String exerciseFrequency;
  final String fitnessLevel;
  final List<String> healthGoals;

  final String currency;
  final String monthlyIncome;
  final String monthlyBudget;
  final String savingsGoal;
  final List<String> financialPriorities;

  final String lifeGoals;
  final String learningGoals;
  final String focusAreas;
  final String reminderPreference;

  final String aiPersonality;
  final String notificationPreference;
  final String themePreference;
  final String privacyPreference;

  bool get isCompleted => completedSteps.length >= 6;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'deviceId': deviceId,
      'name': name,
      'role': role,
      'focusArea': focusArea,
      'workStyle': workStyle,
      'healthGoal': healthGoal,
      'financeGoal': financeGoal,
      'goalText': goalText,
      'aiTone': aiTone,
      'aiDepth': aiDepth,
      'completedSteps': completedSteps,
      'fullName': fullName,
      'preferredName': preferredName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'country': country,
      'timeZone': timeZone,
      'occupation': occupation,
      'company': company,
      'workType': workType,
      'shiftType': shiftType,
      'workHours': workHours,
      'sleepGoal': sleepGoal,
      'waterGoal': waterGoal,
      'exerciseFrequency': exerciseFrequency,
      'fitnessLevel': fitnessLevel,
      'healthGoals': healthGoals,
      'currency': currency,
      'monthlyIncome': monthlyIncome,
      'monthlyBudget': monthlyBudget,
      'savingsGoal': savingsGoal,
      'financialPriorities': financialPriorities,
      'lifeGoals': lifeGoals,
      'learningGoals': learningGoals,
      'focusAreas': focusAreas,
      'reminderPreference': reminderPreference,
      'aiPersonality': aiPersonality,
      'notificationPreference': notificationPreference,
      'themePreference': themePreference,
      'privacyPreference': privacyPreference,
    };
  }

  factory UserProfile.fromJson(Map<String, Object?> json) {
    return UserProfile(
      id: json['id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      version: json['version'] as int? ?? 1,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'pending',
      deviceId: json['deviceId'] as String?,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      focusArea: json['focusArea'] as String? ?? 'Focus',
      workStyle: json['workStyle'] as String? ?? 'Deep work',
      healthGoal: json['healthGoal'] as String? ?? 'Sleep',
      financeGoal: json['financeGoal'] as String? ?? 'Save more',
      goalText: json['goalText'] as String? ?? '',
      aiTone: json['aiTone'] as String? ?? 'Balanced',
      aiDepth: json['aiDepth'] as String? ?? 'Medium',
      completedSteps: List<String>.from(
        json['completedSteps'] as List? ?? const [],
      ),
      fullName: json['fullName'] as String? ?? '',
      preferredName: json['preferredName'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      country: json['country'] as String? ?? '',
      timeZone: json['timeZone'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      company: json['company'] as String? ?? '',
      workType: json['workType'] as String? ?? '',
      shiftType: json['shiftType'] as String? ?? '',
      workHours: json['workHours'] as String? ?? '',
      sleepGoal: json['sleepGoal'] as String? ?? '',
      waterGoal: json['waterGoal'] as String? ?? '',
      exerciseFrequency: json['exerciseFrequency'] as String? ?? '',
      fitnessLevel: json['fitnessLevel'] as String? ?? '',
      healthGoals: List<String>.from(json['healthGoals'] as List? ?? const []),
      currency: json['currency'] as String? ?? 'INR',
      monthlyIncome: json['monthlyIncome'] as String? ?? '',
      monthlyBudget: json['monthlyBudget'] as String? ?? '',
      savingsGoal: json['savingsGoal'] as String? ?? '',
      financialPriorities: List<String>.from(
        json['financialPriorities'] as List? ?? const [],
      ),
      lifeGoals: json['lifeGoals'] as String? ?? '',
      learningGoals: json['learningGoals'] as String? ?? '',
      focusAreas: json['focusAreas'] as String? ?? '',
      reminderPreference: json['reminderPreference'] as String? ?? '',
      aiPersonality: json['aiPersonality'] as String? ?? 'Professional',
      notificationPreference: json['notificationPreference'] as String? ?? '',
      themePreference: json['themePreference'] as String? ?? '',
      privacyPreference: json['privacyPreference'] as String? ?? '',
    );
  }

  UserProfile copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    DateTime? deletedAt,
    String? syncStatus,
    String? deviceId,
    String? name,
    String? role,
    String? focusArea,
    String? workStyle,
    String? healthGoal,
    String? financeGoal,
    String? goalText,
    String? aiTone,
    String? aiDepth,
    List<String>? completedSteps,
    String? fullName,
    String? preferredName,
    String? dateOfBirth,
    String? gender,
    String? height,
    String? weight,
    String? country,
    String? timeZone,
    String? occupation,
    String? company,
    String? workType,
    String? shiftType,
    String? workHours,
    String? sleepGoal,
    String? waterGoal,
    String? exerciseFrequency,
    String? fitnessLevel,
    List<String>? healthGoals,
    String? currency,
    String? monthlyIncome,
    String? monthlyBudget,
    String? savingsGoal,
    List<String>? financialPriorities,
    String? lifeGoals,
    String? learningGoals,
    String? focusAreas,
    String? reminderPreference,
    String? aiPersonality,
    String? notificationPreference,
    String? themePreference,
    String? privacyPreference,
  }) {
    return UserProfile(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      role: role ?? this.role,
      focusArea: focusArea ?? this.focusArea,
      workStyle: workStyle ?? this.workStyle,
      healthGoal: healthGoal ?? this.healthGoal,
      financeGoal: financeGoal ?? this.financeGoal,
      goalText: goalText ?? this.goalText,
      aiTone: aiTone ?? this.aiTone,
      aiDepth: aiDepth ?? this.aiDepth,
      completedSteps: completedSteps ?? this.completedSteps,
      fullName: fullName ?? this.fullName,
      preferredName: preferredName ?? this.preferredName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      country: country ?? this.country,
      timeZone: timeZone ?? this.timeZone,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      workType: workType ?? this.workType,
      shiftType: shiftType ?? this.shiftType,
      workHours: workHours ?? this.workHours,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      waterGoal: waterGoal ?? this.waterGoal,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      healthGoals: healthGoals ?? this.healthGoals,
      currency: currency ?? this.currency,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      financialPriorities: financialPriorities ?? this.financialPriorities,
      lifeGoals: lifeGoals ?? this.lifeGoals,
      learningGoals: learningGoals ?? this.learningGoals,
      focusAreas: focusAreas ?? this.focusAreas,
      reminderPreference: reminderPreference ?? this.reminderPreference,
      aiPersonality: aiPersonality ?? this.aiPersonality,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      themePreference: themePreference ?? this.themePreference,
      privacyPreference: privacyPreference ?? this.privacyPreference,
    );
  }
}

typedef OnboardingProfile = UserProfile;
