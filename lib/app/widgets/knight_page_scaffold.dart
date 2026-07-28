import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_constants.dart';
import '../../core/design_system/widgets/knight_background.dart';
import '../../core/router/app_routes.dart';

class KnightPageScaffold extends StatelessWidget {
  const KnightPageScaffold({
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: DesignColors.background,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              leading: showBackButton
                  ? IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                      tooltip: 'Back',
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Center(
                        child: Text(
                          'K',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: DesignColors.accentBlue,
                            fontFamily: 'Serif', // Placeholder for brand font
                          ),
                        ),
                      ),
                    ),
              title: Text(
                title!.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: DesignColors.primary,
                  letterSpacing: 3.0,
                ),
              ),
              actions: [
                ...?actions,
                IconButton(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  tooltip: 'System Settings',
                ),
                const SizedBox(width: 8),
              ],
            ),
      body: KnightBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: body,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
