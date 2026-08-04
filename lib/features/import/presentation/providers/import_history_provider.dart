import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/integration_providers.dart';
import '../../../../core/domain/entities/evidence.dart';

final importHistoryProvider = FutureProvider<List<Evidence>>((ref) async {
  final repository = ref.watch(evidenceRepositoryProvider);
  final allEvidence = await repository.getAll();
  
  // Filter for manual imports
  return allEvidence.where((e) => e.extractionData['source_connector'] == 'knight.manual_import').toList();
});
