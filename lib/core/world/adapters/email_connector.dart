import '../domain/world_connector.dart';
import '../../intelligence/domain/world_models.dart';

/// Integration for Email (Gmail/IMAP).
class GoogleEmailConnector implements WorldConnector {
  GoogleEmailConnector({required this.client});

  final EmailClient client;

  @override
  String get id => 'google-email';

  @override
  String get name => 'Google Mail';

  @override
  WorldSource get source => const WorldSource(
        id: 'google-email',
        name: 'Google Mail',
        type: 'email',
      );

  @override
  Future<Map<String, dynamic>> fetchData() async {
    final threads = await client.fetchRecentThreads();
    return {
      'threads': threads.map((t) => t.toJson()).toList(),
    };
  }

  @override
  Future<bool> isAvailable() => client.checkAuth();
}

abstract class EmailClient {
  Future<List<EmailThread>> fetchRecentThreads();
  Future<bool> sendDraft(String draftId);
  Future<bool> checkAuth();
}
