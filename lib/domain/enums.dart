/// Shared enums used by both domain models and Drift tables
/// This prevents type mismatches between generated Drift code and domain models
library;

/// Message type enum
enum MessageType {
  text,
  image,
  video,
  voice,
  document,
  viewOnce,
}

/// Message status enum
enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
}

/// User role enum
enum UserRole {
  user1,
  user2,
}

/// Reaction type (for future extensibility)
enum ReactionType {
  emoji,
  custom,
}

/// Media type for uploads
enum MediaUploadType {
  image,
  video,
  audio,
  document,
}

/// Media upload status
enum MediaUploadStatus {
  pending,
  uploading,
  uploaded,
  failed,
}