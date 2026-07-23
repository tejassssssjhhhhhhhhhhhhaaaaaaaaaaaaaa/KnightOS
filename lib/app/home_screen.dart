import 'package:flutter/material.dart';

import '../core/engines/insight_engine.dart';
import '../core/engines/knight_score_engine.dart';
import '../core/engines/prediction_engine.dart';
import '../core/engines/recommendation_engine.dart';
import '../core/services/ai_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const knightScore = 78;
    final aiService = const AiService();
    final scoreEngine = const KnightScoreEngine();
    final insightEngine = InsightEngine(aiService: aiService);
    final recommendationEngine = RecommendationEngine(aiService: aiService);
    final predictionEngine = PredictionEngine(aiService: aiService);

    final computedScore = scoreEngine.calculateScore(
      sleepScore: 72,
      workScore: 83,
      recoveryScore: 74,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KnightOS',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Good evening, Tejas',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Your systems are stabilizing. KnightOS is preparing your next best move.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today\'s Knight Score', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            '$computedScore/100',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.shield_outlined, size: 42, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('AI insight', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insightEngine.generateInsight(name: 'Tejas', knightScore: knightScore),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('Recommendations', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...recommendationEngine.generateRecommendations(knightScore: knightScore).map(
                      (recommendation) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.auto_awesome, size: 18, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(recommendation)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Prediction', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(predictionEngine.generatePrediction(knightScore: knightScore)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
