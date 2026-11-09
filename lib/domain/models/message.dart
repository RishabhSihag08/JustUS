import 'package:equatable/equatable.dart';

import '../../domain/enums.dart';

/// Message domain model
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final MessageType type;
  final String? content;
  final String? mediaUrl;
  final String? mediaThumbnailUrl;
  final int? mediaDuration;
  final int? mediaSize;
  final String? mediaMimeType;
  final String? replyToId;
  final MessageStatus status;
  final bool isStarred;
  final bool isDisappearing;
  final DateTime? expiresAt;
  final bool viewOnceViewed;
  final DateTime? viewOnceViewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    this.content,
    this.mediaUrl,
    this.mediaThumbnailUrl,
    this.mediaDuration,
    this.mediaSize,
    this.mediaMimeType,
    this.replyToId,
    required this.status,
    this.isStarred = false,
    this.isDisappearing = false,
    this.expiresAt,
    this.viewOnceViewed = false,
    this.viewOnceViewedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
    this.readAt,
  });

  /// Creates a copy with modified fields
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    MessageType? type,
    String? content,
    String? mediaUrl,
    String? mediaThumbnailUrl,
    int? mediaDuration,
    int? mediaSize,
    String? mediaMimeType,
    String? replyToId,
    MessageStatus? status,
    bool? isStarred,
    bool? isDisappearing,
    DateTime? expiresAt,
    bool? viewOnceViewed,
    DateTime? viewOnceViewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl ?? this.mediaThumbnailUrl,
      mediaDuration: mediaDuration ?? this.mediaDuration,
      mediaSize: mediaSize ?? this.mediaSize,
      mediaMimeType: mediaMimeType ?? this.mediaMimeType,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
      isStarred: isStarred ?? this.isStarred,
      isDisappearing: isDisappearing ?? this.isDisappearing,
      expiresAt: expiresAt ?? this.expiresAt,
      viewOnceViewed: viewOnceViewed ?? this.viewOnceViewed,
      viewOnceViewedAt: viewOnceViewedAt ?? this.viewOnceViewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
    );
  }

  /// Check if message is sent by current user
  bool isSentBy(String userId) => senderId == userId;

  /// Check if message is a media type
  bool get isMedia => type != MessageType.text;

  /// Check if message is view-once
  bool get isViewOnce => type == MessageType.viewOnce;

  /// Check if message has expired (disappearing)
  bool get hasExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        type,
        content,
        mediaUrl,
        mediaThumbnailUrl,
        mediaDuration,
        mediaSize,
        mediaMimeType,
        replyToId,
        status,
        isStarred,
        isDisappearing,
        expiresAt,
        viewOnceViewed,
        viewOnceViewedAt,
        createdAt,
        updatedAt,
        deliveredAt,
        readAt,
      ];
}

