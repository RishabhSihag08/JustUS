// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionDto _$ReactionDtoFromJson(Map<String, dynamic> json) => ReactionDto(
  messageId: json['message_id'] as String,
  userId: json['user_id'] as String,
  emoji: json['emoji'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReactionDtoToJson(ReactionDto instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'user_id': instance.userId,
      'emoji': instance.emoji,
      'created_at': instance.createdAt.toIso8601String(),
    };
