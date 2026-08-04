import 'dart:io';
import '../../internal/storage/drift/knight_database.dart';
import 'document_hash_service.dart';

class VerificationReport {
  final int totalFiles;
  final int supportedFiles;
  final int unsupportedFiles;
  final int importedFiles;
  final int missingFiles;
  final int duplicateFiles;
  final double coveragePercentage;
  final String parserHealth;
  final String aiIndexStatus;
  final String graphStatus;
  final DateTime lastScan;
  final List<String> missingRecommendations;

  VerificationReport({
    required this.totalFiles,
    required this.supportedFiles,
    required this.unsupportedFiles,
    required this.importedFiles,
    required this.missingFiles,
    required this.duplicateFiles,
    required this.coveragePercentage,
    this.parserHealth = 'Optimal',
    this.aiIndexStatus = 'Synced',
    this.graphStatus = 'Woven',
    required this.lastScan,
    required this.missingRecommendations,
  });
}

class DatasetVerificationService {
  DatasetVerificationService({
    required this.db,
    required this.hashService,
  });

  final KnightDatabase db;
  final DocumentHashService hashService;

  final Set<String> _supportedExtensions = {'.pdf', '.json', '.csv', '.txt', '.jpg', '.png', '.md'};

  Future<VerificationReport> runVerification(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return VerificationReport(
        totalFiles: 0,
        supportedFiles: 0,
        unsupportedFiles: 0,
        importedFiles: 0,
        missingFiles: 0,
        duplicateFiles: 0,
        coveragePercentage: 0,
        lastScan: DateTime.now(),
        missingRecommendations: ['Authoritative directory not found'],
      );
    }

    final allFiles = dir.listSync(recursive: true).whereType<File>().toList();
    int total = allFiles.length;
    int supported = 0;
    int unsupported = 0;
    int imported = 0;
    int duplicates = 0;
    
    final List<String> missingFilesPaths = [];
    final Set<String> seenHashes = {};

    for (final file in allFiles) {
      final ext = '.${file.path.split('.').last.toLowerCase()}';
      if (_supportedExtensions.contains(ext)) {
        supported++;
        final hash = await hashService.calculateHash(file);
        
        if (seenHashes.contains(hash)) {
          duplicates++;
        }
        seenHashes.add(hash);

        final existing = await db.importDao.getByHash(hash);
        if (existing != null) {
          imported++;
        } else {
          missingFilesPaths.add(file.path);
        }
      } else {
        unsupported++;
      }
    }

    final coverage = supported > 0 ? (imported / supported) * 100 : 0.0;
    
    // Recommendations
    final recs = <String>[];
    if (missingFilesPaths.isNotEmpty) {
      recs.add('Found ${missingFilesPaths.length} unindexed supported files. Run Re-index.');
    }
    if (unsupported > 0) {
      recs.add('Found $unsupported files with unrecognized formats.');
    }
    if (duplicates > 0) {
      recs.add('Found $duplicates duplicate files in the vault. Cleanup recommended.');
    }

    return VerificationReport(
      totalFiles: total,
      supportedFiles: supported,
      unsupportedFiles: unsupported,
      importedFiles: imported,
      missingFiles: supported - imported,
      duplicateFiles: duplicates,
      coveragePercentage: coverage,
      lastScan: DateTime.now(),
      missingRecommendations: recs,
    );
  }
}
