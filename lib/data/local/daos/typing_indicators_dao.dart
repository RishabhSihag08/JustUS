import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/typing_indicators_table.dart';

part 'typing_indicators_dao.g.dart';

/// DAO for typing indicators
@DriftAccessor(tables: [TypingIndicatorsTable])
class TypingIndicatorsDao extends DatabaseAccessor<AppDatabase> with _$TypingIndicatorsDaoMixin {
  TypingIndicatorsDao(super.db);

  /// Upsert typing indicator
  Future<int> upsertTypingIndicator(TypingIndicatorsTableCompanion indicator) {
    return into(typingIndicatorsTable).insertOnConflictUpdate(indicator);
  }

  /// Watch typing indicators for a conversation
  Stream<List<TypingIndicatorsTableData>> watchTypingForConversation(String conversationId) {
    return (select(typingIndicatorsTable)..where((t) => t.conversationId.equals(conversationId))).watch();
  }

  /// Clear typing indicator for a user
  Future<int> clearTypingForUser(String conversationId, String userId) {
    return (delete(typingIndicatorsTable)
          ..where((t) => t.conversationId.equals(conversationId) & t.userId.equals(userId)))
        .go();
  }
}