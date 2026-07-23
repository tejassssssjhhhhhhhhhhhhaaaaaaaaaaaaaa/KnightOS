class UserContext {
  const UserContext({
    required this.userId,
    required this.displayName,
    required this.profileSummary,
    required this.preferences,
    required this.goals,
    required this.cloudReady,
    required this.voiceReady,
  });

  final String userId;
  final String displayName;
  final String profileSummary;
  final List<String> preferences;
  final List<String> goals;
  final bool cloudReady;
  final bool voiceReady;
}
