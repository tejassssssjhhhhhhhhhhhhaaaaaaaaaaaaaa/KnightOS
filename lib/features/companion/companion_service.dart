import 'companion_models.dart';

class CompanionService {
  const CompanionService();

  String buildCompanionPrompt(String text) {
    if (text.trim().isEmpty) {
      return 'I am here to listen. Share what is on your mind, and I will help you decide what to remember.';
    }

    return 'You shared: "$text". I can help you reflect on this, turn it into a note, or keep it private.';
  }

  CompanionEntry createEntry({required String title, required String body, String permission = 'conversation_only'}) {
    return CompanionEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Companion note' : title,
      body: body,
      createdAt: DateTime.now(),
      kind: 'reflection',
      permission: permission,
      source: 'chat',
      tags: <String>['companion'],
    );
  }
}
