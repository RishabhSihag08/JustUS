import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service interfacing with native platform to detect device lock & screen off events.
class DeviceLockService {
  static const MethodChannel _channel =
      MethodChannel('com.justus.justus/device_lock');

  static VoidCallback? _onDeviceLockedCallback;
  static bool _initialized = false;

  /// Initialize listener for native lock events
  static void initialize({VoidCallback? onDeviceLocked}) {
    _onDeviceLockedCallback = onDeviceLocked;

    if (_initialized) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeviceLocked') {
        debugPrint('DeviceLockService: native onDeviceLocked triggered');
        _onDeviceLockedCallback?.call();
      }
    });
  }

  /// Check if the phone was locked (or screen turned off) while in background
  /// or is currently locked, and reset the native flag.
  static Future<bool> checkAndResetDeviceLocked() async {
    if (!Platform.isAndroid) return false;
    try {
      final wasLocked =
          await _channel.invokeMethod<bool>('checkAndResetDeviceLocked');
      return wasLocked ?? false;
    } catch (e) {
      debugPrint('DeviceLockService checkAndResetDeviceLocked note: $e');
      return false;
    }
  }

  /// Minimizes the app to the home screen (standard root back navigation)
  static Future<void> moveTaskToBack() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<bool>('moveTaskToBack');
    } catch (e) {
      debugPrint('DeviceLockService moveTaskToBack note: $e');
    }
  }
}
