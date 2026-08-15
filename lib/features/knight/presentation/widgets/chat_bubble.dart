import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../domain/knight_message.dart';
import '../../presentation/knight_controller.dart';
import '../../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../../core/intelligence/domain/knight_memory.dart';
import 'verification_bubble.dart';
import 'evidence_bubble.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({required this.message, super.key});

  final KnightMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUser = message.role == KnightMessageRole.user;

    // Check for Verification Metadata
    if (message.metadata['type'] == 'verification') {
      final memoryId = message.metadata['memoryId'] as String;
      return FutureBuilder<KnightMemory?>(
        future: ref.read(memoryEngineProvider).getLatest(memoryId),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return VerificationBubble(
            memory: snapshot.data!,
            onConfirm: () =>
                ref.read(knightProvider.notifier).confirmKnowledge(memoryId),
            onReject: () =>
                ref.read(knightProvider.notifier).rejectKnowledge(memoryId),
            onEdit: () {},
            onLater: () {},
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) _buildAvatar(theme),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? DesignColors.accentBlue.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      topRight: const Radius.circular(24),
                      bottomLeft: Radius.circular(isUser ? 24 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 24),
                    ),
                    border: Border.all(
                      color: isUser
                          ? DesignColors.accentBlue.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isUser) _buildAvatar(theme),
            ],
          ),
          if (message.metadata.containsKey('evidence'))
            Padding(
              padding: EdgeInsets.only(left: isUser ? 0 : 52, right: isUser ? 52 : 0),
              child: EvidenceBubble(evidence: message.metadata['evidence'] as List<dynamic>),
            ),
          if (message.metadata.containsKey('navigateTo'))
            _buildNavigationAction(context, message.metadata['navigateTo']),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isUser ? 0 : 52,
              right: isUser ? 52 : 0,
            ),
            child: Text(
              DateFormat.jm().format(message.timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationAction(BuildContext context, String? route) {
    if (route == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 52),
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push(route);
        },
        icon: const Icon(Icons.open_in_new_rounded, size: 14),
        label: const Text('OPEN SECTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.accentBlue,
          side: const BorderSide(color: DesignColors.accentBlue, width: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final isUser = message.role == KnightMessageRole.user;
    return CircleAvatar(
      radius: 18,
      backgroundColor: isUser
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.secondaryContainer,
      child: Icon(
        isUser ? Icons.person_outline_rounded : Icons.auto_awesome,
        size: 18,
        color: isUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
