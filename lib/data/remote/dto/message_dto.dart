import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/message.dart';
import '../../../domain/enums.dart';

part 'message_dto.g.dart';

/// Supabase message DTO with snake_case mapping
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MessageDto {
  final String id;
  final String conversationId;
  final String senderId;
  final String type;
  final String? content;
  final String? mediaUrl;
  final String? mediaThumbnailUrl;
  final int? mediaDuration;
  final int? mediaSize;
  final String? mediaMimeType;
  final String? replyToId;
  final String status;
  final bool isStarred;
  final bool isDisappearing;
  final DateTime? expiresAt;
  final bool viewOnceViewed;
  final DateTime? viewOnceViewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  const MessageDto({
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

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  /// Convert to domain model
  Message toDomain() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      type: MessageType.values.firstWhere(
        (e) => e.name == type || (e == MessageType.viewOnce && type == 'view_once'),
        orElse: () => MessageType.text,
      ),
      content: content,
      mediaUrl: mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl,
      mediaDuration: mediaDuration,
      mediaSize: mediaSize,
      mediaMimeType: mediaMimeType,
      replyToId: replyToId,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => MessageStatus.pending,
      ),
      isStarred: isStarred,
      isDisappearing: isDisappearing,
      expiresAt: expiresAt?.toLocal(),
      viewOnceViewed: viewOnceViewed,
      viewOnceViewedAt: viewOnceViewedAt?.toLocal(),
      createdAt: createdAt.toLocal(),
      updatedAt: updatedAt.toLocal(),
      deliveredAt: deliveredAt?.toLocal(),
      readAt: readAt?.toLocal(),
    );
  }

  /// Create DTO from domain model
  static MessageDto fromDomain(Message message) {
    return MessageDto(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      type: message.type == MessageType.viewOnce ? 'view_once' : message.type.name,
      content: message.content,
      mediaUrl: message.mediaUrl,
      mediaThumbnailUrl: message.mediaThumbnailUrl,
      mediaDuration: message.mediaDuration,
      mediaSize: message.mediaSize,
      mediaMimeType: message.mediaMimeType,
      replyToId: message.replyToId,
      status: message.status.name,
      isStarred: message.isStarred,
      isDisappearing: message.isDisappearing,
      expiresAt: message.expiresAt?.toUtc(),
      viewOnceViewed: message.viewOnceViewed,
      viewOnceViewedAt: message.viewOnceViewedAt?.toUtc(),
      createdAt: message.createdAt.toUtc(),
      updatedAt: message.updatedAt.toUtc(),
      deliveredAt: message.deliveredAt?.toUtc(),
      readAt: message.readAt?.toUtc(),
    );
  }
}