abstract class IFinanceConnector {
  Future<bool> connect();
  Future<void> disconnect();
  Future<bool> isConnected();
  Future<void> refreshConnection();
  
  /// Fetches messages in a specific date range.
  Stream<List<Map<String, dynamic>>> fetchMessages({
    DateTime? start,
    DateTime? end,
    String? cursor,
  });

  /// Real-time stream of new messages.
  Stream<Map<String, dynamic>> watchNewMessages();
}
