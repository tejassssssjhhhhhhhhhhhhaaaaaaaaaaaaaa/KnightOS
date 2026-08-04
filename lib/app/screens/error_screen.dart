import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design_system/design_constants.dart';
import '../widgets/knight_page_scaffold.dart';
import '../../core/router/app_routes.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({this.error, super.key});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'System Error',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: DesignColors.error,
                size: 64,
              ),
              const SizedBox(height: 32),
              Text(
                'A NAVIGATION ERROR OCCURRED',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                error?.toString() ?? 'The requested module could not be reached.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home_rounded),
                label: const Text('RETURN TO COMMAND CENTER'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
