import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../app/widgets/knight_page_scaffold.dart';
import '../data/finance_storage.dart';
import '../domain/finance_transaction.dart';

class FinanceTrackerScreen extends StatefulWidget {
  const FinanceTrackerScreen({super.key});

  @override
  State<FinanceTrackerScreen> createState() => _FinanceTrackerScreenState();
}

class _FinanceTrackerScreenState extends State<FinanceTrackerScreen> {
  final _storage = FinanceStorage();
  final _uuid = const Uuid();

  final _dateController = TextEditingController();
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _accountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String _searchQuery = '';
  String _selectedDateFilter = 'All';
  String _selectedTypeFilter = 'All';
  String _selectedCategoryFilter = 'All';

  late final Future<List<FinanceTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toIso8601String().split('T').first;
    _typeController.text = 'Expense';
    _amountController.text = '0';
    _categoryController.text = 'Food';
    _paymentMethodController.text = 'Card';
    _accountController.text = 'Checking';
    _descriptionController.text = '';
    _notesController.text = '';
    _transactionsFuture = _storage.loadTransactions();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _typeController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _paymentMethodController.dispose();
    _accountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KnightPageScaffold(
      title: 'Finance Tracker',
      body: FutureBuilder<List<FinanceTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data ?? <FinanceTransaction>[];
          final filtered = _filterTransactions(transactions);
          final metrics = FinanceTransactionMetrics.fromTransactions(transactions);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(metrics),
                const SizedBox(height: 20),
                _buildLogForm(),
                const SizedBox(height: 20),
                _buildHistorySection(filtered),
                const SizedBox(height: 20),
                _buildAnalyticsSection(metrics),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(FinanceTransactionMetrics metrics) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricCard(title: 'Income', value: metrics.totalIncome.toStringAsFixed(0), icon: Icons.trending_up_outlined),
        _MetricCard(title: 'Expense', value: metrics.totalExpense.toStringAsFixed(0), icon: Icons.trending_down_outlined),
        _MetricCard(title: 'Balance', value: metrics.netBalance.toStringAsFixed(0), icon: Icons.account_balance_wallet_outlined),
        _MetricCard(title: 'Savings', value: metrics.savings.toStringAsFixed(0), icon: Icons.savings_outlined),
      ],
    );
  }

  Widget _buildLogForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log a transaction', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTextField('Transaction Date', _dateController),
              _buildTextField('Transaction Type', _typeController),
              _buildTextField('Amount', _amountController, isNumber: true),
              _buildTextField('Category', _categoryController),
              _buildTextField('Payment Method', _paymentMethodController),
              _buildTextField('Account', _accountController),
              _buildTextField('Description', _descriptionController),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saveTransaction,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<FinanceTransaction> transactions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Search transactions'),
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedDateFilter,
                  items: ['All', 'Today', 'Week', 'Month'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (value) => setState(() => _selectedDateFilter = value ?? 'All'),
                  decoration: const InputDecoration(labelText: 'Filter by date'),
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedTypeFilter,
                  items: ['All', 'Income', 'Expense'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                  onChanged: (value) => setState(() => _selectedTypeFilter = value ?? 'All'),
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryFilter,
                  items: ['All', 'Salary', 'Bonus', 'Interest', 'Other', 'Food', 'Rent', 'Shopping', 'EMI', 'Fuel', 'Entertainment', 'Bills', 'Medical', 'Travel', 'Education']
                      .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategoryFilter = value ?? 'All'),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty)
            Text('No transactions logged yet.', style: Theme.of(context).textTheme.bodyMedium)
          else
            ...transactions.map((transaction) => Card(
                  child: ListTile(
                    title: Text('${transaction.transactionDate} · ${transaction.transactionType} · ${transaction.category}'),
                    subtitle: Text('${transaction.description} • ${transaction.amount.toStringAsFixed(0)} • ${transaction.account}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editTransaction(transaction)),
                        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _deleteTransaction(transaction.id)),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(FinanceTransactionMetrics metrics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analytics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(title: 'Income', value: metrics.totalIncome.toStringAsFixed(0), icon: Icons.trending_up_outlined),
              _MetricCard(title: 'Expense', value: metrics.totalExpense.toStringAsFixed(0), icon: Icons.trending_down_outlined),
              _MetricCard(title: 'Savings', value: metrics.savings.toStringAsFixed(0), icon: Icons.savings_outlined),
              _MetricCard(title: 'Top Spending Category', value: metrics.topSpendingCategory, icon: Icons.category_outlined),
              _MetricCard(title: 'Monthly Trend', value: metrics.monthlyTrend.toStringAsFixed(1), icon: Icons.bar_chart_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return SizedBox(
      width: 240,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  List<FinanceTransaction> _filterTransactions(List<FinanceTransaction> transactions) {
    var filtered = transactions.where((transaction) {
      final matchesQuery = transaction.description.toLowerCase().contains(_searchQuery) ||
          transaction.notes.toLowerCase().contains(_searchQuery) ||
          transaction.category.toLowerCase().contains(_searchQuery) ||
          transaction.account.toLowerCase().contains(_searchQuery);
      final matchesType = _selectedTypeFilter == 'All' || transaction.transactionType == _selectedTypeFilter;
      final matchesCategory = _selectedCategoryFilter == 'All' || transaction.category == _selectedCategoryFilter;
      return matchesQuery && matchesType && matchesCategory;
    }).toList();

    if (_selectedDateFilter == 'Today') {
      final today = DateTime.now().toIso8601String().split('T').first;
      filtered = filtered.where((transaction) => transaction.transactionDate == today).toList();
    } else if (_selectedDateFilter == 'Week') {
      final start = DateTime.now().subtract(const Duration(days: 7));
      filtered = filtered.where((transaction) {
        final date = DateTime.parse(transaction.transactionDate);
        return !date.isBefore(start);
      }).toList();
    } else if (_selectedDateFilter == 'Month') {
      final start = DateTime.now().subtract(const Duration(days: 30));
      filtered = filtered.where((transaction) {
        final date = DateTime.parse(transaction.transactionDate);
        return !date.isBefore(start);
      }).toList();
    }

    return filtered;
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final transaction = FinanceTransaction(
      id: _uuid.v4(),
      transactionDate: _dateController.text.trim().isEmpty ? DateTime.now().toIso8601String().split('T').first : _dateController.text,
      transactionType: _typeController.text.trim().isEmpty ? 'Expense' : _typeController.text,
      amount: amount,
      category: _categoryController.text.trim().isEmpty ? 'Other' : _categoryController.text,
      paymentMethod: _paymentMethodController.text.trim().isEmpty ? 'Cash' : _paymentMethodController.text,
      account: _accountController.text.trim().isEmpty ? 'General' : _accountController.text,
      description: _descriptionController.text.trim(),
      notes: _notesController.text.trim(),
    );

    await _storage.saveTransaction(transaction);
    if (!mounted) return;
    setState(() {
      _transactionsFuture = _storage.loadTransactions();
    });
    _dateController.clear();
    _typeController.text = 'Expense';
    _amountController.clear();
    _categoryController.clear();
    _paymentMethodController.clear();
    _accountController.clear();
    _descriptionController.clear();
    _notesController.clear();
  }

  void _editTransaction(FinanceTransaction transaction) {
    _dateController.text = transaction.transactionDate;
    _typeController.text = transaction.transactionType;
    _amountController.text = transaction.amount.toString();
    _categoryController.text = transaction.category;
    _paymentMethodController.text = transaction.paymentMethod;
    _accountController.text = transaction.account;
    _descriptionController.text = transaction.description;
    _notesController.text = transaction.notes;
  }

  Future<void> _deleteTransaction(String id) async {
    await _storage.deleteTransaction(id);
    if (!mounted) return;
    setState(() {
      _transactionsFuture = _storage.loadTransactions();
    });
  }

}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
