import 'package:flutter/material.dart';
import '../design_constants.dart';
import 'knight_button.dart';
import 'entrance_fader.dart';

class KnightLoadingState extends StatelessWidget {
  const KnightLoadingState({this.message = 'Synthesizing...', super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: DesignSpacing.l),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white38,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class KnightErrorState extends StatelessWidget {
  const KnightErrorState({required this.error, this.onRetry, super.key});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EntranceFader(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(DesignSpacing.l),
                decoration: BoxDecoration(
                  color: DesignColors.health.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: DesignIconSize.xl,
                  color: DesignColors.health,
                ),
              ),
              const SizedBox(height: DesignSpacing.xl),
              Text(
                'Cognitive Interruption',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: DesignSpacing.m),
              Text(
                error,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: DesignSpacing.xxl),
                KnightPrimaryButton(
                  label: 'Retry Synchronization',
                  onPressed: onRetry!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KnightEmptyState extends StatelessWidget {
  const KnightEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return EntranceFader(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: DesignIconSize.xl, color: Colors.white10),
              const SizedBox(height: DesignSpacing.xl),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: DesignSpacing.m),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: DesignSpacing.xxl),
                KnightSecondaryButton(
                  label: actionLabel!,
                  onPressed: onAction!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
