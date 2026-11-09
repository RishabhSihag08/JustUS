import 'package:json_annotation/json_annotation.dart';
import '../../../domain/models/typing_indicator.dart';

part 'typing_indicator_dto.g.dart';

/// Supabase typing indicator DTO
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TypingIndicatorDto {
  final String conversationId;
  final String userId;
  final bool isTyping;
  final bool isRecording;
  final DateTime updatedAt;

  const TypingIndicatorDto({
    required this.conversationId,
    required this.userId,
    this.isTyping = false,
    this.isRecording = false,
    required this.updatedAt,
  });

  factory TypingIndicatorDto.fromJson(Map<String, dynamic> json) => _$TypingIndicatorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TypingIndicatorDtoToJson(this);

  TypingIndicator toDomain() {
    return TypingIndicator(
      conversationId: conversationId,
      userId: userId,
      isTyping: isTyping,
      isRecording: isRecording,
    );
  }

  static TypingIndicatorDto fromDomain(TypingIndicator indicator) {
    return TypingIndicatorDto(
      conversationId: indicator.conversationId,
      userId: indicator.userId,
      isTyping: indicator.isTyping,
      isRecording: indicator.isRecording,
      updatedAt: DateTime.now(),
    );
  }
}