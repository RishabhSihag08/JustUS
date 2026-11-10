import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/security/session_manager.dart';
import '../../data/repository/chat_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../../data/remote/dto/message_dto.dart';
import '../../data/local/database.dart';
import '../../data/local/daos/messages_dao.dart';
import '../../domain/models/message.dart';
import '../../domain/models/user.dart';
import '../../domain/models/reaction.dart';
import '../../domain/models/typing_indicator.dart';
import '../../domain/enums.dart';
import 'chat_state.dart';
import '../../../providers/repository_providers.dart';

part 'chat_notifier.g.dart';

/// Alias for generated chatProvider
final chatNotifierProvider = chatProvider;

/// Chat notifier provider
@riverpod
class ChatNotifier extends _$ChatNotifier {
  late final ChatRepository _repository;
  late final AppDatabase _database;
  late final GoRouter _router;

  StreamSubscription<dynamic>? _messagesSubscription;
  StreamSubscription<dynamic>? _reactionsSubscription;
  StreamSubscription<dynamic>? _typingSubscription;
  StreamSubscription<dynamic>? _presenceSubscription;
  Timer? _typingDebounceTimer;
  Timer? _recordingTimer;

  @override
  ChatState build() {
    _repository = ref.read(chatRepositoryProvider);
    _database = ref.read(databaseProvider);
    _router = ref.read(appRouterProvider);

    // Watch for session changes
    ref.listen(sessionManagerProvider, (previous, next) {
      if (next is SessionLocked) {
        _cleanup();
        _router.go('/pin');
      }
    });

    // Schedule initialization after provider build completes
    Future.microtask(() => _initializeChat());

    return const ChatState(isLoading: true);
  }

  /// Initialize chat by loading messages and subscribing to streams
  Future<void> _initializeChat() async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // Get conversation
      final conversation = await _repository.getOrCreateConversation();

      // Load other user
      final users = await _database.usersDao.getAllUsers();
      final otherUser = users.where((u) => u.id != userId).firstOrNull;

      // Subscribe to messages stream
      _messagesSubscription = _database.messagesDao
          .watchMessagesByConversation(conversation.id)
          .map((messages) => messages.map((m) => m.toDomain()).toList())
          .listen((messages) {
        state = state.copyWith(
          messages: messages,
          isLoading: false,
        );
      });

      // Subscribe to reactions
      _reactionsSubscription = _database.reactionsDao
          .watchAllReactions()
          .listen((reactionRows) {
        final Map<String, List<Reaction>> map = {};
        for (final r in reactionRows) {
          final domain = Reaction(
            messageId: r.messageId,
            userId: r.userId,
            emoji: r.emoji,
            createdAt: r.createdAt,
          );
          map.putIfAbsent(r.messageId, () => []).add(domain);
        }
        state = state.copyWith(reactionsByMessageId: map);
      });

      // Trigger background sync of reactions
      try {
        ref.read(syncRepositoryProvider).syncReactions();
      } catch (_) {}

      // Subscribe to typing indicators
      _typingSubscription = _database.typingIndicatorsDao
          .watchTypingForConversation(conversation.id)
          .listen((indicators) {
        // Create domain TypingIndicator from table data
        final otherIndicator = indicators.where((t) => t.userId != userId).firstOrNull;
        if (otherIndicator != null) {
          final domainIndicator = TypingIndicator.fromTableData(
            conversationId: otherIndicator.conversationId,
            userId: otherIndicator.userId,
            isTyping: otherIndicator.isTyping,
            isRecording: otherIndicator.isRecording,
          );
          state = state.copyWith(typingIndicator: domainIndicator);
        }
      });

