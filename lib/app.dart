import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/security/session_manager.dart';

/// Main App Widget
class JustUsApp extends ConsumerWidget {
  const JustUsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Listen to session changes for auto-lock
    ref.listen<SessionState>(sessionManagerProvider, (previous, next) {
      if (next is SessionLocked) {
        router.go('/compass');
      }
    });

    return MaterialApp.router(
      title: 'JustUS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
