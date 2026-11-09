import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/reaction.dart';

part 'reaction_dto.g.dart';

/// Supabase reaction DTO
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReactionDto {
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAt;

  const ReactionDto({
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  factory ReactionDto.fromJson(Map<String, dynamic> json) => _$ReactionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionDtoToJson(this);

  Reaction toDomain() {
    return Reaction(
      messageId: messageId,
      userId: userId,
      emoji: emoji,
      createdAt: createdAt,
    );
  }

  static ReactionDto fromDomain(Reaction reaction) {
    return ReactionDto(
      messageId: reaction.messageId,
      userId: reaction.userId,
      emoji: reaction.emoji,
      createdAt: reaction.createdAt,
    );
  }
}