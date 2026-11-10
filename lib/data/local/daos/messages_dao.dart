import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/messages_table.dart';
import '../tables/messages_fts_table.dart';
import '../tables/users_table.dart';
import '../../../domain/models/message.dart';
import '../../../domain/enums.dart';

part 'messages_dao.g.dart';

/// Extension to convert string values to domain enums
extension MessageTypeExtension on String {
  MessageType get toMessageType => MessageType.values.firstWhere(
    (e) => e.name == this || (e == MessageType.viewOnce && this == 'view_once'),
    orElse: () => MessageType.text,
  );
}

extension MessageStatusExtension on String {
  MessageStatus get toMessageStatus => MessageStatus.values.firstWhere(
    (e) => e.name == this,
    orElse: () => MessageStatus.pending,
  );
}

/// Extension to convert MessagesTableData to domain Message
extension MessagesTableDataToDomain on MessagesTableData {
  Message toDomain() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      type: type.toMessageType,
      content: content,
      mediaUrl: mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl,
      mediaDuration: mediaDuration,
      mediaSize: mediaSize,
      mediaMimeType: mediaMimeType,
      replyToId: replyToId,
      status: status.toMessageStatus,
      isStarred: isStarred,
      isDisappearing: isDisappearing,
      expiresAt: expiresAt?.toLocal(),
      viewOnceViewed: viewOnceViewed,
      viewOnceViewedAt: viewOnceViewedAt?.toLocal(),
      createdAt: createdAt.toLocal(),
      updatedAt: updatedAt.toLocal(),
      deliveredAt: deliveredAt?.toLocal(),
      readAt: readAt?.toLocal(),
    );
  }
}

/// DAO for messages with FTS5 search support
@DriftAccessor(tables: [MessagesTable, MessagesFtsTable, UsersTable])
class MessagesDao extends DatabaseAccessor<AppDatabase> with _$MessagesDaoMixin {
  MessagesDao(super.db);

  /// Insert a single message (upsert)
  Future<int> insertMessage(MessagesTableCompanion message) {
    return into(messagesTable).insertOnConflictUpdate(message);
  }

  /// Insert multiple messages (bulk upsert)
  Future<void> insertAllMessages(List<MessagesTableCompanion> messages) {
    return batch((b) {
      b.insertAllOnConflictUpdate(messagesTable, messages);
    });
  }

  /// Update a message
  Future<bool> updateMessage(MessagesTableCompanion message) {
    return update(messagesTable).replace(message);
  }

  /// Delete a message by ID
  Future<int> deleteMessage(String id) {
    return (delete(messagesTable)..where((m) => m.id.equals(id))).go();
  }

  /// Get a single message by ID
  Future<MessagesTableData?> getMessageById(String id) {
    return (select(messagesTable)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  /// Watch all messages for a conversation (real-time stream, ordered ASC)
  Stream<List<MessagesTableData>> watchMessagesByConversation(String conversationId) {
    return (select(messagesTable)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([
            (m) => OrderingTerm.asc(m.createdAt),
          ]))
        .watch();
  }

  /// Get paginated messages for a conversation (for initial load + pagination)
  Future<List<MessagesTableData>> getMessagesByConversationPaged(
    String conversationId,
    int limit,
    int offset,
  ) {
    return (select(messagesTable)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  /// Get all pending messages (not yet sent to server)
  Future<List<MessagesTableData>> getPendingMessages() {
    return (select(messagesTable)
          ..where((m) => m.status.equals('pending'))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Watch pending messages
  Stream<List<MessagesTableData>> watchPendingMessages() {
    return (select(messagesTable)
          ..where((m) => m.status.equals('pending'))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Update delivery status
  Future<int> updateDeliveryStatus(String messageId, String status, DateTime deliveredAt) {
    return (update(messagesTable)
          ..where((m) => m.id.equals(messageId)))
        .write(MessagesTableCompanion(
      status: Value(status),
      deliveredAt: Value(deliveredAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Update read status
  Future<int> updateReadStatus(String messageId, String status, DateTime readAt) {
    return (update(messagesTable)
          ..where((m) => m.id.equals(messageId)))
        .write(MessagesTableCompanion(
      status: Value(status),
      readAt: Value(readAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Update starred status
  Future<int> updateStarred(String messageId, bool starred) {
    return (update(messagesTable)
          ..where((m) => m.id.equals(messageId)))
        .write(MessagesTableCompanion(
      isStarred: Value(starred),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Mark view-once as viewed
  Future<int> markViewOnceViewed(String messageId, DateTime viewedAt) {
    return (update(messagesTable)
          ..where((m) => m.id.equals(messageId)))
        .write(MessagesTableCompanion(
      viewOnceViewed: const Value(true),
      viewOnceViewedAt: Value(viewedAt),
      mediaUrl: const Value(null), // Clear media URL for security
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Get expired disappearing messages
  Future<List<MessagesTableData>> getExpiredDisappearingMessages(DateTime now) {
    return (select(messagesTable)
          ..where((m) => m.expiresAt.isNotNull() & m.expiresAt.isSmallerThanValue(now)))
        .get();
  }

  /// Delete expired disappearing messages
  Future<int> deleteExpiredMessages(DateTime now) {
    return (delete(messagesTable)
          ..where((m) => m.expiresAt.isNotNull() & m.expiresAt.isSmallerThanValue(now)))
        .go();
  }

  /// Search messages using SQLite query
  Future<List<MessagesTableData>> searchMessagesFts(String conversationId, String query) async {
    final pattern = '%$query%';
    return (select(messagesTable)
          ..where((m) => m.conversationId.equals(conversationId) & m.content.like(pattern))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  /// Delete all messages for a conversation
  Future<int> deleteByConversationId(String conversationId) {
    return (delete(messagesTable)
          ..where((m) => m.conversationId.equals(conversationId)))
        .go();
  }

  /// Delete all messages (for logout/clear)
  Future<int> deleteAll() {
    return delete(messagesTable).go();
  }
}