import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/security/secure_storage_service.dart';
import 'notification_service.dart';

/// Background sync task name
const String backgroundSyncTask = 'com.justus.backgroundSync';

/// WorkManager service for background synchronization
class WorkManagerService {
  WorkManagerService();

  /// Initialize WorkManager
  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    // Register periodic sync task (every 15 minutes)
    await Workmanager().registerPeriodicTask(
      backgroundSyncTask,
      backgroundSyncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  /// Schedule an immediate sync (for when app goes to background)
  Future<void> scheduleImmediateSync() async {
    await Workmanager().registerOneOffTask(
      'immediate-sync',
      backgroundSyncTask,
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  /// Cancel immediate sync task
  Future<void> cancelImmediateSync() async {
    await Workmanager().cancelByUniqueName('immediate-sync');
  }

  /// Cancel all tasks
  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}

/// Callback dispatcher for background tasks
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      try {
        await dotenv.load(fileName: 'assets/.env');
      } catch (_) {}

      final url = dotenv.env['SUPABASE_URL'] ?? 'https://aptzqrejanzizuzornvx.supabase.co';
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      if (url.isNotEmpty && anonKey.isNotEmpty) {
        try {
          await Supabase.initialize(url: url, publishableKey: anonKey);
        } catch (_) {}
      }

      final boundUserId = await SecureStorageService.readBoundUserId();
      if (boundUserId != null) {
        final client = Supabase.instance.client;
        final unread = await client
            .from('messages')
            .select('id, created_at')
            .neq('sender_id', boundUserId)
            .inFilter('status', ['sent', 'delivered'])
            .order('created_at', ascending: false)
            .limit(1);

        if (unread.isNotEmpty) {
          await NotificationService.showDecoyNotification();
        }
      }
    } catch (e) {
      debugPrint('Background sync task note: $e');
    }

    debugPrint('Background sync task executed: $task');
    return true;
  });
}

