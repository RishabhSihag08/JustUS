import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'dart:async';

import 'pin_pad_state.dart';
import '../../core/security/session_manager.dart';

/// PIN Pad Notifier - handles PIN entry, verification, and lockout
class PinPadNotifier extends Notifier<PinPadState> {
  static const int maxAttempts = 5;
  static const Duration lockoutDuration = Duration(seconds: 30);

  Timer? _lockoutTimer;
  Timer? _shakeTimer;

  @override
  PinPadState build() {
    return const PinPadState.idle();
  }

  /// Add a digit to the PIN
  void addDigit(String digit) {
    if (state is PinPadLocked) return;

    final currentPin = state.maybeWhen(
      idle: (enteredPin, _) => enteredPin,
      error: (enteredPin, attemptCount, message, isShaking) => enteredPin,
      orElse: () => '',
    );

    if (currentPin.length >= 4) return;

    final newPin = currentPin + digit;
    final newAttemptCount = state.maybeWhen(
      idle: (_, attemptCount) => attemptCount,
      error: (enteredPin, attemptCount, message, isShaking) => attemptCount,
      orElse: () => 0,
    );

    // Trigger haptic feedback
    HapticFeedback.heavyImpact();

    if (newPin.length == 4) {
      // Verify PIN when 4 digits entered
      _verifyPin(newPin, newAttemptCount);
    } else {
      // Update state with new PIN
      state = PinPadState.idle(
        enteredPin: newPin,
        attemptCount: newAttemptCount,
      );
    }
  }

  /// Remove the last digit from the PIN
  void removeDigit() {
    if (state is PinPadLocked) return;

    final currentPin = state.maybeWhen(
      idle: (enteredPin, _) => enteredPin,
      error: (enteredPin, attemptCount, message, isShaking) => enteredPin,
      orElse: () => '',
    );

    if (currentPin.isEmpty) return;

    final newPin = currentPin.substring(0, currentPin.length - 1);
    final newAttemptCount = state.maybeWhen(
      idle: (_, attemptCount) => attemptCount,
      error: (enteredPin, attemptCount, message, isShaking) => attemptCount,
      orElse: () => 0,
    );

    // Trigger light haptic feedback
    HapticFeedback.lightImpact();

    state = PinPadState.idle(
      enteredPin: newPin,
      attemptCount: newAttemptCount,
    );
  }

  /// Verify the entered PIN
  Future<void> _verifyPin(String pin, int attemptCount) async {
    // Read PINs from environment
    final user1Pin = dotenv.env['USER_1_PIN'] ?? '1234';
    final user2Pin = dotenv.env['USER_2_PIN'] ?? '5678';

    String? userId;

    if (pin == user1Pin) {
      userId = 'user_1';
    } else if (pin == user2Pin) {
      userId = 'user_2';
    }

    if (userId != null) {
      // Valid PIN
      state = PinPadState.success(userId: userId);

      // Notify session manager
      ref.read(sessionManagerProvider.notifier).verifyPin(pin);
    } else {
      // Invalid PIN
      _handleFailedAttempt(pin, attemptCount + 1);
    }
  }

  /// Handle failed PIN attempt
  void _handleFailedAttempt(String enteredPin, int newAttemptCount) {
    // Trigger error haptic feedback
    HapticFeedback.vibrate();

    if (newAttemptCount >= maxAttempts) {
      // Lockout
      state = PinPadState.locked(remaining: lockoutDuration);
      _startLockoutTimer();
    } else {
      // Show error with shake animation
      state = PinPadState.error(
        enteredPin: enteredPin,
        attemptCount: newAttemptCount,
        message: 'Incorrect PIN',
        isShaking: true,
      );

      // Trigger shake animation
      _triggerShakeAnimation();

      // Clear error after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (state is PinPadError) {
          final current = state as PinPadError;
          state = PinPadState.idle(
            enteredPin: current.enteredPin,
            attemptCount: current.attemptCount,
          );
        }
      });
    }
  }

  /// Trigger shake animation
  void _triggerShakeAnimation() {
    _shakeTimer?.cancel();
    _shakeTimer = Timer(const Duration(milliseconds: 500), () {
      if (state is PinPadError) {
        final current = state as PinPadError;
        state = PinPadError(
          enteredPin: current.enteredPin,
          attemptCount: current.attemptCount,
          message: current.message,
          isShaking: false,
        );
      }
    });
  }

  /// Start lockout countdown timer
  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    Duration remaining = lockoutDuration;

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        state = const PinPadState.idle();
      } else {
        state = PinPadState.locked(remaining: remaining);
      }
    });
  }

  void dispose() {
    _lockoutTimer?.cancel();
    _shakeTimer?.cancel();
  }
}

/// PIN Pad Notifier Provider
final pinPadNotifierProvider = NotifierProvider<PinPadNotifier, PinPadState>(
  PinPadNotifier.new,
);