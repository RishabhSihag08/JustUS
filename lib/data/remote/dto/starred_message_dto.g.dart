// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarredMessageDto _$StarredMessageDtoFromJson(Map<String, dynamic> json) =>
    StarredMessageDto(
      messageId: json['message_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StarredMessageDtoToJson(StarredMessageDto instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
    };
