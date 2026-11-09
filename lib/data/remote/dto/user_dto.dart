import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/user.dart';
import '../../../domain/enums.dart';

part 'user_dto.g.dart';

/// Supabase user DTO
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserDto {
  final String id;
  final String role;
  final String pinHash;
  final String? displayName;
  final String? avatarUrl;
  final String? fcmToken;
  final DateTime? lastSeenAt;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDto({
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

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  User toDomain() {
    return User(
      id: id,
      role: UserRole.values.firstWhere(
        (e) => e.name == role || (role == 'user_1' && e == UserRole.user1) || (role == 'user_2' && e == UserRole.user2),
        orElse: () => UserRole.user1,
      ),
      pinHash: pinHash,
      displayName: displayName,
      avatarUrl: avatarUrl,
      fcmToken: fcmToken,
      lastSeenAt: lastSeenAt,
      isOnline: isOnline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static UserDto fromDomain(User user) {
    return UserDto(
      id: user.id,
      role: user.role.name,
      pinHash: user.pinHash,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      fcmToken: user.fcmToken,
      lastSeenAt: user.lastSeenAt,
      isOnline: user.isOnline,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}