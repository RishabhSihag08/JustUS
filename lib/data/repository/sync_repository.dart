import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';
import '../local/database.dart';
import '../local/daos/messages_dao.dart';
import '../local/daos/conversations_dao.dart';
import '../local/daos/users_dao.dart';
import '../local/daos/reactions_dao.dart';
import '../local/daos/starred_messages_dao.dart';
import '../remote/dto/message_dto.dart';
import '../remote/dto/user_dto.dart';
import '../remote/dto/conversation_dto.dart';
import '../remote/dto/reaction_dto.dart';
import '../remote/dto/starred_message_dto.dart';
import '../../domain/models/message.dart';
import '../../../core/security/secure_storage_service.dart';

/// Repository for background synchronization
class SyncRepository {
  final AppDatabase _database;
  final SupabaseClient _supabase;
  // ignore: unused_field
  final SecureStorageService _secureStorage;

  SyncRepository(this._database, this._supabase, this._secureStorage);

  MessagesDao get _messagesDao => _database.messagesDao;
  ConversationsDao get _conversationsDao => _database.conversationsDao;
  UsersDao get _usersDao => _database.usersDao;
  ReactionsDao get _reactionsDao => _database.reactionsDao;
  StarredMessagesDao get _starredDao => _database.starredMessagesDao;

  /// Perform full sync from remote to local
  Future<void> performFullSync() async {
    final lastSync = await SecureStorageService.readLastSyncAt();
    final since = lastSync?.toIso8601String();

    await syncUsers(since);
    await syncConversation(since);
    await syncMessages(since);
    await syncReactions(since);
    await syncStarredMessages(since);

    await SecureStorageService.saveLastSyncAt(DateTime.now());
  }

  /// Sync users table
  Future<void> syncUsers([String? since]) async {
    try {
      var query = _supabase.from('users').select();
      if (since != null) {
        query = query.gte('updated_at', since);
      }
      final response = await query;
      final users = (response as List).map((u) => UserDto.fromJson(u).toDomain()).toList();

      for (final user in users) {
        await _usersDao.upsertUser(UsersTableCompanion(
          id: Value(user.id),
          role: Value(user.role.name),
          pinHash: Value(user.pinHash),
          displayName: Value(user.displayName),
          avatarUrl: Value(user.avatarUrl),
          fcmToken: Value(user.fcmToken),
          lastSeenAt: Value(user.lastSeenAt),
          isOnline: Value(user.isOnline),
          createdAt: Value(user.createdAt),
          updatedAt: Value(user.updatedAt),
        ));
      }
    } catch (_) {}
  }

  /// Sync conversation table
  Future<void> syncConversation([String? since]) async {
    try {
      var query = _supabase.from('conversations').select();
      if (since != null) {
        query = query.gte('updated_at', since);
      }
      final response = await query;
      final conversations = (response as List).map((c) => ConversationDto.fromJson(c).toDomain()).toList();

      for (final conv in conversations) {
        await _conversationsDao.upsertConversation(ConversationsTableCompanion(
          id: Value(conv.id),
          user1Id: Value(conv.user1Id),
          user2Id: Value(conv.user2Id),
          disappearingTimer: conv.disappearingTimer != null
              ? Value(conv.disappearingTimer!.inSeconds)
              : const Value.absent(),
          viewOnceEnabled: Value(conv.viewOnceEnabled),
          createdAt: Value(conv.createdAt),
          updatedAt: Value(conv.updatedAt),
        ));
      }
    } catch (_) {}
  }

  /// Sync messages table
  Future<void> syncMessages([String? since]) async {
    try {
      final base = _supabase.from('messages').select();
      final response = since != null
          ? await base.gte('updated_at', since).order('created_at', ascending: true)
          : await base.order('created_at', ascending: true);
      final messages = (response as List).map((m) => MessageDto.fromJson(m).toDomain()).toList();

      if (messages.isNotEmpty) {
        await _messagesDao.insertAllMessages(
          messages.map(_messageToCompanion).toList(),
        );
      }
    } catch (_) {}
  }

  /// Sync reactions table
  Future<void> syncReactions([String? since]) async {
    try {
      var query = _supabase.from('reactions').select();
      if (since != null) {
        query = query.gte('created_at', since);
      }
      final response = await query;
      final reactions = (response as List).map((r) => ReactionDto.fromJson(r).toDomain()).toList();

      for (final reaction in reactions) {
        await _reactionsDao.upsertReaction(ReactionsTableCompanion(
          messageId: Value(reaction.messageId),
          userId: Value(reaction.userId),
          emoji: Value(reaction.emoji),
          createdAt: Value(reaction.createdAt),
        ));
      }
    } catch (_) {}
  }

  /// Sync starred messages table
  Future<void> syncStarredMessages([String? since]) async {
    try {
      var query = _supabase.from('starred_messages').select();
      if (since != null) {
        query = query.gte('created_at', since);
      }
      final response = await query;
      final starred = (response as List).map((s) => StarredMessageDto.fromJson(s).toDomain()).toList();

      for (final s in starred) {
        await _starredDao.starMessage(s.messageId, s.userId);
      }
    } catch (_) {}
  }

  /// Convert domain Message to Drift companion
  MessagesTableCompanion _messageToCompanion(Message message) {
    return MessagesTableCompanion(
      id: Value(message.id),
      conversationId: Value(message.conversationId),
      senderId: Value(message.senderId),
      type: Value(message.type.name),
      content: Value(message.content),
      mediaUrl: Value(message.mediaUrl),
      mediaThumbnailUrl: Value(message.mediaThumbnailUrl),
      mediaDuration: Value(message.mediaDuration),
      mediaSize: Value(message.mediaSize),
      mediaMimeType: Value(message.mediaMimeType),
      replyToId: Value(message.replyToId),
      status: Value(message.status.name),
      isStarred: Value(message.isStarred),
      isDisappearing: Value(message.isDisappearing),
      expiresAt: Value(message.expiresAt),
      viewOnceViewed: Value(message.viewOnceViewed),
      viewOnceViewedAt: Value(message.viewOnceViewedAt),
      createdAt: Value(message.createdAt),
      updatedAt: Value(message.updatedAt),
      deliveredAt: Value(message.deliveredAt),
      readAt: Value(message.readAt),
    );
  }
}