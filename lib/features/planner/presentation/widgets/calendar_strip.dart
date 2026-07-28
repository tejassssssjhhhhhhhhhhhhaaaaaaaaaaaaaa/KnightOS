import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/design_constants.dart';

class CalendarStrip extends StatelessWidget {
  const CalendarStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final week = List.generate(
      7,
      (i) =>
          now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: i)),
    );

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.m),
        itemCount: week.length,
        itemBuilder: (context, i) {
          final day = week[i];
          final isToday = day.day == now.day && day.month == now.month;

          return Container(
            width: 55,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: isToday ? DesignColors.focus : DesignColors.surface,
              borderRadius: BorderRadius.circular(DesignRadius.m),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: isToday ? DesignShadows.soft : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E').format(day).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isToday ? Colors.white70 : Colors.white24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isToday ? Colors.white : Colors.white60,
                  ),
                ),
                const SizedBox(height: 4),
                if (isToday)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
