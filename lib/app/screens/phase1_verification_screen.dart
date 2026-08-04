import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';
import '../../core/internal/utils/knight_logger.dart';

class Phase1VerificationScreen extends ConsumerWidget {
  const Phase1VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final db = ref.read(knightDatabaseProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 1 Verification')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
             KnightLogger.info('Baseline Verification Triggered');
          },
          child: const Text('Verify Baseline'),
        ),
      ),
    );
  }
}
