import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/message.dart';
import '../../domain/models/user.dart';
import '../../domain/models/reaction.dart';
import '../../domain/models/typing_indicator.dart';

part 'chat_state.freezed.dart';

/// Chat state sealed class using Freezed
@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState({
    /// List of messages in the conversation
    @Default([]) List<Message> messages,

    /// Whether messages are currently loading
    @Default(false) bool isLoading,

    /// Whether there are more messages to load (pagination)
    @Default(true) bool hasMoreMessages,

    /// Message being replied to (quoted reply)
    Message? replyingTo,

    /// Message being edited
    Message? editingMessage,

    /// Reactions grouped by message ID
    @Default({}) Map<String, List<Reaction>> reactionsByMessageId,

    /// Set of starred message IDs for current user
    @Default({}) Set<String> starredMessageIds,

    /// Current typing/recording indicator from other user
    TypingIndicator? typingIndicator,

    /// The other user in the conversation
    User? otherUser,

    /// Whether currently recording a voice note
    @Default(false) bool isRecordingAudio,

    /// Current recording duration
    @Default(Duration.zero) Duration recordingDuration,

    /// Current search query
    @Default('') String searchQuery,

    /// Error message if any
    String? error,
  }) = _ChatState;
}