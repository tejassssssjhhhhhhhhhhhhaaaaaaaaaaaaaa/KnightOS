import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/intelligence/providers/intelligence_providers.dart';
import '../../../core/intelligence/domain/memory_category.dart';
import '../../../core/domain/models/models.dart';

final vaultItemsProvider = FutureProvider<List<Document>>((ref) async {
  final memoryEngine = ref.watch(memoryEngineProvider);

  // Combine results from multiple relevant books
  final all = <Document>[];

  final books = [
    BookCategory.history,
    BookCategory.skills,
    BookCategory.career,
    BookCategory.health,
    BookCategory.finance,
  ];

  for (final category in books) {
    final memories = await memoryEngine.getByCategory(category);
    all.addAll(
      memories
          .where(
            (m) =>
                m.memoryId.startsWith('discovery-') ||
                m.source == MemorySource.imported,
          )
          .map(
            (m) => Document(
              id: m.memoryId,
              title: m.summary ?? 'Untitled Document',
              category: _mapBookToDocument(m.category),
              addedAt: m.recordedAt,
              fileSize: m.content['size']?.toString(),
              sourcePath: m.content['path']?.toString(),
              tags: m.tags,
              isFavorite: m.importance > 0.8,
            ),
          ),
    );
  }

  return all;
});

DocumentCategory _mapBookToDocument(BookCategory category) {
  switch (category) {
    case BookCategory.skills:
      return DocumentCategory.book;
    case BookCategory.history:
      return DocumentCategory.pdf;
    case BookCategory.career:
      return DocumentCategory.career;
    case BookCategory.health:
      return DocumentCategory.medical;
    case BookCategory.finance:
      return DocumentCategory.finance;
    default:
      return DocumentCategory.other;
  }
}
