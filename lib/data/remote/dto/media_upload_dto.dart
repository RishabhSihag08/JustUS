import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/media_upload.dart';

part 'media_upload_dto.g.dart';

/// Supabase media upload DTO
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MediaUploadDto {
  final String id;
  final String messageId;
  final String userId;
  final String bucketPath;
  final String uploadStatus;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MediaUploadDto({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.bucketPath,
    required this.uploadStatus,
    this.retryCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MediaUploadDto.fromJson(Map<String, dynamic> json) => _$MediaUploadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MediaUploadDtoToJson(this);

  MediaUpload toDomain() {
    return MediaUpload(
      id: id,
      messageId: messageId,
      userId: userId,
      bucketPath: bucketPath,
      status: UploadStatus.values.firstWhere(
        (e) => e.name == uploadStatus,
        orElse: () => UploadStatus.pending,
      ),
      retryCount: retryCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static MediaUploadDto fromDomain(MediaUpload upload) {
    return MediaUploadDto(
      id: upload.id,
      messageId: upload.messageId,
      userId: upload.userId,
      bucketPath: upload.bucketPath,
      uploadStatus: upload.status.name,
      retryCount: upload.retryCount,
      createdAt: upload.createdAt,
      updatedAt: upload.updatedAt,
    );
  }
}