import 'package:equatable/equatable.dart';

/// Media upload domain model
class MediaUpload extends Equatable {
  final String id;
  final String messageId;
  final String userId;
  final String bucketPath;
  final UploadStatus status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MediaUpload({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.bucketPath,
    this.status = UploadStatus.pending,
    this.retryCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  MediaUpload copyWith({
    String? id,
    String? messageId,
    String? userId,
    String? bucketPath,
    UploadStatus? status,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaUpload(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      bucketPath: bucketPath ?? this.bucketPath,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        messageId,
        userId,
        bucketPath,
        status,
        retryCount,
        createdAt,
        updatedAt,
      ];
}

/// Upload status enum
enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
}