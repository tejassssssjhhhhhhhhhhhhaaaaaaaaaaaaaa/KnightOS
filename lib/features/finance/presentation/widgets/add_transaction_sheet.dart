import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'expense';
  String _category = 'General';
  DateTime _date = DateTime.now();
  bool _isSaving = false;

  final List<String> _categories = [
    'General', 'Food', 'Transport', 'Shopping', 'Bills', 'Rent', 'Income', 'Leisure', 'Health'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || _descriptionController.text.isEmpty) return;

    setState(() => _isSaving = true);
    final db = ref.read(knightDatabaseProvider);

    try {
      final transactionId = const Uuid().v4();
      await db.financialDao.insertTransaction(TransactionTableCompanion.insert(
        id: transactionId,
        transactionId: transactionId,
        accountId: 'manual-entry',
        amount: amount * (_type == 'expense' ? -1 : 1),
        description: _descriptionController.text.trim(),
        category: _category,
        transactionDate: _date,
        type: _type,
        merchant: _descriptionController.text.trim(),
        institution: 'Manual',
        dedupeHash: '${_date.millisecondsSinceEpoch}-$amount-${_descriptionController.text}',
        verificationState: const drift.Value('VERIFIED'),
        syncStatus: const drift.Value('local_only'),
      ));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction recorded.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(28, 32, 28, 32 + bottomPadding),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('RECORD TRANSACTION', style: KnightTokens.label),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTypeButton('EXPENSE', _type == 'expense', () => setState(() => _type = 'expense')),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTypeButton('INCOME', _type == 'income', () => setState(() => _type = 'income')),
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              hintText: '0.00',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _descriptionController,
            decoration: KnightTokens.inputDecoration(label: 'Description', hint: 'e.g. Grocery shopping'),
          ),
          const SizedBox(height: 24),
          _buildCategoryPicker(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: _isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('SECURE ENTRY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: active ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? Colors.white.withValues(alpha: 0.24) : Colors.white.withValues(alpha: 0.05)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.24),
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CATEGORY', style: TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((c) {
              final active = _category == c;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c, style: TextStyle(fontSize: 11, color: active ? Colors.white : Colors.white38)),
                  selected: active,
                  onSelected: (val) => setState(() => _category = c),
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
