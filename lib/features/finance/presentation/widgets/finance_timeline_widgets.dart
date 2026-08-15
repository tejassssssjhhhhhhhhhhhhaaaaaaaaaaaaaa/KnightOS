import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/knight_tokens.dart';
import '../../domain/finance_timeline_models.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/finance_explorer_filter.dart';
import '../controllers/finance_explorer_controller.dart';

class MonthTimelineCard extends StatefulWidget {
  const MonthTimelineCard({super.key, required this.period});
  final FinanceTimelinePeriod period;

  @override
  State<MonthTimelineCard> createState() => _MonthTimelineCardState();
}

class _MonthTimelineCardState extends State<MonthTimelineCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(widget.period.date).toUpperCase(),
                  style: KnightTokens.label.copyWith(color: Colors.blueAccent),
                ),
                const SizedBox(width: 12),
                Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 14, color: Colors.white24),
                const Spacer(),
                if (widget.period.events.isNotEmpty)
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                     child: Text('${widget.period.events.length} EVENTS', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                   ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: KnightTokens.radiusCard,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Metric(label: 'INCOME', value: '₹${widget.period.income.toStringAsFixed(0)}', color: Colors.greenAccent),
                    _Metric(label: 'EXPENSES', value: '₹${widget.period.expenses.toStringAsFixed(0)}', color: Colors.redAccent),
                    _Metric(label: 'SAVINGS', value: '₹${widget.period.savings.toStringAsFixed(0)}', color: Colors.blueAccent),
                  ],
                ),
                if (widget.period.aiSummary != null) ...[
                  const Divider(height: 32, color: Colors.white10),
                  Text(
                    widget.period.aiSummary!,
                    style: const TextStyle(fontSize: 12, color: Colors.white38, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
          if (_expanded && widget.period.events.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...widget.period.events.map((event) => _MemoryEventTile(event: event)),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: KnightTokens.label.copyWith(fontSize: 8)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}

class _MemoryEventTile extends ConsumerWidget {
  const _MemoryEventTile({required this.event});
  final FinanceMemoryEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        final start = DateTime(event.date.year, event.date.month, event.date.day);
        final end = start.add(const Duration(days: 1));
        ref.read(explorerFilterProvider.notifier).update(ExplorerFilter(
          dateRange: DateTimeRange(start: start, end: end),
          searchQuery: event.title,
        ));
        context.push(AppRoutes.financeExplorer);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getEventColor(event.type).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getEventColor(event.type).withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(_getEventIcon(event.type), size: 18, color: _getEventColor(event.type)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title.toUpperCase(), style: KnightTokens.label.copyWith(fontSize: 8, color: _getEventColor(event.type))),
                  const SizedBox(height: 2),
                  Text(event.description, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
            Text(
              DateFormat('dd MMM').format(event.date),
              style: const TextStyle(fontSize: 10, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEventIcon(FinanceMemoryEventType type) {
    switch (type) {
      case FinanceMemoryEventType.firstSalary: return Icons.stars_rounded;
      case FinanceMemoryEventType.largePurchase: return Icons.shopping_cart_checkout_rounded;
      case FinanceMemoryEventType.refundReceived: return Icons.replay_rounded;
      default: return Icons.event_note_rounded;
    }
  }

  Color _getEventColor(FinanceMemoryEventType type) {
    switch (type) {
      case FinanceMemoryEventType.firstSalary: return Colors.amberAccent;
      case FinanceMemoryEventType.largePurchase: return Colors.orangeAccent;
      case FinanceMemoryEventType.refundReceived: return Colors.cyanAccent;
      default: return Colors.white24;
    }
  }
}
