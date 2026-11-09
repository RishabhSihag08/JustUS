// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String,
  type: json['type'] as String,
  content: json['content'] as String?,
  mediaUrl: json['media_url'] as String?,
  mediaThumbnailUrl: json['media_thumbnail_url'] as String?,
  mediaDuration: (json['media_duration'] as num?)?.toInt(),
  mediaSize: (json['media_size'] as num?)?.toInt(),
  mediaMimeType: json['media_mime_type'] as String?,
  replyToId: json['reply_to_id'] as String?,
  status: json['status'] as String,
  isStarred: json['is_starred'] as bool? ?? false,
  isDisappearing: json['is_disappearing'] as bool? ?? false,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  viewOnceViewed: json['view_once_viewed'] as bool? ?? false,
  viewOnceViewedAt: json['view_once_viewed_at'] == null
      ? null
      : DateTime.parse(json['view_once_viewed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deliveredAt: json['delivered_at'] == null
      ? null
      : DateTime.parse(json['delivered_at'] as String),
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'type': instance.type,
      'content': instance.content,
      'media_url': instance.mediaUrl,
      'media_thumbnail_url': instance.mediaThumbnailUrl,
      'media_duration': instance.mediaDuration,
      'media_size': instance.mediaSize,
      'media_mime_type': instance.mediaMimeType,
      'reply_to_id': instance.replyToId,
      'status': instance.status,
      'is_starred': instance.isStarred,
      'is_disappearing': instance.isDisappearing,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'view_once_viewed': instance.viewOnceViewed,
      'view_once_viewed_at': instance.viewOnceViewedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
    };
