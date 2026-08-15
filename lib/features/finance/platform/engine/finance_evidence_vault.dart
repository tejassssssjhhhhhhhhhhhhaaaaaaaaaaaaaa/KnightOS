import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:knight_os/core/internal/storage/drift/knight_database.dart';
import 'package:knight_os/core/internal/utils/knight_logger.dart';
import '../interfaces/finance_parser.dart';
import '../models/extraction_result.dart';
import 'duplicate_detection_engine.dart';
import 'normalization_engine.dart';

import 'package:knight_os/core/intelligence/services/vaf_shadow_service.dart';

class FinanceEvidenceVault {
  FinanceEvidenceVault({
    required this.db,
    required this.parserEngine,
    required this.dao,
    this.vafShadowService,
  });

  final KnightDatabase db;
  final IParserEngine parserEngine;
  final FinancePlatformDao dao;
  final VafShadowService? vafShadowService;

  /// Processes a Gmail message, extracts data, and updates the vault.
  Future<void> ingestMessage(GmailMessageData msg) async {
    KnightLogger.info('[FINANCE] Ingesting message ${msg.id}');
    final result = await parserEngine.process(
      msg.id,
      msg.sender,
      msg.subject,
      msg.snippet,
      msg.messageDate,
    );

    // 1. Store Extraction
    final extractionId = const Uuid().v4();
    await dao.insertExtraction(FinanceExtractionTableCompanion.insert(
      id: extractionId,
      messageId: msg.id,
      parserVersion: result.parserVersion,
      amount: Value(result.amount),
      currency: Value(result.currency),
      merchant: Value(result.merchant),
      referenceNumber: Value(result.referenceNumber),
      account: Value(result.account),
      card: Value(result.card),
      balance: Value(result.balance),
      statementPeriod: Value(result.statementPeriod),
      paymentMethod: Value(result.paymentMethod),
      institution: Value(result.institution),
      confidenceLevel: result.confidenceLevel.name,
      confidenceScore: result.confidenceScore,
      rawExtractedData: Value(jsonEncode(result.rawExtractedData)),
    ));

    // 2. Normalize and Deduplicate
    if (result.amount != null) {
      final normalizedMerchant = NormalizationEngine.normalizeMerchant(result.merchant ?? 'Unknown');
      final normalizedInstitution = NormalizationEngine.normalizeInstitution(result.institution ?? 'Unknown');
      
      final fingerprint = DuplicateDetectionEngine.generateFingerprint(
        amount: result.amount!,
        date: result.date ?? msg.messageDate,
        referenceNumber: result.referenceNumber,
        merchant: normalizedMerchant,
        institution: normalizedInstitution,
      );

      KnightLogger.info('[FINANCE] Message ${msg.id} fingerprint: $fingerprint');

      final existingTx = await dao.findTransactionByFingerprint(fingerprint);

      if (existingTx != null) {
        KnightLogger.info('[FINANCE] Found existing transaction ${existingTx.transactionId} for fingerprint $fingerprint. Merging.');
        // Merge Evidence
        await _mergeEvidence(existingTx, extractionId, result);
      } else {
        KnightLogger.info('[FINANCE] No existing transaction for fingerprint $fingerprint. Creating new.');
        // Create New Transaction
        await _createTransaction(msg, extractionId, result, normalizedMerchant, normalizedInstitution, fingerprint);
      }
    }

    // 3. Update Sync Journal
    await dao.updateJournalEntry(FinanceSyncJournalTableCompanion(
      messageId: Value(msg.id),
      parserVersion: Value(result.parserVersion),
      processingResult: Value(result.confidenceLevel == ConfidenceLevel.low ? 'Needs Review' : 'Parsed'),
      processedAt: Value(DateTime.now()),
    ));

    // 4. Create Task if Low Confidence
    if (result.confidenceLevel == ConfidenceLevel.low) {
      await dao.insertTask(FinanceInboxTaskTableCompanion.insert(
        id: const Uuid().v4(),
        taskType: 'Verification Needed',
        messageId: Value(msg.id),
        status: const Value('pending'),
      ));
    }
  }

  Future<void> _createTransaction(
    GmailMessageData msg,
    String extractionId,
    ExtractionResult result,
    String merchant,
    String institution,
    String fingerprint,
  ) async {
    final txId = const Uuid().v4();
    final txComp = TransactionTableCompanion.insert(
      id: const Uuid().v4(), // Version ID
      transactionId: txId,
      accountId: 'main-savings', // Simplified for now
      transactionDate: result.date ?? msg.messageDate,
      amount: result.amount!,
      type: _inferType(result),
      category: 'Finance',
      merchant: merchant,
      institution: institution,
      description: result.merchant ?? msg.subject,
      dedupeHash: fingerprint,
      confidenceScore: Value(result.confidenceScore),
      verificationState: Value(result.confidenceLevel == ConfidenceLevel.high ? 'VERIFIED' : 'UNVERIFIED'),
      originalEmailLink: Value('https://mail.google.com/mail/u/0/#inbox/${msg.id}'),
      parserVersion: Value(result.parserVersion),
      extractionTimestamp: Value(DateTime.now()),
      supportingEvidenceIds: Value(jsonEncode([extractionId])),
    );

    await dao.insertTransaction(txComp);
    if (vafShadowService != null) {
      await vafShadowService!.shadowTransactionCompanion(txComp);
    }
  }

  Future<void> _mergeEvidence(TransactionData existing, String extractionId, ExtractionResult result) async {
    final List<String> evidenceIds = List<String>.from(jsonDecode(existing.supportingEvidenceIds ?? '[]'));
    if (evidenceIds.contains(extractionId)) return;

    evidenceIds.add(extractionId);

    // Create New Version of Transaction
    await dao.markTransactionAsOld(existing.transactionId);
    
    final txComp = TransactionTableCompanion.insert(
      id: const Uuid().v4(),
      transactionId: existing.transactionId,
      accountId: existing.accountId,
      transactionDate: existing.transactionDate,
      amount: existing.amount,
      type: existing.type,
      category: existing.category,
      merchant: existing.merchant,
      institution: existing.institution,
      description: existing.description,
      dedupeHash: existing.dedupeHash,
      confidenceScore: Value(result.confidenceScore > (existing.confidenceScore ?? 0) ? result.confidenceScore : existing.confidenceScore),
      verificationState: Value(existing.verificationState),
      originalEmailLink: Value(existing.originalEmailLink),
      parserVersion: Value(result.parserVersion),
      extractionTimestamp: Value(DateTime.now()),
      supportingEvidenceIds: Value(jsonEncode(evidenceIds)),
      history: Value(jsonEncode({
        'merged_at': DateTime.now().toIso8601String(),
        'new_evidence_id': extractionId,
        'previous_version_id': existing.id,
      })),
    );

    await dao.insertTransaction(txComp);
    if (vafShadowService != null) {
      await vafShadowService!.shadowTransactionCompanion(txComp);
    }
  }

  String _inferType(ExtractionResult result) {
    final raw = jsonEncode(result.rawExtractedData).toLowerCase();
    final isIncome = raw.contains('credited') || 
                     raw.contains('refund') || 
                     raw.contains('salary') || 
                     raw.contains('received') ||
                     raw.contains('interest');
                     
    return isIncome ? 'income' : 'expense';
  }
}
