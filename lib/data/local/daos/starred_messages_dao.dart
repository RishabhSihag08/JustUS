import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/starred_messages_table.dart';
import '../tables/messages_table.dart';
import '../../../domain/models/message.dart';
import 'messages_dao.dart';

part 'starred_messages_dao.g.dart';

/// DAO for starred messages
@DriftAccessor(tables: [StarredMessagesTable, MessagesTable])
class StarredMessagesDao extends DatabaseAccessor<AppDatabase> with _$StarredMessagesDaoMixin {
  StarredMessagesDao(super.db);

  /// Star a message
  Future<int> starMessage(String messageId, String userId) {
    return into(starredMessagesTable).insertOnConflictUpdate(
      StarredMessagesTableCompanion(
        messageId: Value(messageId),
        userId: Value(userId),
      ),
    );
  }

  /// Unstar a message
  Future<int> unstarMessage(String messageId, String userId) {
    return (delete(starredMessagesTable)
          ..where((s) => s.messageId.equals(messageId) & s.userId.equals(userId)))
        .go();
  }

  /// Watch starred messages for a user with full message data
  Stream<List<Message>> watchStarredMessagesAsMessages(String userId) {
    return customSelect(
      'SELECT m.* FROM messages_table m '
      'JOIN starred_messages_table s ON m.id = s.message_id '
      'WHERE s.user_id = ? '
      'ORDER BY m.created_at DESC',
      variables: [Variable.withString(userId)],
    ).watch().map((rows) => rows.map((row) => MessagesTableData(
      id: row.read<String>('id'),
      conversationId: row.read<String>('conversation_id'),
      senderId: row.read<String>('sender_id'),
      type: row.read<String>('type'),
      content: row.read<String?>('content'),
      mediaUrl: row.read<String?>('media_url'),
      mediaThumbnailUrl: row.read<String?>('media_thumbnail_url'),
      mediaDuration: row.read<int?>('media_duration'),
      mediaSize: row.read<int?>('media_size'),
      mediaMimeType: row.read<String?>('media_mime_type'),
      replyToId: row.read<String?>('reply_to_id'),
      status: row.read<String>('status'),
      isStarred: row.read<bool>('is_starred'),
      isDisappearing: row.read<bool>('is_disappearing'),
      expiresAt: row.read<DateTime?>('expires_at'),
      viewOnceViewed: row.read<bool>('view_once_viewed'),
      viewOnceViewedAt: row.read<DateTime?>('view_once_viewed_at'),
      createdAt: row.read<DateTime>('created_at'),
      updatedAt: row.read<DateTime>('updated_at'),
      deliveredAt: row.read<DateTime?>('delivered_at'),
      readAt: row.read<DateTime?>('read_at'),
    ).toDomain()).toList());
  }

  /// Watch starred messages for a user (original method for compatibility)
  Stream<List<StarredMessagesTableData>> watchStarredByUser(String userId) {
    return (select(starredMessagesTable)..where((s) => s.userId.equals(userId))).watch();
  }
}