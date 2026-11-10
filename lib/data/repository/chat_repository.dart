import '../../../domain/models/message.dart';
import '../../../domain/models/conversation.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/reaction.dart';

/// Abstract interface for chat repository
abstract class ChatRepository {
  /// Verify PIN and return user if valid
  Future<User?> verifyPin(String pin);

  /// Sign in with Supabase using user credentials
  Future<void> signInWithSupabase(String userId);

  /// Sign out from Supabase
  Future<void> signOut();

  /// Get or create the single conversation
  Future<Conversation> getOrCreateConversation();

  /// Send a text message
  Future<void> sendTextMessage(Message message);

  /// Send a media message (image, video, voice, document, view-once)
  Future<void> sendMediaMessage(String localPath, String type, {String? caption, bool isViewOnce = false, String? senderId, String? messageId});

  /// Send a voice note
  Future<void> sendVoiceNote(String audioPath, Duration duration, {String? senderId, String? messageId});

  /// Update message delivery status
  Future<void> updateMessageStatus(String messageId, String status);

  /// Mark conversation as read
  Future<void> markConversationRead(String conversationId, String userId);

  /// Add a reaction to a message
  Future<void> addReaction(Reaction reaction);

  /// Remove a reaction from a message
  Future<void> removeReaction(String messageId, String userId, String emoji);

  /// Star or unstar a message
  Future<void> starMessage(String messageId, String userId, bool starred);

  /// Edit a message
  Future<void> editMessage(String messageId, String newContent);

  /// Delete message for current user only
  Future<void> deleteMessageForMe(String messageId);

  /// Delete message for everyone
  Future<void> deleteMessageForEveryone(String messageId);

  /// Set disappearing messages timer
  Future<void> setDisappearingTimer(String conversationId, Duration? timer);

  /// Mark view-once message as viewed
  Future<void> markViewOnceViewed(String messageId, String viewerId);

  /// Search messages using FTS5
  Future<List<Message>> searchMessages(String conversationId, String query);

  /// Get starred messages for a user
  Future<List<Message>> getStarredMessages(String userId);

  /// Update user presence (online/offline)
  Future<void> updateUserPresence(String userId, bool isOnline);

  /// Update typing/recording indicator
  Future<void> updateTypingIndicator(String conversationId, String userId, bool isTyping, bool isRecording);

  /// Update FCM token
  Future<void> updateFcmToken(String userId, String token, String deviceId);

  /// Export encrypted backup
  Future<String> exportEncryptedBackup(String userId);

  /// Import encrypted backup
  Future<void> importEncryptedBackup(String userId, String filePath);

  /// Clear chat history for conversation
  Future<void> clearChat(String conversationId);

  /// Master delete all chat history from both local device and remote Supabase database
  Future<void> masterDeleteAllChat(String conversationId);
}