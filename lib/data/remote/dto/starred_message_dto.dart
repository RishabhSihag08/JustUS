import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/starred_message.dart';

part 'starred_message_dto.g.dart';

/// Supabase starred message DTO
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class StarredMessageDto {
  final String messageId;
  final String userId;
  final DateTime createdAt;

  const StarredMessageDto({
    required this.messageId,
    required this.userId,
    required this.createdAt,
  });

  factory StarredMessageDto.fromJson(Map<String, dynamic> json) => _$StarredMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StarredMessageDtoToJson(this);

  StarredMessage toDomain() {
    return StarredMessage(
      messageId: messageId,
      userId: userId,
      createdAt: createdAt,
    );
  }

  static StarredMessageDto fromDomain(StarredMessage starred) {
    return StarredMessageDto(
      messageId: starred.messageId,
      userId: starred.userId,
      createdAt: starred.createdAt,
    );
  }
}