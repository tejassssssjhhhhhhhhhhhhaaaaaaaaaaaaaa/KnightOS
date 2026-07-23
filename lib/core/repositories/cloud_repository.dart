class CloudRepository {
  const CloudRepository();

  Future<void> syncProfile(Map<String, Object?> profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: connect this to Firebase Firestore or a hosted backend.
  }

  Future<void> syncVoiceMemory(Map<String, Object?> memory) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: sync voice memories to the cloud once configuration is ready.
  }

  Future<String> getSyncStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return 'TODO: configure Firebase or a cloud backend';
  }
}
