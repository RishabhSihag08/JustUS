import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/compass_credentials.dart';

/// Secure Storage Service - wraps FlutterSecureStorage for type-safe operations
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys
  static const String _sessionUserIdKey = 'session_user_id';
  static const String _lastSyncAtKey = 'last_sync_at';
  static const String _deviceIdKey = 'device_id';
  static const String _pinHashKey = 'pin_hash';
  static const String _boundUserRoleKey = 'bound_user_role';
  static const String _boundUserIdKey = 'bound_user_id';
  static const String _user1HeadingKey = 'user_1_heading';
  static const String _user1PinKey = 'user_1_pin';
  static const String _user2HeadingKey = 'user_2_heading';
  static const String _user2PinKey = 'user_2_pin';

  /// Initialize the secure storage
  static Future<void> initialize() async {
    try {
      await _storage.read(key: _sessionUserIdKey);
    } catch (e) {
      debugPrint('SecureStorageService initialize fallback: $e');
      try {
        await _storage.deleteAll();
      } catch (_) {}
    }
  }

  /// Save the current session user ID
  static Future<void> saveSessionUserId(String userId) async {
    try {
      await _storage.write(key: _sessionUserIdKey, value: userId);
    } catch (e) {
      debugPrint('SecureStorageService saveSessionUserId error: $e');
    }
  }

  /// Read the current session user ID
  static Future<String?> readSessionUserId() async {
    try {
      return await _storage.read(key: _sessionUserIdKey);
    } catch (e) {
      debugPrint('SecureStorageService readSessionUserId error: $e');
      return null;
    }
  }

  /// Clear the session
  static Future<void> clearSession() async {
    try {
      await _storage.delete(key: _sessionUserIdKey);
    } catch (e) {
      debugPrint('SecureStorageService clearSession error: $e');
    }
  }

  /// Save last sync timestamp
  static Future<void> saveLastSyncAt(DateTime dateTime) async {
    try {
      await _storage.write(
        key: _lastSyncAtKey,
        value: dateTime.toIso8601String(),
      );
    } catch (e) {
      debugPrint('SecureStorageService saveLastSyncAt error: $e');
    }
  }

  /// Read last sync timestamp
  static Future<DateTime?> readLastSyncAt() async {
    try {
      final value = await _storage.read(key: _lastSyncAtKey);
      if (value == null) return null;
      return DateTime.parse(value);
    } catch (e) {
      debugPrint('SecureStorageService readLastSyncAt error: $e');
      return null;
    }
  }

  /// Save device ID
  static Future<void> saveDeviceId(String deviceId) async {
    try {
      await _storage.write(key: _deviceIdKey, value: deviceId);
    } catch (e) {
      debugPrint('SecureStorageService saveDeviceId error: $e');
    }
  }

  /// Read device ID
  static Future<String?> readDeviceId() async {
    try {
      return await _storage.read(key: _deviceIdKey);
    } catch (e) {
      debugPrint('SecureStorageService readDeviceId error: $e');
      return null;
    }
  }

  /// Save PIN hash
  static Future<void> savePinHash(String pinHash) async {
    try {
      await _storage.write(key: _pinHashKey, value: pinHash);
    } catch (e) {
      debugPrint('SecureStorageService savePinHash error: $e');
    }
  }

  /// Read PIN hash
  static Future<String?> readPinHash() async {
    try {
      return await _storage.read(key: _pinHashKey);
    } catch (e) {
      debugPrint('SecureStorageService readPinHash error: $e');
      return null;
    }
  }

  /// Save bound user to this device (locks login to this user role)
  static Future<void> saveBoundUser({
    required String userId,
    required String userRole,
  }) async {
    try {
      await _storage.write(key: _boundUserRoleKey, value: userRole);
      await _storage.write(key: _boundUserIdKey, value: userId);
    } catch (e) {
      debugPrint('SecureStorageService saveBoundUser error: $e');
    }
  }

  /// Read the bound user role ('user_1' or 'user_2', or null if unbound)
  static Future<String?> readBoundUserRole() async {
    try {
      return await _storage.read(key: _boundUserRoleKey);
    } catch (e) {
      debugPrint('SecureStorageService readBoundUserRole error: $e');
      return null;
    }
  }

  /// Read the bound user ID
  static Future<String?> readBoundUserId() async {
    try {
      return await _storage.read(key: _boundUserIdKey);
    } catch (e) {
      debugPrint('SecureStorageService readBoundUserId error: $e');
      return null;
    }
  }

  /// Clear the device binding (unbounds the phone, allowing either user to log in)
  static Future<void> clearBoundUser() async {
    try {
      await _storage.delete(key: _boundUserRoleKey);
      await _storage.delete(key: _boundUserIdKey);
    } catch (e) {
      debugPrint('SecureStorageService clearBoundUser error: $e');
    }
  }

  /// Cache compass credentials locally for fast/offline access
  static Future<void> cacheCompassCredentials({
    required String role,
    required double heading,
    required String pin,
    String? userId,
  }) async {
    try {
      final isUser1 = role == 'user_1' || role == 'user1';
      final headingKey = isUser1 ? _user1HeadingKey : _user2HeadingKey;
      final pinKey = isUser1 ? _user1PinKey : _user2PinKey;

      await _storage.write(key: headingKey, value: heading.toString());
      await _storage.write(key: pinKey, value: pin);
    } catch (e) {
      debugPrint('SecureStorageService cacheCompassCredentials error: $e');
    }
  }

  /// Read cached compass credentials for a specific role
  static Future<CompassCredentials?> readCachedCompassCredentials(String role) async {
    try {
      final isUser1 = role == 'user_1' || role == 'user1';
      final headingKey = isUser1 ? _user1HeadingKey : _user2HeadingKey;
      final pinKey = isUser1 ? _user1PinKey : _user2PinKey;

      final headingStr = await _storage.read(key: headingKey);
      final pin = await _storage.read(key: pinKey);

      if (headingStr != null && pin != null) {
        final heading = double.tryParse(headingStr) ?? (isUser1 ? 120.0 : 260.0);
        return CompassCredentials(
          userId: isUser1 ? 'd3cba4e7-7772-4f57-aa75-27237b515374' : '3d5db18d-4908-4f04-a5ae-de4b2afd6cf0',
          role: isUser1 ? 'user_1' : 'user_2',
          heading: heading,
          pin: pin,
        );
      }
    } catch (e) {
      debugPrint('SecureStorageService readCachedCompassCredentials error: $e');
    }
    return null;
  }

  /// Clear all data (for logout/reset)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('SecureStorageService clearAll error: $e');
    }
  }

  // Instance methods for dependency injection
  Future<void> saveUserId(String userId) => saveSessionUserId(userId);
  Future<String?> getUserId() => readSessionUserId();
  Future<void> clearUserSession() => clearSession();
  Future<void> setLastSync(DateTime dt) => saveLastSyncAt(dt);
  Future<DateTime?> getLastSync() => readLastSyncAt();
  Future<void> setDeviceId(String id) => saveDeviceId(id);
  Future<String?> getDeviceId() => readDeviceId();
}
