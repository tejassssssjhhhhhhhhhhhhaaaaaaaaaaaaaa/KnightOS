import '../../domain/intelligence_models.dart';
import 'sleep_intelligence.dart';
import 'fitness_intelligence.dart';
import 'nutrition_intelligence.dart';
import 'medication_intelligence.dart';

class HealthInsightEngine {
  const HealthInsightEngine({
    required this.sleep,
    required this.fitness,
    required this.nutrition,
    required this.medication,
  });

  final SleepIntelligence sleep;
  final FitnessIntelligence fitness;
  final NutritionIntelligence nutrition;
  final MedicationIntelligence medication;

  Future<List<IntelligenceResult>> generateInsights() async {
    final List<IntelligenceResult> all = [];

    all.addAll(await sleep.getInsights());
    all.addAll(await fitness.getInsights());
    all.addAll(await nutrition.getInsights());
    all.addAll(await medication.getInsights());

    return all;
  }
}
