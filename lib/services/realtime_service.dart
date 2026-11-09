import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for managing Supabase Realtime subscriptions
class RealtimeService {
  final SupabaseClient _supabase;
  final Map<String, RealtimeChannel> _channels = {};

  RealtimeService(this._supabase);

  /// Subscribe to a conversation's messages
  RealtimeChannel subscribeToConversation(String conversationId, void Function(Map<String, dynamic>) onMessage) {
    final channelName = 'conversation-$conversationId';

    if (_channels.containsKey(channelName)) {
      return _channels[channelName]!;
    }

    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            onMessage(payload.newRecord);
          },
        )
        .subscribe();

    _channels[channelName] = channel;
    return channel;
  }

  /// Subscribe to typing indicators
  RealtimeChannel subscribeToTypingIndicators(String conversationId, void Function(Map<String, dynamic>) onTyping) {
    final channelName = 'typing-$conversationId';

    if (_channels.containsKey(channelName)) {
      return _channels[channelName]!;
    }

    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'typing_indicators',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            onTyping(payload.newRecord);
          },
        )
        .subscribe();

    _channels[channelName] = channel;
    return channel;
  }

  /// Subscribe to reactions
  RealtimeChannel subscribeToReactions(String conversationId, void Function(Map<String, dynamic> record, bool isDelete) onReaction) {
    final channelName = 'reactions-$conversationId';

    if (_channels.containsKey(channelName)) {
      return _channels[channelName]!;
    }

    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'reactions',
          callback: (payload) {
            final isDelete = payload.eventType == PostgresChangeEvent.delete;
            final record = isDelete ? payload.oldRecord : payload.newRecord;
            onReaction(record, isDelete);
          },
        )
        .subscribe();

    _channels[channelName] = channel;
    return channel;
  }

  /// Subscribe to user presence
  RealtimeChannel subscribeToPresence(String conversationId, void Function(String, bool) onPresenceChange) {
    final channelName = 'presence-$conversationId';

    if (_channels.containsKey(channelName)) {
      return _channels[channelName]!;
    }

    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final userId = payload.newRecord['id'] as String;
            final isOnline = payload.newRecord['is_online'] as bool;
            onPresenceChange(userId, isOnline);
          },
        )
        .subscribe();

    _channels[channelName] = channel;
    return channel;
  }

  /// Subscribe to conversation changes
  RealtimeChannel subscribeToConversationChanges(void Function(Map<String, dynamic>) onConversationChange) {
    const channelName = 'conversation-changes';

    if (_channels.containsKey(channelName)) {
      return _channels[channelName]!;
    }

    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          callback: (payload) {
            onConversationChange(payload.newRecord);
          },
        )
        .subscribe();

    _channels[channelName] = channel;
    return channel;
  }

  /// Unsubscribe from a specific channel
  void unsubscribe(String channelName) {
    final channel = _channels.remove(channelName);
    channel?.unsubscribe();
  }

  /// Unsubscribe from all channels
  void unsubscribeAll() {
    for (final channel in _channels.values) {
      channel.unsubscribe();
    }
    _channels.clear();
  }
}

/// Realtime service provider
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService(Supabase.instance.client);
});