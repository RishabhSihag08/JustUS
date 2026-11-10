import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_storage_service.dart';
import '../../providers/repository_providers.dart';

/// Session state sealed class
sealed class SessionState {
  const SessionState();

  /// Pattern matching helper
  T when<T>({
    required T Function(String userId, String userRole) authenticated,
    required T Function(Duration? lockoutRemaining, int attemptCount) locked,
  }) {
    switch (this) {
      case SessionAuthenticated(:final userId, :final userRole):
        return authenticated(userId, userRole);
      case SessionLocked(:final lockoutRemaining, :final attemptCount):
        return locked(lockoutRemaining, attemptCount);
    }
  }
}

/// Session is locked - user needs to enter PIN
class SessionLocked extends SessionState {
  final Duration? lockoutRemaining;
  final int attemptCount;

  const SessionLocked({
    this.lockoutRemaining,
    this.attemptCount = 0,
  });
}

/// Session is authenticated - user is logged in
class SessionAuthenticated extends SessionState {
  final String userId;
  final String userRole; // 'user_1' or 'user_2'

  const SessionAuthenticated({
    required this.userId,
    required this.userRole,
  });
}

/// Session Manager - handles PIN verification, auto-lock, and session state
class SessionManager extends Notifier<SessionState> {
  static const int maxAttempts = 5;
  static const Duration lockoutDuration = Duration(seconds: 30);

  Timer? _lockoutTimer;
  Timer? _appLifecycleTimer;
  final _streamController = StreamController<SessionState>.broadcast();

  @override
  SessionState build() {
    ref.onDispose(_dispose);
    // Start with locked state
    _setupAppLifecycleListener();
    return const SessionLocked();
  }

  /// Update state and notify stream
  void _updateState(SessionState newState) {
    state = newState;
    _streamController.add(newState);
  }

  /// Setup app lifecycle listener for auto-lock
  void _setupAppLifecycleListener() {
    AppLifecycleListener(
      onInactive: () => _onAppInactive(),
      onHide: () => _onAppHidden(),
      onPause: () => _onAppPaused(),
      onDetach: () => _onAppDetached(),
      onResume: () => _onAppResumed(),
    );
  }

  /// Called when app becomes inactive (e.g. app switcher / recents opened)
  void _onAppInactive() {
    _immediateLockIfAuthenticated();
  }

  /// Called when app goes to background/hidden
  void _onAppHidden() {
    _immediateLockIfAuthenticated();
  }

  /// Called when app is paused (Android) or resigns active (iOS)
  void _onAppPaused() {
    _immediateLockIfAuthenticated();
  }

  /// Called when app is detached
  void _onAppDetached() {
    lock();
  }

  /// Called when app comes to foreground
  void _onAppResumed() {
    _cancelAutoLock();
  }

  /// Immediately lock the session if authenticated to shield from recents switcher
  void _immediateLockIfAuthenticated() {
    _cancelAutoLock();
    if (state is SessionAuthenticated) {
      lock();
    }
  }

  /// Cancel scheduled auto-lock
  void _cancelAutoLock() {
    _appLifecycleTimer?.cancel();
    _appLifecycleTimer = null;
  }

  /// Verify PIN and authenticate user
  Future<void> verifyPin(String pin) async {
    final repository = ref.read(chatRepositoryProvider);
    final user = await repository.verifyPin(pin);

    if (user != null) {
      // Valid PIN - persist session user ID securely
      await SecureStorageService.saveSessionUserId(user.id);

      // Authenticate in state
      _updateState(SessionAuthenticated(
        userId: user.id,
        userRole: user.role.name,
      ));

      // Sign in with Supabase
      await repository.signInWithSupabase(user.id);

      // Navigate to chat (handled by router redirect)
    } else {
      // Invalid PIN - handle attempt count
      _handleFailedAttempt();
    }
  }

  /// Handle failed PIN attempt
  void _handleFailedAttempt() {
    if (state is SessionLocked) {
      final current = state as SessionLocked;
      final newAttemptCount = current.attemptCount + 1;

      if (newAttemptCount >= maxAttempts) {
        // Lockout
        _updateState(SessionLocked(
          lockoutRemaining: lockoutDuration,
          attemptCount: newAttemptCount,
        ));
        _startLockoutTimer();
      } else {
        // Just increment attempt count
        _updateState(SessionLocked(
          lockoutRemaining: current.lockoutRemaining,
          attemptCount: newAttemptCount,
        ));
      }
    }
  }

  /// Start lockout countdown timer
  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    Duration remaining = lockoutDuration;

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        _updateState(const SessionLocked(attemptCount: 0));
      } else {
        _updateState(SessionLocked(
          lockoutRemaining: remaining,
          attemptCount: maxAttempts,
        ));
      }
    });
  }

  /// Lock the session and return to PIN screen
  void lock() {
    _cancelAutoLock();
    _lockoutTimer?.cancel();

    final currentSession = state;
    if (currentSession is SessionAuthenticated) {
      unawaited(ref.read(chatRepositoryProvider).updateUserPresence(currentSession.userId, false).catchError((_) {}));
    }

    // Clear session state to require PIN re-entry
    _updateState(const SessionLocked());

    // Unsubscribe from all Realtime channels while locked
    ref.read(realtimeServiceProvider).unsubscribeAll();

    // Cancel WorkManager immediate task
    ref.read(workmanagerServiceProvider).cancelImmediateSync();

    // Router will redirect to /pin via redirect callback
  }

  void _dispose() {
    _lockoutTimer?.cancel();
    _appLifecycleTimer?.cancel();
    _streamController.close();
  }

  /// Stream of session state changes for GoRouter
  Stream<SessionState> get stream => _streamController.stream;
}

/// Session Manager Provider
final sessionManagerProvider = NotifierProvider<SessionManager, SessionState>(
  SessionManager.new,
);