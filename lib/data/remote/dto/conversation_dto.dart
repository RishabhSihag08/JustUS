import '../../../domain/models/conversation.dart';

/// Supabase conversation DTO
class ConversationDto {
  final String id;
  final String user1Id;
  final String user2Id;
  final int? disappearingTimer;
  final bool viewOnceEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.disappearingTimer,
    this.viewOnceEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
      id: json['id'] as String,
      user1Id: (json['user_1_id'] ?? json['user1_id'] ?? '') as String,
      user2Id: (json['user_2_id'] ?? json['user2_id'] ?? '') as String,
      disappearingTimer: (json['disappearing_timer'] as num?)?.toInt(),
      viewOnceEnabled: json['view_once_enabled'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_1_id': user1Id,
    'user_2_id': user2Id,
    'disappearing_timer': disappearingTimer,
    'view_once_enabled': viewOnceEnabled,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Conversation toDomain() {
    return Conversation(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      disappearingTimer: disappearingTimer != null ? Duration(seconds: disappearingTimer!) : null,
      viewOnceEnabled: viewOnceEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ConversationDto fromDomain(Conversation conversation) {
    return ConversationDto(
      id: conversation.id,
      user1Id: conversation.user1Id,
      user2Id: conversation.user2Id,
      disappearingTimer: conversation.disappearingTimer?.inSeconds,
      viewOnceEnabled: conversation.viewOnceEnabled,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }
}