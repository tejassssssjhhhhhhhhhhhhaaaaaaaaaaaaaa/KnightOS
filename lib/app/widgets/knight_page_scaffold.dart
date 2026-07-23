import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/repositories/authentication_repository.dart';
import '../../core/router/app_routes.dart';

class KnightPageScaffold extends StatelessWidget {
  const KnightPageScaffold({
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: showBackButton
                  ? IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          final location = GoRouterState.of(context).matchedLocation;
                          if (location == AppRoutes.auth || location == AppRoutes.welcome || location == AppRoutes.splash) {
                            context.go(AppRoutes.welcome);
                          } else {
                            context.go(AppRoutes.dashboard);
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Back',
                    )
                  : null,
              title: Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                ...?actions,
                FutureBuilder<bool>(
                  future: AuthenticationRepository().isAuthenticated(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data != true) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      onPressed: () => context.go(AppRoutes.account),
                      icon: const Icon(Icons.person_outline_rounded),
                      tooltip: 'Profile',
                    );
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: body,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
