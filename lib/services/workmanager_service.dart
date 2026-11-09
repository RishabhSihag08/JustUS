import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      await Supabase.initialize(
        url: 'https://placeholder.supabase.co',
        publishableKey: 'placeholder-key',
      );
    } catch (_) {}

    debugPrint('Background sync task executed: $task');
    return true;
  });
}

