/// Intelligent orchestration layer for KnightOS.
library;

import '../../features/companion/companion_repository.dart';
import '../../features/journal/journal_models.dart';
import '../../features/journal/journal_repository.dart';
import '../../features/learning/learning_models.dart';
import '../../features/learning/learning_repository.dart';
import '../../features/memory/memory_models.dart';
import '../../features/memory/memory_repository.dart';
import '../../features/onboarding/domain/onboarding_profile.dart';
import '../../features/voice/voice_repository.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/backup_repository.dart';
import '../repositories/user_repository.dart';
import '../platform/storage/storage_engine.dart';
import '../storage/local_database.dart';

/// The central orchestration layer for KnightOS intelligent features.
///
/// [KnightBrain] aggregates data from across multiple repositories and features
/// to build higher-level insights such as daily briefs, life timelines,
/// and cross-system search results.
class KnightBrain {
  /// Creates a [KnightBrain] instance with its required repository dependencies.
  KnightBrain({
    required StorageEngine engine,
    LocalDatabase? localDatabase,
    AuthenticationRepository? authenticationRepository,
    UserRepository? userRepository,
    CompanionRepository? companionRepository,
    JournalRepository? journalRepository,
    LearningRepository? learningRepository,
    MemoryRepository? memoryRepository,
    VoiceRepository? voiceRepository,
    BackupRepository? backupRepository,
  }) : _authenticationRepository =
           authenticationRepository ?? AuthenticationRepository.instance,
       _userRepository =
           userRepository ??
           UserRepository(
             engine: engine,
             authenticationRepository:
                 authenticationRepository ?? AuthenticationRepository.instance,
           ),
       _companionRepository =
           companionRepository ??
           CompanionRepository(localDatabase: localDatabase),
       _journalRepository =
           journalRepository ?? JournalRepository(localDatabase: localDatabase),
       _learningRepository =
           learningRepository ??
           LearningRepository(localDatabase: localDatabase),
       _memoryRepository =
           memoryRepository ?? MemoryRepository(localDatabase: localDatabase),
       _voiceRepository =
           voiceRepository ?? VoiceRepository(localDatabase: localDatabase),
       _backupRepository =
           backupRepository ?? BackupRepository(localDatabase: localDatabase);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final CompanionRepository _companionRepository;
  final JournalRepository _journalRepository;
  final LearningRepository _learningRepository;
  final MemoryRepository _memoryRepository;
  final VoiceRepository _voiceRepository;
  final BackupRepository _backupRepository;

  /// Builds a high-level summary of the user's current status and priorities.
  Future<Map<String, Object?>> buildDailyBrief() async {
    final session = await _authenticationRepository.getCurrentSession();
    final profile = await _userRepository.loadProfile();
    final memories = await _memoryRepository.loadMemories();
    final journalEntries = await _journalRepository.loadEntries();
    final learningGoals = await _learningRepository.loadGoals();
    final voiceMemories = await _voiceRepository.loadMemories();
    final companionEntries = await _companionRepository.loadEntries();

    return <String, Object?>{
      'userId': session?.userId ?? 'local-user',
      'displayName':
          session?.displayName ?? profile?.preferredName ?? 'Knight User',
      'profileReady': profile != null,
      'memoryCount': memories.length,
      'journalCount': journalEntries.length,
      'learningGoalCount': learningGoals.length,
      'voiceMemoryCount': voiceMemories.length,
      'companionEntryCount': companionEntries.length,
      'priorities': _buildPriorities(
        profile,
        memories,
        journalEntries,
        learningGoals,
      ),
      'reminders': _buildReminders(profile, memories),
    };
  }

  /// Aggregates events from all systems into a chronologically sorted timeline.
  Future<Map<String, Object?>> buildTimeline() async {
    final memories = await _memoryRepository.loadMemories();
    final journalEntries = await _journalRepository.loadEntries();
    final learningGoals = await _learningRepository.loadGoals();
    final voiceMemories = await _voiceRepository.loadMemories();
    final companionEntries = await _companionRepository.loadEntries();

    final items = <Map<String, Object?>>[];
    items.addAll(
      memories.map(
        (memory) => <String, Object?>{
          'type': 'memory',
          'title': memory.title,
          'createdAt': memory.createdAt.toIso8601String(),
        },
      ),
    );
    items.addAll(
      journalEntries.map(
        (entry) => <String, Object?>{
          'type': 'journal',
          'title': entry.title,
          'createdAt': entry.createdAt.toIso8601String(),
        },
      ),
    );
    items.addAll(
      learningGoals.map(
        (goal) => <String, Object?>{
          'type': 'learning',
          'title': goal.title,
          'createdAt': goal.createdAt.toIso8601String(),
        },
      ),
    );
    items.addAll(
      voiceMemories.map(
        (memory) => <String, Object?>{
          'type': 'voice',
          'title': memory.transcript,
          'createdAt': memory.createdAt.toIso8601String(),
        },
      ),
    );
    items.addAll(
      companionEntries.map(
        (entry) => <String, Object?>{
          'type': 'companion',
          'title': entry.title,
          'createdAt': entry.createdAt.toIso8601String(),
        },
      ),
    );

    items.sort(
      (a, b) => DateTime.parse(
        a['createdAt'] as String,
      ).compareTo(DateTime.parse(b['createdAt'] as String)),
    );
    return <String, Object?>{'items': items};
  }

