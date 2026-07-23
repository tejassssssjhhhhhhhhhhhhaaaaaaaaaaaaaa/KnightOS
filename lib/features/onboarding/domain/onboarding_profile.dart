class UserProfile {
  const UserProfile({
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

  Map<String, Object> toJson() {
    return {
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
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      focusArea: json['focusArea'] as String? ?? 'Focus',
      workStyle: json['workStyle'] as String? ?? 'Deep work',
      healthGoal: json['healthGoal'] as String? ?? 'Sleep',
      financeGoal: json['financeGoal'] as String? ?? 'Save more',
      goalText: json['goalText'] as String? ?? '',
      aiTone: json['aiTone'] as String? ?? 'Balanced',
      aiDepth: json['aiDepth'] as String? ?? 'Medium',
      completedSteps: List<String>.from(json['completedSteps'] as List? ?? const []),
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
      financialPriorities: List<String>.from(json['financialPriorities'] as List? ?? const []),
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
}

typedef OnboardingProfile = UserProfile;