      // Subscribe to presence
      _presenceSubscription = _database.usersDao.watchAllUsers().listen((users) {
        // Convert UsersTableData to domain User
        final other = users.where((u) => u.id != userId).firstOrNull;
        if (other != null) {
          final domainUser = User(
            id: other.id,
            role: UserRole.values.firstWhere(
              (e) => e.name == other.role,
              orElse: () => UserRole.user1,
            ),
            pinHash: other.pinHash,
            displayName: other.displayName,
            avatarUrl: other.avatarUrl,
            fcmToken: other.fcmToken,
            lastSeenAt: other.lastSeenAt,
            isOnline: other.isOnline,
            createdAt: other.createdAt,
            updatedAt: other.updatedAt,
          );
          state = state.copyWith(otherUser: domainUser);
        }
      });

      // Initialize realtime subscriptions
      await _initializeRealtime(conversation.id, userId);

      // Mark active user online and mark conversation as read
      unawaited(_repository.updateUserPresence(userId, true).catchError((_) {}));
      unawaited(markAsRead().catchError((_) {}));

      // Background sync from remote
      unawaited(ref.read(syncRepositoryProvider).performFullSync().catchError((_) {}));

      if (otherUser != null) {
        final domainUser = User(
          id: otherUser.id,
          role: UserRole.values.firstWhere(
            (e) => e.name == otherUser.role,
            orElse: () => UserRole.user1,
          ),
          pinHash: otherUser.pinHash,
          displayName: otherUser.displayName,
          avatarUrl: otherUser.avatarUrl,
          fcmToken: otherUser.fcmToken,
          lastSeenAt: otherUser.lastSeenAt,
          isOnline: otherUser.isOnline,
          createdAt: otherUser.createdAt,
          updatedAt: otherUser.updatedAt,
        );
        state = state.copyWith(
          otherUser: domainUser,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Initialize Supabase Realtime subscriptions
  Future<void> _initializeRealtime(String conversationId, String userId) async {
    final realtimeService = ref.read(realtimeServiceProvider);

    // Subscribe to messages
    realtimeService.subscribeToConversation(conversationId, (record, isDelete) async {
      try {
        if (isDelete) {
          final msgId = record['id'] as String?;
          if (msgId != null) {
            await _database.messagesDao.deleteMessage(msgId);
          }
          return;
        }

        final dto = MessageDto.fromJson(record);
        final domainMsg = dto.toDomain();
        await _database.messagesDao.insertMessage(
          MessagesTableCompanion(
            id: Value(domainMsg.id),
            conversationId: Value(domainMsg.conversationId),
            senderId: Value(domainMsg.senderId),
            type: Value(domainMsg.type.name),
            content: Value(domainMsg.content),
            mediaUrl: Value(domainMsg.mediaUrl),
            mediaThumbnailUrl: Value(domainMsg.mediaThumbnailUrl),
            mediaDuration: Value(domainMsg.mediaDuration),
            mediaSize: Value(domainMsg.mediaSize),
            mediaMimeType: Value(domainMsg.mediaMimeType),
            replyToId: Value(domainMsg.replyToId),
            status: Value(domainMsg.status.name),
            isStarred: Value(domainMsg.isStarred),
            isDisappearing: Value(domainMsg.isDisappearing),
            expiresAt: Value(domainMsg.expiresAt),
            viewOnceViewed: Value(domainMsg.viewOnceViewed),
            viewOnceViewedAt: Value(domainMsg.viewOnceViewedAt),
            createdAt: Value(domainMsg.createdAt),
            updatedAt: Value(domainMsg.updatedAt),
            deliveredAt: Value(domainMsg.deliveredAt),
            readAt: Value(domainMsg.readAt),
          ),
        );

        // If incoming message from partner, acknowledge read
        if (domainMsg.senderId != userId) {
          unawaited(markAsRead().catchError((_) {}));
        }
      } catch (_) {}
    });

    // Subscribe to typing indicators
    realtimeService.subscribeToTypingIndicators(conversationId, (payload) async {
      try {
        final otherUserId = payload['user_id'] as String?;
        final isTyping = payload['is_typing'] as bool? ?? false;
        final isRecording = payload['is_recording'] as bool? ?? false;
        if (otherUserId != null && otherUserId != userId) {
          if (isTyping || isRecording) {
            await _database.typingIndicatorsDao.upsertTypingIndicator(
              TypingIndicatorsTableCompanion(
                conversationId: Value(conversationId),
                userId: Value(otherUserId),
                isTyping: Value(isTyping),
                isRecording: Value(isRecording),
                updatedAt: Value(DateTime.now()),
              ),
            );
          } else {
            await _database.typingIndicatorsDao.clearTypingForUser(conversationId, otherUserId);
          }
        }
      } catch (_) {}
    });

    // Subscribe to reactions
    realtimeService.subscribeToReactions(conversationId, (record, isDelete) async {
      try {
        final msgId = record['message_id'] as String?;
        final uId = record['user_id'] as String?;
        final emoji = record['emoji'] as String?;
        if (msgId != null && uId != null && emoji != null) {
          if (isDelete) {
            await _database.reactionsDao.deleteReaction(msgId, uId, emoji);
          } else {
            await _database.reactionsDao.upsertReaction(
              ReactionsTableCompanion(
                messageId: Value(msgId),
                userId: Value(uId),
                emoji: Value(emoji),
                createdAt: Value(DateTime.now()),
              ),
            );
          }
        }
      } catch (_) {}
    });

    // Subscribe to presence
    realtimeService.subscribeToPresence(conversationId, (otherUserId, isOnline) async {
      try {
        if (otherUserId != userId) {
          await _database.usersDao.updateOnlineStatus(otherUserId, isOnline, DateTime.now());
          if (state.otherUser?.id == otherUserId) {
            state = state.copyWith(
              otherUser: state.otherUser?.copyWith(
                isOnline: isOnline,
                lastSeenAt: DateTime.now(),
              ),
            );
          }
        }
      } catch (_) {}
    });
  }

  /// Load more messages for pagination
  Future<void> loadMoreMessages() async {
    if (state.isLoading || !state.hasMoreMessages) return;

    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final conversation = await _repository.getOrCreateConversation();

    try {
      final moreMessages = await _database.messagesDao.getMessagesByConversationPaged(
        conversation.id,
        50,
        state.messages.length,
      );

      if (moreMessages.isEmpty) {
        state = state.copyWith(hasMoreMessages: false);
        return;
      }

      final domainMessages = moreMessages.map((m) => m.toDomain()).toList();
      state = state.copyWith(
        messages: [...domainMessages, ...state.messages],
        hasMoreMessages: moreMessages.length == 50,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Send a text message
  Future<void> sendTextMessage(String text) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null || text.trim().isEmpty) return;

    final replyToMessage = state.replyingTo;

    // Cancel reply/edit mode
    cancelReply();
    cancelEdit();

    final conversation = await _repository.getOrCreateConversation();
    final isDisappearing = conversation.disappearingTimer != null;
    final expiresAt = isDisappearing ? DateTime.now().add(conversation.disappearingTimer!) : null;

    final message = Message(
      id: const Uuid().v4(),
      conversationId: conversation.id,
      senderId: userId,
      type: MessageType.text,
      content: text.trim(),
      status: MessageStatus.pending,
      replyToId: replyToMessage?.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDisappearing: isDisappearing,
      expiresAt: expiresAt,
    );

    // Optimistically add to local state
    state = state.copyWith(messages: [...state.messages, message], replyingTo: null);

    // Send via repository (handles Drift + Supabase)
    await _repository.sendTextMessage(message);
  }

  /// Send a media message
  Future<void> sendMediaMessage(
    String localPath,
    MessageType type, {
    String? caption,
    bool isViewOnce = false,
  }) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final conversation = await _repository.getOrCreateConversation();
    final isDisappearing = conversation.disappearingTimer != null;
    final expiresAt = isDisappearing ? DateTime.now().add(conversation.disappearingTimer!) : null;
    final messageType = isViewOnce ? MessageType.viewOnce : type;
    final messageId = const Uuid().v4();

    final message = Message(
      id: messageId,
      conversationId: conversation.id,
      senderId: userId,
      type: messageType,
      content: caption ?? '',
      mediaUrl: localPath, // Will be replaced with remote URL after upload
      status: MessageStatus.pending,
      isDisappearing: isDisappearing,
      expiresAt: expiresAt,
      viewOnceViewed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Optimistically add to local state
    state = state.copyWith(messages: [...state.messages, message]);

    // Send via repository
    await _repository.sendMediaMessage(
      localPath,
      messageType.name,
      caption: caption,
      isViewOnce: isViewOnce,
      senderId: userId,
      messageId: messageId,
    );
  }

  /// Send a voice note
  Future<void> sendVoiceNote(String audioPath, Duration duration) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final conversation = await _repository.getOrCreateConversation();
    final isDisappearing = conversation.disappearingTimer != null;
    final expiresAt = isDisappearing ? DateTime.now().add(conversation.disappearingTimer!) : null;
    final messageId = const Uuid().v4();

    final message = Message(
      id: messageId,
      conversationId: conversation.id,
      senderId: userId,
      type: MessageType.voice,
      content: 'Voice note',
      mediaUrl: audioPath,
      mediaDuration: duration.inMilliseconds,
      mediaMimeType: 'audio/m4a',
      status: MessageStatus.pending,
      isDisappearing: isDisappearing,
      expiresAt: expiresAt,
      viewOnceViewed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Optimistically add to local state
    state = state.copyWith(messages: [...state.messages, message]);

    await _repository.sendVoiceNote(
      audioPath,
      duration,
      senderId: userId,
      messageId: messageId,
    );
  }

  /// Delete all chat history permanently from local DB and remote database/storage
  Future<void> clearAllChatHistory() async {
    final conversation = await _repository.getOrCreateConversation();
    await _repository.masterDeleteAllChat(conversation.id);
    state = state.copyWith(
      messages: [],
      reactionsByMessageId: {},
      starredMessageIds: {},
      replyingTo: null,
      editingMessage: null,
    );
  }

  /// Start replying to a message
  void startReply(Message message) {
    state = state.copyWith(replyingTo: message);
  }

  /// Cancel reply mode
  void cancelReply() {
    state = state.copyWith(replyingTo: null);
  }

  /// Start editing a message
  void startEdit(Message message) {
    state = state.copyWith(editingMessage: message);
  }

  /// Confirm edit
  Future<void> confirmEdit(String newContent) async {
    final editing = state.editingMessage;
    if (editing == null || newContent.trim().isEmpty) return;

    await _repository.editMessage(editing.id, newContent.trim());
    cancelEdit();
  }

  /// Cancel edit mode
  void cancelEdit() {
    state = state.copyWith(editingMessage: null);
  }

  /// Delete message for current user only
  Future<void> deleteForMe(String messageId) async {
    await _repository.deleteMessageForMe(messageId);
  }

  /// Delete message for everyone
  Future<void> deleteForEveryone(String messageId) async {
    await _repository.deleteMessageForEveryone(messageId);
  }

  /// Toggle star on a message
  Future<void> toggleStar(String messageId) async {
    final isStarred = state.starredMessageIds.contains(messageId);
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };
    await _repository.starMessage(messageId, userId, !isStarred);

    final newStarred = Set<String>.from(state.starredMessageIds);
    if (isStarred) {
      newStarred.remove(messageId);
    } else {
      newStarred.add(messageId);
    }
    state = state.copyWith(starredMessageIds: newStarred);
  }

  /// Add or toggle a reaction on a message
  Future<void> addReaction(String messageId, String emoji) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final currentReactions = state.reactionsByMessageId[messageId] ?? [];
    final alreadyReacted = currentReactions.any((r) => r.userId == userId && r.emoji == emoji);

    if (alreadyReacted) {
      await removeReaction(messageId, emoji);
    } else {
      final reaction = Reaction(
        messageId: messageId,
        userId: userId,
        emoji: emoji,
        createdAt: DateTime.now(),
      );

      // Optimistic update
      final updatedList = [
        ...currentReactions.where((r) => !(r.userId == userId && r.emoji == emoji)),
        reaction,
      ];
      final newMap = Map<String, List<Reaction>>.from(state.reactionsByMessageId);
      newMap[messageId] = updatedList;
      state = state.copyWith(reactionsByMessageId: newMap);

      await _repository.addReaction(reaction);
    }
  }

  /// Remove a reaction from a message
  Future<void> removeReaction(String messageId, String emoji) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    // Optimistic update
    final currentReactions = state.reactionsByMessageId[messageId] ?? [];
    final updatedList = currentReactions.where((r) => !(r.userId == userId && r.emoji == emoji)).toList();
    final newMap = Map<String, List<Reaction>>.from(state.reactionsByMessageId);
    if (updatedList.isEmpty) {
      newMap.remove(messageId);
    } else {
      newMap[messageId] = updatedList;
    }
    state = state.copyWith(reactionsByMessageId: newMap);

    await _repository.removeReaction(messageId, userId, emoji);
  }

