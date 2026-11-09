import 'package:equatable/equatable.dart';

/// Typing indicator domain model
class TypingIndicator extends Equatable {
  final String conversationId;
  final String userId;
  final bool isTyping;
  final bool isRecording;

  const TypingIndicator({
    required this.conversationId,
    required this.userId,
    this.isTyping = false,
    this.isRecording = false,
  });

  TypingIndicator copyWith({
    String? conversationId,
    String? userId,
    bool? isTyping,
    bool? isRecording,
  }) {
    return TypingIndicator(
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      isTyping: isTyping ?? this.isTyping,
      isRecording: isRecording ?? this.isRecording,
    );
  }

  /// Get display text for the typing indicator
  String getDisplayText() {
    if (isRecording) return 'Recording audio...';
    if (isTyping) return 'typing...';
    return '';
  }

  /// Create a domain TypingIndicator from Drift table data fields
  factory TypingIndicator.fromTableData({
    required String conversationId,
    required String userId,
    required bool isTyping,
    required bool isRecording,
  }) {
    return TypingIndicator(
      conversationId: conversationId,
      userId: userId,
      isTyping: isTyping,
      isRecording: isRecording,
    );
  }

  @override
  List<Object?> get props => [conversationId, userId, isTyping, isRecording];
}