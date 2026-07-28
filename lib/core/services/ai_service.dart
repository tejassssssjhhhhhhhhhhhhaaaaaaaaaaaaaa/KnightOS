import 'package:flutter/material.dart';
import '../intelligence/engines/ai_provider.dart';
import '../intelligence/engines/context_engine.dart';

/// Facade for the intelligence layer in the presentation layer.
class AiService {
  AiService({required this.contextEngine, KnightAiProvider? provider})
    : provider = provider ?? MockAiProvider();

  final ContextEngine contextEngine;
  final KnightAiProvider provider;

  Future<String> getResponse(String userPrompt) async {
    final context = await contextEngine.buildActiveContext(query: userPrompt);
    return provider.chat(context: context, prompt: userPrompt);
  }

  String buildDailyInsight({required String name, required int knightScore}) {
    if (knightScore >= 80) {
      return '$name, your rhythm is strong. Protect the momentum with one focused hour before dinner.';
    }
    if (knightScore >= 60) {
      return '$name, your day is stable. A short recovery block will improve your evening clarity.';
    }
    return '$name, your energy is under pressure. Reduce overload and protect sleep tonight.';
  }

  List<String> buildRecommendations({required int knightScore}) {
    if (knightScore >= 80) {
      return const [
        'Double down on the next deep-work session.',
        'Keep notifications muted until your key milestone is complete.',
      ];
    }
    if (knightScore >= 60) {
      return const [
        'Schedule a short reset before the next meeting.',
        'Trim one low-value task from your evening plan.',
      ];
    }
    return const [
      'Protect your recovery window before late-night work.',
      'Keep your first task simple to regain control quickly.',
    ];
  }

  String buildPrediction({required int knightScore}) {
    if (knightScore >= 80) {
      return 'Tomorrow should favor high-quality execution if you maintain your current rhythm.';
    }
    if (knightScore >= 60) {
      return 'Tomorrow will likely reward a calm start and a light evening load.';
    }
    return 'Tomorrow is likely to be demanding, so recovery and planning matter most.';
  }

  Color insightColor({required int knightScore}) {
    if (knightScore >= 80) {
      return const Color(0xFF4ADE80);
    }
    if (knightScore >= 60) {
      return const Color(0xFFFFB84D);
    }
    return const Color(0xFFFF6B6B);
  }
}