  /// Mark view-once message as viewed
  Future<void> markViewOnceViewed(String messageId) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };
    await _repository.markViewOnceViewed(messageId, userId);
  }

  /// Update typing indicator (debounced)
  void updateTyping(bool isTyping) {
    _typingDebounceTimer?.cancel();

    if (isTyping) {
      // Send typing indicator immediately
      _sendTypingIndicator(true, false);
    } else {
      // Debounce the "stopped typing" signal
      _typingDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _sendTypingIndicator(false, false);
      });
    }
  }

  /// Send typing indicator to Supabase
  Future<void> _sendTypingIndicator(bool isTyping, bool isRecording) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final conversation = await _repository.getOrCreateConversation();
    await _repository.updateTypingIndicator(conversation.id, userId, isTyping, isRecording);
  }

  /// Start recording voice note
  void startRecording() {
    state = state.copyWith(
      isRecordingAudio: true,
      recordingDuration: Duration.zero,
    );

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(recordingDuration: Duration(seconds: timer.tick));
    });

    _sendTypingIndicator(false, true);
  }

  /// Stop recording voice note
  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    final duration = state.recordingDuration;
    state = state.copyWith(
      isRecordingAudio: false,
      recordingDuration: Duration.zero,
    );

    _sendTypingIndicator(false, false);

    if (duration.inSeconds >= 1) {
      // Recording is valid, send it
      // The actual audio file path would come from the record plugin
      // For now, we'll just update typing indicator
    }
  }

  /// Cancel recording
  void cancelRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    state = state.copyWith(
      isRecordingAudio: false,
      recordingDuration: Duration.zero,
    );

    _sendTypingIndicator(false, false);
  }

  /// Search messages
  Future<List<Message>> searchMessages(String query) async {
    if (query.trim().isEmpty) return [];

    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return [];

    final conversation = await _repository.getOrCreateConversation();
    return _repository.searchMessages(conversation.id, query);
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Mark conversation as read
  Future<void> markAsRead() async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;

    final conversation = await _repository.getOrCreateConversation();
    await _repository.markConversationRead(conversation.id, userId);
  }

  /// Update user presence online/offline
  Future<void> setPresence(bool isOnline) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => null,
    };

    if (userId == null) return;
    await _repository.updateUserPresence(userId, isOnline);
  }

  /// Set disappearing messages timer
  Future<void> setDisappearingTimer(Duration? timer) async {
    final conversation = await _repository.getOrCreateConversation();
    await _repository.setDisappearingTimer(conversation.id, timer);
  }

  /// Clean up resources
  void _cleanup() {
    _messagesSubscription?.cancel();
    _reactionsSubscription?.cancel();
    _typingSubscription?.cancel();
    _presenceSubscription?.cancel();
    _typingDebounceTimer?.cancel();
    _recordingTimer?.cancel();

    final realtimeService = ref.read(realtimeServiceProvider);
    realtimeService.unsubscribeAll();
  }

  void dispose() {
    _cleanup();
  }
}

/// Router provider for navigation
final routerProvider = Provider<GoRouter>((ref) {
  // This will be overridden in app.dart
  throw UnimplementedError('Router not initialized');
});