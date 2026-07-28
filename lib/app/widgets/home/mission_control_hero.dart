import 'package:flutter/material.dart';
import '../../../../core/design_system/design_constants.dart';

class MissionControlHero extends StatelessWidget {
  const MissionControlHero({
    required this.name,
    required this.quote,
    super.key,
  });

  final String name;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Action Bar (Menu & Notification)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.notes_rounded, color: Colors.white, size: 24),
            Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: DesignColors.health,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // 2. Multi-line Greeting
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w400,
            ),
            children: [
              const TextSpan(text: 'Good Evening,\n'),
              TextSpan(
                text: name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Icon(Icons.workspace_premium_rounded, color: DesignColors.achievements, size: 24),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 3. Daily Quote
        Center(
          child: Text(
            quote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white38,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
