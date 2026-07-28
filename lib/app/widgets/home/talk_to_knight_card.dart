import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../home_cta_card.dart';

class HomeTalkToKnightCard extends StatelessWidget {
  const HomeTalkToKnightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeCtaCard(
      title: 'Talk to Knight',
      subtitle: 'Start a conversation with your personal AI.',
      icon: Icons.auto_awesome,
      onTap: () {
        context.push(AppRoutes.knight);
      },
    );
  }
}
