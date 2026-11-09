// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_indicator_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypingIndicatorDto _$TypingIndicatorDtoFromJson(Map<String, dynamic> json) =>
    TypingIndicatorDto(
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      isTyping: json['is_typing'] as bool? ?? false,
      isRecording: json['is_recording'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TypingIndicatorDtoToJson(TypingIndicatorDto instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'user_id': instance.userId,
      'is_typing': instance.isTyping,
      'is_recording': instance.isRecording,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
