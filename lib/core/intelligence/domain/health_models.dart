import 'package:flutter/foundation.dart';
import 'knight_memory.dart';
import 'cognitive_models.dart';

/// Categories for health-specific data types.
enum HealthDataType {
  profile,
  vital,
  sleep,
  hydration,
  nutrition,
  exercise,
  medication,
  medicalRecord,
  symptom,
}

/// User's core health profile.
@immutable
class HealthProfile {
  const HealthProfile({
    required this.height,
    required this.weight,
    required this.bmi,
    this.bloodGroup,
    this.dob,
    this.gender,
    this.emergencyContact,
  });

  final double height; // in cm
  final double weight; // in kg
  final double bmi;
  final String? bloodGroup;
  final DateTime? dob;
  final String? gender;
  final String? emergencyContact;

  Map<String, dynamic> toJson() => {
    'height': height,
    'weight': weight,
    'bmi': bmi,
    'bloodGroup': bloodGroup,
    'dob': dob?.toIso8601String(),
    'gender': gender,
    'emergencyContact': emergencyContact,
  };

  factory HealthProfile.fromJson(Map<String, dynamic> json) => HealthProfile(
    height: (json['height'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    bmi: (json['bmi'] as num).toDouble(),
    bloodGroup: json['bloodGroup'] as String?,
    dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
    gender: json['gender'] as String?,
    emergencyContact: json['emergencyContact'] as String?,
  );
}

/// Physiological vitals record.
enum VitalType { bp, hr, bloodSugar, oxygen, temperature }

@immutable
class VitalRecord {
  const VitalRecord({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  final VitalType type;
  final double value;
  final String unit;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'value': value,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
  };

  factory VitalRecord.fromJson(Map<String, dynamic> json) => VitalRecord(
    type: VitalType.values.byName(json['type'] as String),
    value: (json['value'] as num).toDouble(),
    unit: json['unit'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

/// Sleep session record.
@immutable
class SleepRecord {
  const SleepRecord({
    required this.start,
    required this.end,
    required this.durationMinutes,
    required this.quality, // 0.0 to 1.0
    this.isNightShift = false,
  });

  final DateTime start;
  final DateTime end;
  final int durationMinutes;
  final double quality;
  final bool isNightShift;

  Map<String, dynamic> toJson() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'durationMinutes': durationMinutes,
    'quality': quality,
    'isNightShift': isNightShift,
  };

  factory SleepRecord.fromJson(Map<String, dynamic> json) => SleepRecord(
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    durationMinutes: json['durationMinutes'] as int,
    quality: (json['quality'] as num).toDouble(),
    isNightShift: json['isNightShift'] as bool? ?? false,
  );
}

/// Daily hydration tracking.
@immutable
class HydrationRecord {
  const HydrationRecord({
    required this.amountMl,
    required this.dailyGoalMl,
    required this.timestamp,
  });

  final int amountMl;
  final int dailyGoalMl;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'amountMl': amountMl,
    'dailyGoalMl': dailyGoalMl,
    'timestamp': timestamp.toIso8601String(),
  };

  factory HydrationRecord.fromJson(Map<String, dynamic> json) =>
      HydrationRecord(
        amountMl: json['amountMl'] as int,
        dailyGoalMl: json['dailyGoalMl'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Nutrition and meal record.
@immutable
class NutritionRecord {
  const NutritionRecord({
    required this.mealName,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.timestamp,
  });

  final String mealName;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'mealName': mealName,
    'calories': calories,
    'proteinGrams': proteinGrams,
    'carbsGrams': carbsGrams,
    'fatGrams': fatGrams,
    'timestamp': timestamp.toIso8601String(),
  };

  factory NutritionRecord.fromJson(Map<String, dynamic> json) =>
      NutritionRecord(
        mealName: json['mealName'] as String,
        calories: json['calories'] as int,
        proteinGrams: (json['proteinGrams'] as num).toDouble(),
        carbsGrams: (json['carbsGrams'] as num).toDouble(),
        fatGrams: (json['fatGrams'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Physical exercise session.
@immutable
class ExerciseRecord {
  const ExerciseRecord({
    required this.workoutType,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.intensity = 0.5, // 0.0 to 1.0
    this.isStrength = false,
    this.isCardio = false,
    this.isMobility = false,
    required this.timestamp,
  });

  final String workoutType;
  final int durationMinutes;
  final int caloriesBurned;
  final double intensity;
  final bool isStrength;
  final bool isCardio;
  final bool isMobility;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'workoutType': workoutType,
    'durationMinutes': durationMinutes,
    'caloriesBurned': caloriesBurned,
    'intensity': intensity,
    'isStrength': isStrength,
    'isCardio': isCardio,
    'isMobility': isMobility,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) => ExerciseRecord(
    workoutType: json['workoutType'] as String,
    durationMinutes: json['durationMinutes'] as int,
    caloriesBurned: json['caloriesBurned'] as int,
    intensity: (json['intensity'] as num? ?? 0.5).toDouble(),
    isStrength: json['isStrength'] as bool? ?? false,
    isCardio: json['isCardio'] as bool? ?? false,
    isMobility: json['isMobility'] as bool? ?? false,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

/// Medication adherence record.
@immutable
class MedicationRecord {
  const MedicationRecord({
    required this.medicineName,
    required this.dosage,
    required this.scheduledAt,
    this.takenAt,
    required this.isAdhered,
  });

  final String medicineName;
  final String dosage;
  final DateTime scheduledAt;
  final DateTime? takenAt;
  final bool isAdhered;

  Map<String, dynamic> toJson() => {
    'medicineName': medicineName,
    'dosage': dosage,
    'scheduledAt': scheduledAt.toIso8601String(),
    'takenAt': takenAt?.toIso8601String(),
    'isAdhered': isAdhered,
  };

  factory MedicationRecord.fromJson(Map<String, dynamic> json) =>
      MedicationRecord(
        medicineName: json['medicineName'] as String,
        dosage: json['dosage'] as String,
        scheduledAt: DateTime.parse(json['scheduledAt'] as String),
        takenAt: json['takenAt'] != null
            ? DateTime.parse(json['takenAt'] as String)
            : null,
        isAdhered: json['isAdhered'] as bool,
      );
}

/// Official medical history record.
enum MedicalRecordType { visit, prescription, diagnosis, lab, vaccine, allergy }

@immutable
class MedicalRecord {
  const MedicalRecord({
    required this.type,
    required this.title,
    required this.details,
    required this.date,
    this.provider,
  });

  final MedicalRecordType type;
  final String title;
  final String details;
  final DateTime date;
  final String? provider;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'title': title,
    'details': details,
    'date': date.toIso8601String(),
    'provider': provider,
  };

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
    type: MedicalRecordType.values.byName(json['type'] as String),
    title: json['title'] as String,
    details: json['details'] as String,
    date: DateTime.parse(json['date'] as String),
    provider: json['provider'] as String?,
  );
}

/// User reported symptom.
@immutable
class SymptomRecord {
  const SymptomRecord({
    required this.symptom,
    required this.severity, // 1 to 10
    required this.timestamp,
    this.notes,
  });

  final String symptom;
  final int severity;
  final DateTime timestamp;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'symptom': symptom,
    'severity': severity,
    'timestamp': timestamp.toIso8601String(),
    'notes': notes,
  };

  factory SymptomRecord.fromJson(Map<String, dynamic> json) => SymptomRecord(
    symptom: json['symptom'] as String,
    severity: json['severity'] as int,
    timestamp: DateTime.parse(json['timestamp'] as String),
    notes: json['notes'] as String?,
  );
}

/// Represents a health score with its associated reasoning trace.
@immutable
class HealthScoreResult {
  const HealthScoreResult({
    required this.score,
    required this.trace,
  });

  final int score;
  final ReasoningTrace trace;

  Map<String, dynamic> toJson() => {
    'score': score,
    'trace_confidence': trace.confidence,
  };

  factory HealthScoreResult.empty() => HealthScoreResult(
    score: 0,
    trace: ReasoningTrace(
      intent: KnightIntent.analysis,
      memoriesUsed: [],
      rulesApplied: [],
      goalsConsidered: [],
      thoughtChain: ['Initial state'],
      confidence: 0.0,
    ),
  );
}

/// Overall health scores for a specific period.
@immutable
class HealthScores {
  const HealthScores({
    required this.dailyScore,
    required this.recoveryScore,
    required this.sleepScore,
    required this.stressScore,
    required this.hydrationScore,
    required this.nutritionScore,
    required this.workoutScore,
    required this.readinessScore,
    required this.timestamp,
  });

  final HealthScoreResult dailyScore;
  final HealthScoreResult recoveryScore;
  final HealthScoreResult sleepScore;
  final HealthScoreResult stressScore;
  final HealthScoreResult hydrationScore;
  final HealthScoreResult nutritionScore;
  final HealthScoreResult workoutScore;
  final HealthScoreResult readinessScore;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'dailyScore': dailyScore.score,
    'recoveryScore': recoveryScore.score,
    'sleepScore': sleepScore.score,
    'stressScore': stressScore.score,
    'hydrationScore': hydrationScore.score,
    'nutritionScore': nutritionScore.score,
    'workoutScore': workoutScore.score,
    'readinessScore': readinessScore.score,
    'timestamp': timestamp.toIso8601String(),
  };

  factory HealthScores.fromJson(Map<String, dynamic> json) => HealthScores(
    dailyScore: HealthScoreResult(score: json['dailyScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    recoveryScore: HealthScoreResult(score: json['recoveryScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    sleepScore: HealthScoreResult(score: json['sleepScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    stressScore: HealthScoreResult(score: json['stressScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    hydrationScore: HealthScoreResult(score: json['hydrationScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    nutritionScore: HealthScoreResult(score: json['nutritionScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    workoutScore: HealthScoreResult(score: json['workoutScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    readinessScore: HealthScoreResult(score: json['readinessScore'] as int, trace: ReasoningTrace(intent: KnightIntent.analysis, memoriesUsed: [], rulesApplied: [], goalsConsidered: [], thoughtChain: [], confidence: 1.0)),
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

/// Extension to bridge KnightMemory with Health Models.
extension HealthMemoryExtension on KnightMemory {
  HealthDataType? get healthDataType {
    final typeStr = content['healthDataType'] as String?;
    if (typeStr == null) return null;
    return HealthDataType.values.byName(typeStr);
  }

  HealthProfile? toHealthProfile() {
    if (healthDataType != HealthDataType.profile) return null;
    return HealthProfile.fromJson(content);
  }

  VitalRecord? toVitalRecord() {
    if (healthDataType != HealthDataType.vital) return null;
    return VitalRecord.fromJson(content);
  }

  SleepRecord? toSleepRecord() {
    if (healthDataType != HealthDataType.sleep) return null;
    return SleepRecord.fromJson(content);
  }

  HydrationRecord? toHydrationRecord() {
    if (healthDataType != HealthDataType.hydration) return null;
    return HydrationRecord.fromJson(content);
  }

  NutritionRecord? toNutritionRecord() {
    if (healthDataType != HealthDataType.nutrition) return null;
    return NutritionRecord.fromJson(content);
  }

  ExerciseRecord? toExerciseRecord() {
    if (healthDataType != HealthDataType.exercise) return null;
    return ExerciseRecord.fromJson(content);
  }

  MedicationRecord? toMedicationRecord() {
    if (healthDataType != HealthDataType.medication) return null;
    return MedicationRecord.fromJson(content);
  }

  MedicalRecord? toMedicalRecord() {
    if (healthDataType != HealthDataType.medicalRecord) return null;
    return MedicalRecord.fromJson(content);
  }

  SymptomRecord? toSymptomRecord() {
    if (healthDataType != HealthDataType.symptom) return null;
    return SymptomRecord.fromJson(content);
  }
}
