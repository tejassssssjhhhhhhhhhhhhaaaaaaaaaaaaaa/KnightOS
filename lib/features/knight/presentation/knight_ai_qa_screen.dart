import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/widgets/knight_page_scaffold.dart';
import '../../../core/design_system/design_constants.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/qa/knight_ai_test_suite.dart';

class KnightAiQaScreen extends ConsumerStatefulWidget {
  const KnightAiQaScreen({super.key});

  @override
  ConsumerState<KnightAiQaScreen> createState() => _KnightAiQaScreenState();
}

class _KnightAiQaScreenState extends ConsumerState<KnightAiQaScreen> {
  List<QAResult>? _results;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'AI Intelligence QA',
      showBackButton: true,
      body: Column(
        children: [
          _buildHero(),
          Expanded(
            child: _results == null 
              ? _buildWelcome() 
              : _buildResultsList(),
          ),
          _buildActionArea(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: DesignColors.accentBlue.withValues(alpha: 0.05),
        border: const Border(bottom: BorderSide(color: DesignColors.white05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AUTONOMOUS VALIDATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0, color: DesignColors.accentBlue)),
          const SizedBox(height: 16),
          const Text('Intelligence QA Suite', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Verifying reasoning accuracy and knowledge graph usage across 20+ scenarios.', style: TextStyle(fontSize: 13, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_outlined, size: 64, color: Colors.white10),
          SizedBox(height: 24),
          Text('No tests run yet.', style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignSpacing.m),
      itemCount: _results!.length,
      itemBuilder: (context, i) {
        final r = _results![i];
        return Card(
          color: DesignColors.surface,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      r.passed ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                      color: r.passed ? DesignColors.success : DesignColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(r.query, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(r.response, style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4)),
                ),
                if (r.feedback != null) ...[
                  const SizedBox(height: 12),
                  Text('TRACE: ${r.feedback}', style: const TextStyle(fontSize: 10, color: Colors.white24, fontFamily: 'monospace')),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: DesignColors.surfaceHigh,
        border: Border(top: BorderSide(color: DesignColors.white05)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isRunning ? null : _runTests,
            icon: _isRunning 
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Icon(Icons.play_arrow_rounded),
            label: Text(_isRunning ? 'RUNNING SUITE...' : 'EXECUTE FULL VALIDATION'),
          ),
        ),
      ),
    );
  }

  Future<void> _runTests() async {
    setState(() {
      _isRunning = true;
      _results = null;
    });

    try {
      final suite = ref.read(knightAiTestSuiteProvider);
      final results = await suite.runFullSuite();
      setState(() {
        _results = results;
        _isRunning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRunning = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('QA Suite Failed: $e')));
    }
  }
}
