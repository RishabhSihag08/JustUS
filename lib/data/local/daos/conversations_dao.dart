import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/conversations_table.dart';

part 'conversations_dao.g.dart';

/// DAO for conversations
@DriftAccessor(tables: [ConversationsTable])
class ConversationsDao extends DatabaseAccessor<AppDatabase> with _$ConversationsDaoMixin {
  ConversationsDao(super.db);

  /// Upsert a conversation
  Future<int> upsertConversation(ConversationsTableCompanion conversation) {
    return into(conversationsTable).insertOnConflictUpdate(conversation);
  }

  /// Watch a single conversation by ID
  Stream<ConversationsTableData?> watchConversation(String id) {
    return (select(conversationsTable)..where((c) => c.id.equals(id))).watchSingleOrNull();
  }

  /// Get a single conversation by ID
  Future<ConversationsTableData?> getConversation(String id) {
    return (select(conversationsTable)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Get the first existing conversation
  Future<ConversationsTableData?> getFirstConversation() {
    return (select(conversationsTable)..limit(1)).getSingleOrNull();
  }

  /// Update disappearing timer
  Future<int> updateDisappearingTimer(String id, Duration? timer) {
    return (update(conversationsTable)..where((c) => c.id.equals(id))).write(
      ConversationsTableCompanion(
        disappearingTimer: timer != null ? Value(timer.inSeconds) : const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}