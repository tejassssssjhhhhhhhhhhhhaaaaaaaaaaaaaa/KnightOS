import 'package:flutter/material.dart';
import '../../../../core/intelligence/providers/journey_provider.dart';

class ErrorDetailView extends StatelessWidget {
  const ErrorDetailView({required this.stage, super.key});
  final JourneyStage stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                '${stage.label.toUpperCase()} FAILED',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _infoSection('WHAT HAPPENED?', stage.humanExplanation),
          _infoSection('WHY DID IT HAPPEN?', stage.technicalDetail),
          _infoSection('AFFECTED DATA', 'Resource ID: ${stage.id}'),
          _infoSection('WAS ANY DATA LOST?', 'No. The original source remains untouched.'),
          _infoSection('WHAT CAN KNIGHT SAFELY DO?', 'Retry the operation or skip this record.'),
          const SizedBox(height: 32),
          const Text('TECHNICAL DETAILS', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: Text(
              _maskSensitiveInfo(stage.error ?? 'Unknown internal error.'),
              style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('DISMISS'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // Implement retry logic if applicable
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text('RETRY'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  String _maskSensitiveInfo(String input) {
    // Basic masking for common sensitive patterns
    final tokenRegex = RegExp(r'(?:access_token|refresh_token|password|secret|key|bearer)\s*[:=]\s*[^\s,]+', caseSensitive: false);
    return input.replaceAllMapped(tokenRegex, (match) {
      final parts = match.group(0)!.split(RegExp(r'[:=]'));
      if (parts.length == 2) {
        return '${parts[0]}: [MASKED]';
      }
      return '[MASKED]';
    });
  }
}
