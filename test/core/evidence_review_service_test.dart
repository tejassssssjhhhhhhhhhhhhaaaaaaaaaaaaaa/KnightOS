import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/domain/entities/evidence.dart';
import 'package:knight_os/core/domain/repositories/i_evidence_repository.dart';
import 'package:knight_os/core/services/evidence_review_service.dart';
import 'package:knight_os/core/storage/privacy_vault.dart';

class MockEvidenceRepository extends Mock implements IEvidenceRepository {}

void main() {
  late EvidenceReviewService service;
  late MockEvidenceRepository mockRepository;

  setUp(() {
    mockRepository = MockEvidenceRepository();
    service = EvidenceReviewService(mockRepository);

    registerFallbackValue(Evidence(
      caid: 'any',
      originalName: 'any',
      mimeType: 'any',
      fileSize: 0,
      ingestedAt: DateTime.now(),
      storagePath: 'any',
      verificationStatus: EvidenceVerificationStatus.pending,
    ));
  });

  group('EvidenceReviewService Logic', () {
    test('updateStatus() adds audit entry and stores updated evidence', () async {
      final evidence = Evidence(
        caid: 'e1',
        originalName: 'cert.pdf',
        mimeType: 'pdf',
        fileSize: 100,
        ingestedAt: DateTime.now(),
        storagePath: 'p1',
        verificationStatus: EvidenceVerificationStatus.pending,
      );

      when(() => mockRepository.getByCaid('e1')).thenAnswer((_) async => evidence);
      when(() => mockRepository.store(any())).thenAnswer((_) async {});

      await service.updateStatus('e1', EvidenceVerificationStatus.verified, notes: 'User verified');

      final captured = verify(() => mockRepository.store(captureAny())).captured.first as Evidence;
      expect(captured.verificationStatus, EvidenceVerificationStatus.verified);
      expect(captured.auditHistory.length, 1);
      expect(captured.auditHistory.first.action, contains('STATUS_UPDATE: VERIFIED'));
      expect(captured.auditHistory.first.notes, 'User verified');
    });

    test('findPotentialDuplicates() uses heuristics (name or size+type)', () async {
      final target = Evidence(
        caid: 'target',
        originalName: 'doc.pdf',
        mimeType: 'pdf',
        fileSize: 500,
        ingestedAt: DateTime.now(),
        storagePath: 'p1',
      );

      final duplicate = Evidence(
        caid: 'dup',
        originalName: 'doc.pdf', // Same name
        mimeType: 'pdf',
        fileSize: 500,
        ingestedAt: DateTime.now(),
        storagePath: 'p2',
      );

      final unique = Evidence(
        caid: 'unique',
        originalName: 'other.txt',
        mimeType: 'text',
        fileSize: 200,
        ingestedAt: DateTime.now(),
        storagePath: 'p3',
      );

      when(() => mockRepository.getAll()).thenAnswer((_) async => [target, duplicate, unique]);

      final dups = await service.findPotentialDuplicates(target);

      expect(dups.length, 1);
      expect(dups.first, 'dup');
    });

    test('merge() combines metadata and archives secondary', () async {
      final e1 = Evidence(
        caid: 'primary',
        originalName: 'a.pdf',
        mimeType: 'pdf',
        fileSize: 100,
        ingestedAt: DateTime.now(),
        storagePath: 'p1',
        extractionData: {'key1': 'val1'},
      );

      final e2 = Evidence(
        caid: 'secondary',
        originalName: 'a_copy.pdf',
        mimeType: 'pdf',
        fileSize: 100,
        ingestedAt: DateTime.now(),
        storagePath: 'p2',
        extractionData: {'key2': 'val2'},
      );

      when(() => mockRepository.getByCaid('primary')).thenAnswer((_) async => e1);
      when(() => mockRepository.getByCaid('secondary')).thenAnswer((_) async => e2);
      when(() => mockRepository.store(any())).thenAnswer((_) async {});

      await service.merge('primary', 'secondary');

      final merged = verify(() => mockRepository.store(captureAny())).captured.first as Evidence;
      expect(merged.extractionData, {'key1': 'val1', 'key2': 'val2'});
      expect(merged.auditHistory.any((e) => e.action.contains('MERGED_WITH: secondary')), isTrue);
    });
  });
}
