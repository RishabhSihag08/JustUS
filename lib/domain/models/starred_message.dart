import 'package:equatable/equatable.dart';

/// Starred message domain model
class StarredMessage extends Equatable {
  final String messageId;
  final String userId;
  final DateTime createdAt;

  const StarredMessage({
    required this.messageId,
    required this.userId,
    required this.createdAt,
  });

  StarredMessage copyWith({
    String? messageId,
    String? userId,
    DateTime? createdAt,
  }) {
    return StarredMessage(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [messageId, userId, createdAt];
}