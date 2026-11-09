import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/pin_pad/pin_pad_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/chat/search/message_search_screen.dart';
import '../../features/chat/starred_messages_screen.dart';
import '../../features/chat/chat_settings_screen.dart';
import '../../features/chat/widgets/view_once_viewer.dart';
import '../../core/security/session_manager.dart';

/// GoRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final sessionManager = ref.watch(sessionManagerProvider.notifier);

  return GoRouter(
    initialLocation: '/pin',
    refreshListenable: GoRouterRefreshStream(sessionManager.stream),
    redirect: (context, state) {
      final sessionState = ref.read(sessionManagerProvider);
      final isLoggedIn = sessionState is SessionAuthenticated;
      final isPinRoute = state.matchedLocation == '/pin';
      final isViewOnceRoute = state.matchedLocation.startsWith('/view-once');

      // Allow view-once viewer without PIN (it has its own security)
      if (isViewOnceRoute) {
        return null;
      }

      // If not logged in and not on PIN route, redirect to PIN
      if (!isLoggedIn && !isPinRoute) {
        return '/pin';
      }

      // If logged in and on PIN route, redirect to chat
      if (isLoggedIn && isPinRoute) {
        return '/chat';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/pin',
        name: 'pin',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PinPadScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/chat/search',
        name: 'chat-search',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MessageSearchScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      ),
      GoRoute(
        path: '/chat/starred',
        name: 'chat-starred',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const StarredMessagesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      ),
      GoRoute(
        path: '/chat/settings',
        name: 'chat-settings',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ChatSettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      ),
      GoRoute(
        path: '/view-once/:messageId',
        name: 'view-once',
        pageBuilder: (context, state) {
          final messageId = state.pathParameters['messageId']!;
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ViewOnceViewerScreen(messageId: messageId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
              return ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),
    ],
  );
});

/// Wrapper to make SessionManager listenable for GoRouter
/// Implements Listenable for GoRouter's refreshListenable
class GoRouterRefreshStream implements Listenable {
  GoRouterRefreshStream(Stream<SessionState> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      _notifyListeners();
    });
  }

  late final StreamSubscription<SessionState> _subscription;
  final List<VoidCallback> _listeners = [];

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _subscription.cancel();
  }
}