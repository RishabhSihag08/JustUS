import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database_providers.dart';
import 'supabase_providers.dart';
import '../data/repository/chat_repository.dart';
import '../data/repository/chat_repository_impl.dart';
import '../data/repository/sync_repository.dart';
import '../core/security/secure_storage_service.dart';
import '../services/realtime_service.dart';
import '../services/workmanager_service.dart';
import '../services/notification_service.dart';
import '../services/media_service.dart';
export '../services/offline_queue_service.dart';

/// Repository providers
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.read(databaseProvider),
    ref.read(supabaseClientProvider),
    ref.read(secureStorageProvider),
  );
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(
    ref.read(databaseProvider),
    ref.read(supabaseClientProvider),
    ref.read(secureStorageProvider),
  );
});

/// Secure storage provider
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Service providers
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService(Supabase.instance.client);
});

final workmanagerServiceProvider = Provider<WorkManagerService>((ref) {
  return WorkManagerService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService(
    Supabase.instance.client,
  );
});