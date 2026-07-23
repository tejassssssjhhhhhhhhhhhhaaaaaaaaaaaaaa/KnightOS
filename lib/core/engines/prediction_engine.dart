import '../services/ai_service.dart';

class PredictionEngine {
  const PredictionEngine({required this.aiService});

  final AiService aiService;

  String generatePrediction({required int knightScore}) {
    return aiService.buildPrediction(knightScore: knightScore);
  }
}
