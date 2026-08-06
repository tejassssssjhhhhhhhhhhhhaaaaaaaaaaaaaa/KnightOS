import 'package:flutter/material.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../domain/finance_advisor_models.dart';

class AdvisorChatBubble extends StatelessWidget {
  const AdvisorChatBubble({super.key, required this.message});
  final AdvisorMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blueAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: Radius.circular(message.isUser ? 24 : 0),
                bottomRight: Radius.circular(message.isUser ? 0 : 24),
              ),
              border: Border.all(
                color: message.isUser ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white10,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
                ),
                if (!message.isUser && message.response != null) ...[
                  const SizedBox(height: 20),
                  _AdvisorExplainability(response: message.response!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvisorExplainability extends StatelessWidget {
  const _AdvisorExplainability({required this.response});
  final AdvisorResponse response;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white10),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.verified_user_rounded, size: 12, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'EVIDENCE: ${response.evidence}',
                style: KnightTokens.label.copyWith(fontSize: 8, color: Colors.greenAccent),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.psychology_rounded, size: 12, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'REASONING: ${response.reasoning}',
                style: const TextStyle(fontSize: 9, color: Colors.white24),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'CONFIDENCE: ${(response.confidence * 100).toInt()}%',
          style: const TextStyle(fontSize: 8, color: Colors.white10),
        ),
      ],
    );
  }
}
