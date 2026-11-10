import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'device_lock_service.dart';
import 'secure_storage_service.dart';
import '../../providers/chat_visibility_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/service_providers.dart';

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
    _setupDecoyNotificationListener();
    return const SessionLocked();
  }

  /// Setup persistent stealth decoy notification listener for the bound user
  Future<void> _setupDecoyNotificationListener([String? explicitUserId]) async {
    final boundUserId = explicitUserId ?? await SecureStorageService.readBoundUserId();
    if (boundUserId != null) {
      try {
        ref.read(notificationServiceProvider).startListeningForIncomingMessages(
          supabase: Supabase.instance.client,
          boundUserId: boundUserId,
          isChatActive: () => ref.read(isChatActiveProvider),
        );
      } catch (e) {
        debugPrint('setupDecoyNotificationListener note: $e');
      }
    }
  }

  /// Update state and notify stream
  void _updateState(SessionState newState) {
    state = newState;
    _streamController.add(newState);
  }

  /// Setup app lifecycle listener and native device lock detection
  void _setupAppLifecycleListener() {
    DeviceLockService.initialize(
      onDeviceLocked: () => _lockIfAuthenticated(),
    );

    AppLifecycleListener(
      onInactive: () => _onAppInactive(),
      onHide: () => _onAppHidden(),
      onPause: () => _onAppPaused(),
      onDetach: () => _onAppDetached(),
      onResume: () => _onAppResumed(),
    );
  }

  /// Called when app becomes inactive (e.g. app switcher / notification shade opened)
  void _onAppInactive() {
    // Intentionally preserved: do not lock when merely switching apps or previewing
  }

  /// Called when app goes to background/hidden (e.g. minimized to home screen)
  void _onAppHidden() {
    // Intentionally preserved: do not lock when going to home screen
  }

  /// Called when app is paused
  void _onAppPaused() {
    // Check if the pause occurred because the phone is locking / screen turned off
    unawaited(_checkDeviceLock());
  }

  /// Called when app is detached (task removed from recents / process terminated)
  void _onAppDetached() {
    lock();
  }

  /// Called when app comes to foreground
  void _onAppResumed() {
    _cancelAutoLock();
    // Verify if the phone was locked or screen turned off while in background
    unawaited(_checkDeviceLock());
  }

  /// Check if native layer reported a device lock / screen off event
  Future<void> _checkDeviceLock() async {
    final wasLocked = await DeviceLockService.checkAndResetDeviceLocked();
    if (wasLocked) {
      _lockIfAuthenticated();
    }
  }

  /// Lock the session if currently authenticated
  void _lockIfAuthenticated() {
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
      // Valid PIN - persist session user ID securely and bind this device to this user
      await SecureStorageService.saveSessionUserId(user.id);
      await SecureStorageService.saveBoundUser(
        userId: user.id,
        userRole: user.role.name,
      );

      // Authenticate in state
      _updateState(SessionAuthenticated(
        userId: user.id,
        userRole: user.role.name,
      ));

      // Sign in with Supabase
      await repository.signInWithSupabase(user.id);

      // Start stealth decoy notification listener for this user
      unawaited(_setupDecoyNotificationListener(user.id));

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

  /// Explicit user logout from Settings:
  /// Clears device binding so either user can log in next time,
  /// signs out of Supabase, and locks session.
  /// Strictly preserves local SQLite database messages per APP_SUMMARY.md.
  Future<void> logout() async {
    ref.read(notificationServiceProvider).stopListeningForIncomingMessages();
    await SecureStorageService.clearBoundUser();
    await ref.read(chatRepositoryProvider).signOut();
    lock();
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