import 'package:equatable/equatable.dart';

/// Conversation domain model
class Conversation extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final Duration? disappearingTimer;
  final bool viewOnceEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.disappearingTimer,
    this.viewOnceEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    Duration? disappearingTimer,
    bool? viewOnceEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      disappearingTimer: disappearingTimer ?? this.disappearingTimer,
      viewOnceEnabled: viewOnceEnabled ?? this.viewOnceEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get the other user's ID given current user ID
  String? getOtherUserId(String currentUserId) {
    if (user1Id == currentUserId) return user2Id;
    if (user2Id == currentUserId) return user1Id;
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        disappearingTimer,
        viewOnceEnabled,
        createdAt,
        updatedAt,
      ];
}