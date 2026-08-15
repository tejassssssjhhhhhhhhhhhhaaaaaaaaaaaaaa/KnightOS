import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/knight_theme_provider.dart';
import 'knight_circuit_shield_header.dart'; // Future refinement

class KnightPageScaffold extends ConsumerWidget {
  const KnightPageScaffold({
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onSettingsPressed,
    this.settingsRoute,
    this.hideLeadingLogo = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final VoidCallback? onSettingsPressed;
  final String? settingsRoute;
  final bool hideLeadingLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final canPop = context.canPop();
    final accentColor = ref.watch(adaptiveAccentProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Inherit from Global Root
      extendBodyBehindAppBar: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: showBackButton
            ? IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (canPop) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: accentColor,
                ),
                tooltip: 'Back',
              )
            : (hideLeadingLogo 
                ? null 
                : const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Center(child: KnightCircuitShieldHeader()),
                  )),
        title: title != null 
          ? Text(
              title!.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
        actions: [
          ...?actions,
          IconButton(
            onPressed: onSettingsPressed ?? () => context.push(settingsRoute ?? AppRoutes.profile),
            icon: Icon(Icons.tune_rounded, size: 20, color: accentColor.withValues(alpha: 0.5)),
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        bottom: false, 
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: body,
          ),
        ),
      ),
    );
  }
}
