import '../services/knowledge_graph_service.dart';
import '../../internal/storage/drift/knight_database.dart';

class KnowledgeGraphWeaver {
  final KnowledgeGraphService graphService;
  KnowledgeGraphWeaver({required this.graphService});

  /// Weaves a mission structure into the graph.
  Future<void> weaveMission(MissionData mission, List<GoalData> goals, List<TaskData> tasks) async {
    final missionNodeId = await graphService.ensureNode(
      type: 'mission',
      label: mission.title,
      externalTable: 'missions',
      externalId: mission.id,
    );

    for (final goal in goals) {
      final goalNodeId = await graphService.ensureNode(
        type: 'goal',
        label: goal.title,
        externalTable: 'goals',
        externalId: goal.id,
      );
      
      await graphService.link(
        fromId: missionNodeId,
        toId: goalNodeId,
        relationship: 'ownership',
      );

      final goalTasks = tasks.where((t) => t.goalId == goal.id);
      for (final task in goalTasks) {
        final taskNodeId = await graphService.ensureNode(
          type: 'task',
          label: task.title,
          externalTable: 'tasks',
          externalId: task.id,
        );
        
        await graphService.link(
          fromId: goalNodeId,
          toId: taskNodeId,
          relationship: 'references',
        );
      }
    }
  }

  /// Weaves an email thread/metadata into the graph.
  Future<void> weaveEmailMetadata(Map<String, dynamic> email) async {
    final emailNodeId = await graphService.ensureNode(
      type: 'email',
      label: email['subject'] ?? 'No Subject',
      externalTable: 'import_history', // Placeholder for actual email table if exists
      externalId: email['id'],
      metadata: {'from': email['from']},
    );

    final from = email['from'] as String? ?? '';
    if (from.isNotEmpty) {
       final personNodeId = await graphService.ensureNode(type: 'person', label: from);
       await graphService.link(fromId: personNodeId, toId: emailNodeId, relationship: 'sent');
    }
  }

  /// Links an entity to a specific location (Place).
  Future<void> linkToPlace(String sourceNodeId, String placeName) async {
    final placeNodeId = await graphService.ensureNode(type: 'place', label: placeName);
    await graphService.link(
      fromId: sourceNodeId,
      toId: placeNodeId,
      relationship: 'travel_link',
    );
  }

  /// Links a financial transaction to an organization.
  Future<void> linkToOrganization(String txNodeId, String orgName) async {
    final orgNodeId = await graphService.ensureNode(type: 'organization', label: orgName);
    await graphService.link(
      fromId: txNodeId,
      toId: orgNodeId,
      relationship: 'financial_link',
    );
  }

  /// Links a workspace memory to its email source.
  Future<void> linkToEmailSource(String memoryNodeId, String messageId) async {
    final emailNodeId = await graphService.ensureNode(
      type: 'email',
      label: 'Gmail Source',
      externalTable: 'gmail_messages',
      externalId: messageId,
    );
    await graphService.link(
      fromId: memoryNodeId,
      toId: emailNodeId,
      relationship: 'sourced_from',
    );
  }

  /// Links a workspace memory to its calendar source.
  Future<void> linkToCalendarSource(String memoryNodeId, String eventId) async {
    final calNodeId = await graphService.ensureNode(
      type: 'calendar_event',
      label: 'Calendar Source',
      externalTable: 'timeline_events', // Or specific calendar table
      externalId: eventId,
    );
    await graphService.link(
      fromId: memoryNodeId,
      toId: calNodeId,
      relationship: 'sourced_from',
    );
  }
}
