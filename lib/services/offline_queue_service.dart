import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/daos/messages_dao.dart';
import '../data/local/database.dart';
import '../data/remote/dto/message_dto.dart';
import '../domain/enums.dart';
import '../providers/database_providers.dart';
import '../providers/supabase_providers.dart';

/// Service for monitoring connectivity and auto-processing pending messages
class OfflineQueueService {
  final AppDatabase _database;
  final SupabaseClient _supabase;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isProcessing = false;

  OfflineQueueService(this._database, this._supabase) {
    _initConnectivityListener();
  }

  MessagesDao get _messagesDao => _database.messagesDao;

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected) {
        processQueue();
      }
    });
  }

  /// Process pending messages in Drift and push to Supabase
  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final pendingList = await _messagesDao.getPendingMessages();
      for (final tableData in pendingList) {
        try {
          final domainMsg = tableData.toDomain();
          final sentMsg = domainMsg.copyWith(status: MessageStatus.sent);
          final dto = MessageDto.fromDomain(sentMsg);

          await _supabase.from('messages').upsert(dto.toJson());

          await _messagesDao.updateDeliveryStatus(
            tableData.id,
            MessageStatus.sent.name,
            DateTime.now(),
          );
        } catch (e) {
          debugPrint('Failed to process queued message ${tableData.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Offline queue error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

final offlineQueueServiceProvider = Provider<OfflineQueueService>((ref) {
  final service = OfflineQueueService(
    ref.read(databaseProvider),
    ref.read(supabaseClientProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
