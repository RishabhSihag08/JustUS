import 'package:drift/drift.dart';

import 'conversations_table.dart';
import 'users_table.dart';

/// Messages table - stores all chat messages
class MessagesTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get conversationId => text().references(ConversationsTable, #id)(); // FK
  TextColumn get senderId => text().references(UsersTable, #id)(); // FK
  // Use plain text columns for enums to avoid Drift-generated enum types
  TextColumn get type => text()(); // text, image, video, voice, document, view_once
  TextColumn get content => text().nullable()(); // Text content or caption
  TextColumn get mediaUrl => text().nullable()(); // Remote media URL
  TextColumn get mediaThumbnailUrl => text().nullable()(); // Thumbnail URL
  IntColumn get mediaDuration => integer().nullable()(); // Duration in milliseconds (voice/video)
  IntColumn get mediaSize => integer().nullable()(); // File size in bytes
  TextColumn get mediaMimeType => text().nullable()(); // MIME type
  TextColumn get replyToId => text().nullable().references(MessagesTable, #id)(); // Self-referencing FK
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, sent, delivered, read
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  BoolColumn get isDisappearing => boolean().withDefault(const Constant(false))();
  DateTimeColumn get expiresAt => dateTime().nullable()(); // For disappearing messages
  BoolColumn get viewOnceViewed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get viewOnceViewedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}