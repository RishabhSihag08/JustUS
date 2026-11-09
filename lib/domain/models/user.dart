import 'package:equatable/equatable.dart';
import '../../domain/enums.dart';

/// User domain model
class User extends Equatable {
  final String id;
  final UserRole role;
  final String pinHash;
  final String? displayName;
  final String? avatarUrl;
  final String? fcmToken;
  final DateTime? lastSeenAt;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.role,
    required this.pinHash,
    this.displayName,
    this.avatarUrl,
    this.fcmToken,
    this.lastSeenAt,
    this.isOnline = false,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    UserRole? role,
    String? pinHash,
    String? displayName,
    String? avatarUrl,
    String? fcmToken,
    DateTime? lastSeenAt,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted last seen string
  String getLastSeenString() {
    if (isOnline) return 'Online';
    if (lastSeenAt == null) return 'Last seen long ago';

    final diff = DateTime.now().difference(lastSeenAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return 'Last seen ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Last seen ${diff.inHours} hours ago';
    if (diff.inDays < 7) return 'Last seen ${diff.inDays} days ago';
    return 'Last seen ${(diff.inDays / 7).floor()} weeks ago';
  }

  @override
  List<Object?> get props => [
        id,
        role,
        pinHash,
        displayName,
        avatarUrl,
        fcmToken,
        lastSeenAt,
        isOnline,
        createdAt,
        updatedAt,
      ];
}