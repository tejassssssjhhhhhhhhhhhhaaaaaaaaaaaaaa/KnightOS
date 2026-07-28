import 'package:flutter/foundation.dart';
import '../../storage/local_database.dart';
import '../../storage/storage_keys.dart';
import '../domain/knight_memory.dart';
import '../domain/memory_category.dart';
import '../domain/memory_domain.dart';
import '../engines/memory_engine.dart';

/// One-time migration logic from legacy JSON storage to the Unified Memory Engine.
class MemoryMigrationService {
  const MemoryMigrationService({
    required this.memoryEngine,
    this.legacyDb = const LocalDatabase(),
  });

  final MemoryEngine memoryEngine;
  final LocalDatabase legacyDb;

  Future<void> runMigration() async {
    try {
      debugPrint('Starting KnightOS Memory Migration (Optimized)...');

      // 1. Migrate Focus Areas
      final focusData = await legacyDb.readJsonList(StorageKeys.focusAreas);
      if (focusData != null) {
        final List<KnightMemory> focusMemories = [];
        for (final item in focusData) {
          final map = item as Map<String, dynamic>;
          focusMemories.add(
            KnightMemory.create(
              memoryId: 'focus-${map['category']}',
              category: BookCategory.career,
              domain: MemoryDomain.projects,
              content: map,
              summary: 'Priority: ${map['title']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
              effectiveAt: DateTime.tryParse(map['lastUpdated'] ?? ''),
            ),
          );
        }
        if (focusMemories.isNotEmpty) {
          await memoryEngine.saveAll(focusMemories);
        }
      }

      // 2. Migrate Recovery Metrics
      final recoveryData = await legacyDb.readJsonList(
        StorageKeys.recoveryMetrics,
      );
      if (recoveryData != null) {
        final List<KnightMemory> recoveryMemories = [];
        for (final item in recoveryData) {
          final map = item as Map<String, dynamic>;
          recoveryMemories.add(
            KnightMemory.create(
              memoryId: 'recovery-${map['category']}',
              category: BookCategory.health,
              domain: MemoryDomain.health,
              content: map,
              summary:
                  '${map['category']} level: ${map['value']}${map['unit']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
            ),
          );
        }
        if (recoveryMemories.isNotEmpty) {
          await memoryEngine.saveAll(recoveryMemories);
        }
      }

      // 3. Migrate Money Metrics
      final moneyData = await legacyDb.readJsonList(StorageKeys.moneyMetrics);
      if (moneyData != null) {
        final List<KnightMemory> moneyMemories = [];
        for (final item in moneyData) {
          final map = item as Map<String, dynamic>;
          moneyMemories.add(
            KnightMemory.create(
              memoryId: 'money-${map['category']}',
              category: BookCategory.finance,
              domain: MemoryDomain.finance,
              content: map,
              summary: '${map['category']} amount: ${map['amount']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
            ),
          );
        }
        if (moneyMemories.isNotEmpty) {
          await memoryEngine.saveAll(moneyMemories);
        }
      }

      // 4. Migrate Upcoming Items
      final upcomingData = await legacyDb.readJsonList(
        StorageKeys.upcomingItems,
      );
      if (upcomingData != null) {
        final List<KnightMemory> upcomingMemories = [];
        for (final item in upcomingData) {
          final map = item as Map<String, dynamic>;
          upcomingMemories.add(
            KnightMemory.create(
              memoryId: 'upcoming-${map['id']}',
              category: BookCategory.ambitions,
              domain: MemoryDomain.goals,
              content: map,
              summary: '${map['category']}: ${map['title']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
            ),
          );
        }
        if (upcomingMemories.isNotEmpty) {
          await memoryEngine.saveAll(upcomingMemories);
        }
      }

      // 5. Migrate Knight Conversations
      final chatData = await legacyDb.readJsonList(
        StorageKeys.knightConversations,
      );
      if (chatData != null) {
        final List<KnightMemory> chatMemories = [];
        for (final item in chatData) {
          final map = item as Map<String, dynamic>;
          chatMemories.add(
            KnightMemory.create(
              memoryId: 'conversation-${map['id']}',
              category: BookCategory.unknown,
              domain: MemoryDomain.unknowns,
              content: map,
              summary: 'Chat: ${map['title']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
              effectiveAt: DateTime.tryParse(map['lastUpdatedAt'] ?? ''),
            ),
          );
        }
        if (chatMemories.isNotEmpty) {
          await memoryEngine.saveAll(chatMemories);
        }
      }

      // 6. Migrate Timeline Entries
      final timelineData = await legacyDb.readJsonList(
        StorageKeys.timelineEntries,
      );
      if (timelineData != null) {
        final List<KnightMemory> timelineMemories = [];
        for (final item in timelineData) {
          final map = item as Map<String, dynamic>;
          timelineMemories.add(
            KnightMemory.create(
              memoryId: 'timeline-${map['id']}',
              category: BookCategory.history,
              domain: MemoryDomain.memories,
              content: map,
              summary: 'History: ${map['title']}',
              source: MemorySource.manual,
              reasoning: 'legacy-json-v1',
              effectiveAt: DateTime.tryParse(map['timestamp'] ?? ''),
            ),
          );
        }
        if (timelineMemories.isNotEmpty) {
          // Process timeline in chunks to avoid overwhelming the transaction if it's very large
          const chunkSize = 100;
          for (var i = 0; i < timelineMemories.length; i += chunkSize) {
            final end = (i + chunkSize < timelineMemories.length)
                ? i + chunkSize
                : timelineMemories.length;
            await memoryEngine.saveAll(timelineMemories.sublist(i, end));
            debugPrint('Migrated timeline chunk ${i ~/ chunkSize + 1}...');
          }
        }
      }

      debugPrint('KnightOS Memory Migration Complete.');
    } catch (e) {
      debugPrint('Migration error: $e');
      // Rollback is implicitly handled by keeping legacy JSON files.
    }
  }
}
