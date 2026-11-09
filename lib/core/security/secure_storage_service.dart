import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
