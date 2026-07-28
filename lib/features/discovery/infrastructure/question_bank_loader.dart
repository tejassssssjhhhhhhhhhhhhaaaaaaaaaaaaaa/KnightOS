import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/discovery_models.dart';

class QuestionBankLoader {
  const QuestionBankLoader();

  Future<List<DiscoveryQuestion>> loadFromAssets() async {
    final String response = await rootBundle.loadString(
      'assets/knowledge/questions.json',
    );
    final data = await json.decode(response) as List<dynamic>;
    return data
        .map((q) => DiscoveryQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }
}
