import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_pad_state.freezed.dart';

/// PIN Pad State sealed class
@freezed
sealed class PinPadState with _$PinPadState {
  /// Idle state - waiting for input
  const factory PinPadState.idle({
    @Default('') String enteredPin,
    @Default(0) int attemptCount,
  }) = PinPadIdle;

  /// Error state - wrong PIN entered
  const factory PinPadState.error({
    @Default('') String enteredPin,
    @Default(0) int attemptCount,
    required String message,
    @Default(false) bool isShaking,
  }) = PinPadError;

  /// Locked state - too many failed attempts
  const factory PinPadState.locked({
    required Duration remaining,
  }) = PinPadLocked;

  /// Success state - valid PIN entered
  const factory PinPadState.success({
    required String userId,
  }) = PinPadSuccess;
}