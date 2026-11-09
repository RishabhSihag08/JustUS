// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUploadDto _$MediaUploadDtoFromJson(Map<String, dynamic> json) =>
    MediaUploadDto(
      id: json['id'] as String,
      messageId: json['message_id'] as String,
      userId: json['user_id'] as String,
      bucketPath: json['bucket_path'] as String,
      uploadStatus: json['upload_status'] as String,
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MediaUploadDtoToJson(MediaUploadDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message_id': instance.messageId,
      'user_id': instance.userId,
      'bucket_path': instance.bucketPath,
      'upload_status': instance.uploadStatus,
      'retry_count': instance.retryCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
