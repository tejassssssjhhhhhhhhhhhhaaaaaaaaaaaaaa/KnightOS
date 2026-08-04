import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_metadata.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:knight_os/core/intelligence/domain/memory_domain.dart';
import 'package:knight_os/core/intelligence/domain/memory_category.dart';
import 'package:knight_os/core/intelligence/domain/evidence.dart';

void main() {
  group('MemoryDomain', () {
    test('should have 30 domains', () {
      expect(MemoryDomain.values.length, 30);
    });

    test('fromId returns correct domain', () {
      expect(MemoryDomain.fromId(1), MemoryDomain.identity);
      expect(MemoryDomain.fromId(30), MemoryDomain.unknowns);
    });
  });

  group('BookCategory', () {
    test('should have 14 books', () {
      expect(BookCategory.values.length, 14);
    });

    test('fromId returns correct category', () {
      expect(BookCategory.fromId(1), BookCategory.identity);
      expect(BookCategory.fromId(11), BookCategory.unknown);
    });
  });

  group('MemoryMetadata', () {
    final effectiveAt = DateTime(2026, 7, 27);
    final meta = MemoryMetadata(
      effectiveAt: effectiveAt,
      confidence: 1.0,
      source: MemorySource.manual,
      domain: MemoryDomain.identity,
      category: BookCategory.identity,
      tags: ['test'],
    );

    test('serialization cycle', () {
      final json = meta.toJson();
      final fromJson = MemoryMetadata.fromJson(json);
      expect(fromJson.memoryId, meta.memoryId);
      expect(fromJson.effectiveAt, effectiveAt);
      expect(fromJson.domain, MemoryDomain.identity);
    });
  });

  group('SourceLink', () {
    test('toUri and fromUri', () {
      final caid = 'a' * 64;
      final link = SourceLink(caid: caid, fragment: 'line=10');
      final uri = link.toUri();
      expect(uri, 'knight://evidence/$caid#line=10');

      final fromUri = SourceLink.fromUri(uri);
      expect(fromUri.caid, caid);
      expect(fromUri.fragment, 'line=10');
    });
  });

  group('KnightMemory', () {
    test('serialization cycle', () {
      final meta = MemoryMetadata(
        effectiveAt: DateTime.now(),
        confidence: 0.9,
        source: MemorySource.sensor,
        domain: MemoryDomain.health,
        category: BookCategory.health,
      );
      final version = const MemoryVersion(
        versionNumber: 1,
        changeType: ChangeType.creation,
        reasoning: "Initial record",
      );
      final memory = KnightMemory(
        metadata: meta,
        version: version,
        content: {'weight': 80.5},
      );

      final json = memory.toJson();
      final fromJson = KnightMemory.fromJson(json);

      expect(fromJson.content['weight'], 80.5);
      expect(fromJson.metadata.domain, MemoryDomain.health);
      expect(fromJson.version.changeType, ChangeType.creation);
    });
  });
}
