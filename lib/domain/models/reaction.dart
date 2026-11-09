import 'package:equatable/equatable.dart';

/// Reaction domain model
class Reaction extends Equatable {
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAt;

  const Reaction({
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  Reaction copyWith({
    String? messageId,
    String? userId,
    String? emoji,
    DateTime? createdAt,
  }) {
    return Reaction(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [messageId, userId, emoji, createdAt];
}