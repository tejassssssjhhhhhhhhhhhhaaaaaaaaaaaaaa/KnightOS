import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

class TransactionItemCard extends StatelessWidget {
  const TransactionItemCard({super.key, required this.tx, required this.onTap});
  final TransactionData tx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = tx.type == 'income' ? Colors.greenAccent : Colors.white70;
    final prefix = tx.type == 'income' ? '+' : '-';

    return InkWell(
      onTap: onTap,
      borderRadius: KnightTokens.radiusCard,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: KnightTokens.radiusCard,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            _CategoryIcon(category: tx.category),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.merchant,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat('MMM dd').format(tx.transactionDate)} · ${tx.institution}',
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix₹${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color),
                ),
                const SizedBox(height: 4),
                _VerificationBadge(status: tx.verificationState),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (category.toLowerCase()) {
      case 'food': icon = Icons.restaurant_rounded; color = Colors.orangeAccent; break;
      case 'shopping': icon = Icons.shopping_bag_rounded; color = Colors.purpleAccent; break;
      case 'transport': icon = Icons.directions_car_rounded; color = Colors.blueAccent; break;
      case 'bills': icon = Icons.receipt_long_rounded; color = Colors.redAccent; break;
      case 'salary': icon = Icons.payments_rounded; color = Colors.greenAccent; break;
      default: icon = Icons.account_balance_wallet_rounded; color = Colors.white24;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final isVerified = status == 'VERIFIED';
    return Row(
      children: [
        Icon(
          isVerified ? Icons.verified_rounded : Icons.pending_actions_rounded,
          size: 10,
          color: isVerified ? Colors.blueAccent : Colors.orangeAccent,
        ),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: isVerified ? Colors.blueAccent : Colors.orangeAccent,
          ),
        ),
      ],
    );
  }
}

class TransactionDetailSheet extends StatelessWidget {
  const TransactionDetailSheet({super.key, required this.tx});
  final TransactionData tx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 24),
          Text(tx.merchant, style: KnightTokens.headline.copyWith(fontSize: 28)),
          Text('₹${tx.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, color: tx.type == 'income' ? Colors.greenAccent : Colors.white70)),
          const SizedBox(height: 32),
          _DetailRow(label: 'DATE & TIME', value: DateFormat('MMMM dd, yyyy · HH:mm').format(tx.transactionDate)),
          _DetailRow(label: 'INSTITUTION', value: tx.institution),
          _DetailRow(label: 'PAYMENT METHOD', value: tx.paymentMethod ?? 'Unknown'),
          _DetailRow(label: 'CATEGORY', value: tx.category),
          _DetailRow(label: 'DESCRIPTION', value: tx.description),
          const Divider(height: 48, color: Colors.white10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {}, // Milestone 9
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('EXPLAIN'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (tx.originalEmailLink != null) {
                      launchUrl(Uri.parse(tx.originalEmailLink!));
                    }
                  },
                  icon: const Icon(Icons.mail_outline_rounded, size: 16),
                  label: const Text('VIEW SOURCE'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {}, // Milestone 6
              child: const Text('VIEW EVIDENCE HISTORY', style: TextStyle(color: Colors.white24, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }
}
