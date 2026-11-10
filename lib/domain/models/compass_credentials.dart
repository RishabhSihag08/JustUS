/// Model representing secret Compass credentials for a user
class CompassCredentials {
  final String userId;
  final String role; // 'user_1' or 'user_2'
  final double heading;
  final String pin;

  const CompassCredentials({
    required this.userId,
    required this.role,
    required this.heading,
    required this.pin,
  });

  CompassCredentials copyWith({
    String? userId,
    String? role,
    double? heading,
    String? pin,
  }) {
    return CompassCredentials(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      heading: heading ?? this.heading,
      pin: pin ?? this.pin,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'role': role,
    'compass_heading': heading,
    'pin': pin,
  };

  factory CompassCredentials.fromJson(Map<String, dynamic> json) {
    return CompassCredentials(
      userId: (json['id'] ?? json['user_id'] ?? '').toString(),
      role: (json['role'] ?? 'user_1').toString(),
      heading: (json['compass_heading'] as num?)?.toDouble() ??
          (json['role'] == 'user_2' ? 260.0 : 120.0),
      pin: (json['pin'] ?? json['pin_hash'] ?? (json['role'] == 'user_2' ? '5678' : '1234')).toString(),
    );
  }
}
