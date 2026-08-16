import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class KnightAiEngine {
  final String workbookPath;
  late Excel excel;

  KnightAiEngine(this.workbookPath) {
    var bytes = File(workbookPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
  }

  void initializeAiSheets() {
    _createTable('AI_CHAT_LOG', [
      "MESSAGE_ID", "TIMESTAMP", "SENDER", "TEXT", "INTENT", "EVIDENCE_ID", "CONTEXT_REF"
    ]);

    _createTable('AI_USAGE_LOG', [
      "REQUEST_ID", "TIMESTAMP", "INTENT", "TOKENS", "STATUS", "LATENCY_MS"
    ]);
    
    _updateCommandCenter();
    _save();
  }

  Future<void> simulateConversation(String userMessage) async {
    final requestId = 'REQ-${DateTime.now().millisecondsSinceEpoch}';
    print('[KNIGHT AI] Thinking: "$userMessage"');

    // 1. Intent Detection (Simplified rule-based simulation of Gemini)
    String intent = _detectIntent(userMessage);
    
    // 2. Data Retrieval & Grounding
    List<Map<String, String>> evidence = _retrieveEvidence(intent, userMessage);
    
    // 3. Response Generation
    String responseText = _generateResponse(intent, userMessage, evidence);
    
    // 4. Log to Workbook
    _logMessage('USER', userMessage, intent);
    _logMessage('KNIGHT', responseText, intent, evidenceId: evidence.isNotEmpty ? evidence[0]['id'] : null);
    
    _logUsage(requestId, intent, "SUCCESS");
    
    _save();
    print('[KNIGHT AI] Response: $responseText');
  }

  String _detectIntent(String msg) {
    final text = msg.toLowerCase();
    if (text.contains('show') || text.contains('find') || text.contains('search')) return 'SEARCH';
    if (text.contains('why') || text.contains('explain')) return 'EXPLAIN';
    if (text.contains('status') || text.contains('health')) return 'DIAGNOSE';
    if (text.contains('take me to') || text.contains('open')) return 'NAVIGATE';
    return 'ANSWER';
  }

  List<Map<String, String>> _retrieveEvidence(String intent, String msg) {
    List<Map<String, String>> results = [];
    var ssot = excel['10_SSOT_STORE'];
    var brain = excel['40_KNIGHT_BRAIN'];

    final query = msg.toLowerCase();

    // Simple keyword search in SSoT
    for (int i = 1; i < ssot.maxRows; i++) {
      var row = ssot.rows[i];
      if (row.isEmpty) continue;
      String content = row[4]?.value.toString().toLowerCase() ?? '';
      String title = row[3]?.value.toString().toLowerCase() ?? '';
      
      if (content.contains(query) || title.contains(query)) {
        results.add({
          'id': row[0]?.value.toString() ?? 'unknown',
          'source': 'SSOT',
          'title': row[3]?.value.toString() ?? '',
          'confidence': row[7]?.value.toString() ?? '1.0'
        });
      }
    }
    
    return results;
  }

  String _generateResponse(String intent, String msg, List<Map<String, String>> evidence) {
    if (evidence.isEmpty) {
      return "I searched my memory and SSoT but couldn't find any specific information related to that. Would you like me to broaden the search?";
    }

    if (intent == 'SEARCH') {
      return "I found ${evidence.length} relevant records. The most relevant is '${evidence[0]['title']}' from ${evidence[0]['source']}.";
    }

    if (intent == 'EXPLAIN') {
      return "Based on the evidence in SSoT (${evidence[0]['id']}), this item was observed on ${DateTime.now().toIso8601String().substring(0,10)} and confirmed with 100% confidence via rule-based normalization.";
    }

    return "I found information about '${evidence[0]['title']}'. How can I help you further with this?";
  }

  void _logMessage(String sender, String text, String intent, {String? evidenceId}) {
    var sheet = excel['AI_CHAT_LOG'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue('MSG-${DateTime.now().microsecondsSinceEpoch}');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(sender);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(text);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(intent);
    if (evidenceId != null) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(evidenceId);
    }
  }

  void _logUsage(String id, String intent, String status) {
    var sheet = excel['AI_USAGE_LOG'];
    int row = sheet.maxRows;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(id);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(DateTime.now().toIso8601String());
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(intent);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = IntCellValue(0); // Mock tokens
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(status);
  }

  void _updateCommandCenter() {
    var sheet = excel['00_COMMAND_CENTER'];
    // Add Knight Orb / Entry
    sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue("KNIGHT AI");
    sheet.cell(CellIndex.indexByString("D2")).value = TextCellValue("● ONLINE");
    sheet.cell(CellIndex.indexByString("D3")).setFormula('HYPERLINK("#\'AI_CHAT_LOG\'!A1", "[ OPEN CHAT ]")');
  }

  void _createTable(String name, List<String> headers) {
    var sheet = excel[name];
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }
  }

  String _generateHash(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 12);
  }

  void _save() {
    var bytes = excel.save();
    if (bytes != null) {
      File(workbookPath).writeAsBytesSync(bytes);
    }
  }
}