  /// Performs a text-based search across all integrated data systems.
  Future<Map<String, Object?>> searchAcrossSystems(String query) async {
    final memories = await _memoryRepository.loadMemories();
    final journalEntries = await _journalRepository.loadEntries();
    final learningGoals = await _learningRepository.loadGoals();
    final voiceMemories = await _voiceRepository.loadMemories();
    final companionEntries = await _companionRepository.loadEntries();

    final matches = <Map<String, Object?>>[];
    final haystacks = <Map<String, Object?>>[];
    haystacks.addAll(
      memories.map(
        (memory) => <String, Object?>{
          'type': 'memory',
          'title': memory.title,
          'body': memory.body,
        },
      ),
    );
    haystacks.addAll(
      journalEntries.map(
        (entry) => <String, Object?>{
          'type': 'journal',
          'title': entry.title,
          'body': entry.body,
        },
      ),
    );
    haystacks.addAll(
      learningGoals.map(
        (goal) => <String, Object?>{
          'type': 'learning',
          'title': goal.title,
          'body': goal.reason,
        },
      ),
    );
    haystacks.addAll(
      voiceMemories.map(
        (memory) => <String, Object?>{
          'type': 'voice',
          'title': memory.summary,
          'body': memory.transcript,
        },
      ),
    );
    haystacks.addAll(
      companionEntries.map(
        (entry) => <String, Object?>{
          'type': 'companion',
          'title': entry.title,
          'body': entry.body,
        },
      ),
    );

    for (final item in haystacks) {
      final title = (item['title'] as String? ?? '').toLowerCase();
      final body = (item['body'] as String? ?? '').toLowerCase();
      if (title.contains(query.toLowerCase()) ||
          body.contains(query.toLowerCase())) {
        matches.add(item);
      }
    }

    return <String, Object?>{'query': query, 'matches': matches};
  }

  Future<Map<String, Object?>> buildBackupSnapshot() async {
    final profile = await _userRepository.loadProfile();
    final session = await _authenticationRepository.getCurrentSession();
    final memories = await _memoryRepository.loadMemories();
    final journalEntries = await _journalRepository.loadEntries();
    final learningGoals = await _learningRepository.loadGoals();
    final voiceMemories = await _voiceRepository.loadMemories();
    final companionEntries = await _companionRepository.loadEntries();

    return <String, Object?>{
      'userId': session?.userId ?? 'local-user',
      'profile': profile?.toJson(),
      'memories': memories.map((memory) => memory.toJson()).toList(),
      'journalEntries': journalEntries.map((entry) => entry.toJson()).toList(),
      'learningGoals': learningGoals.map((goal) => goal.toJson()).toList(),
      'voiceMemories': voiceMemories.map((memory) => memory.toJson()).toList(),
      'companionEntries': companionEntries
          .map((entry) => entry.toJson())
          .toList(),
    };
  }

  Future<void> persistBackupSnapshot() async {
    final snapshot = await buildBackupSnapshot();
    await _backupRepository.backupSnapshot(snapshot);
  }

  List<String> _buildPriorities(
    UserProfile? profile,
    List<MemoryItem> memories,
    List<JournalEntry> journalEntries,
    List<LearningGoal> learningGoals,
  ) {
    final priorities = <String>[];
    if (profile != null && (profile.learningGoals.isNotEmpty)) {
      priorities.add('Continue your learning goal: ${profile.learningGoals}');
    }
    if (memories.isNotEmpty) {
      priorities.add('Review your most recent memory');
    }
    if (journalEntries.isNotEmpty) {
      priorities.add('Reflect on your latest journal entry');
    }
    if (learningGoals.isNotEmpty) {
      priorities.add('Keep momentum on your current learning plan');
    }
    return priorities.isEmpty
        ? <String>[
            'No stored priorities yet. Add a memory, journal, or learning goal to begin.',
          ]
        : priorities;
  }

  List<String> _buildReminders(
    UserProfile? profile,
    List<MemoryItem> memories,
  ) {
    final reminders = <String>[];
    if (profile != null && (profile.learningGoals.isNotEmpty)) {
      reminders.add('Learning reminder: revisit your learning goal today');
    }
    if (memories.isNotEmpty) {
      reminders.add('Memory reminder: review one stored memory');
    }
    return reminders.isEmpty
        ? <String>[
            'No reminders yet. Add a memory or learning goal to receive guidance.',
          ]
        : reminders;
  }
}
