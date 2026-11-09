import 'package:drift/drift.dart';

import 'conversations_table.dart';
import 'users_table.dart';

/// Typing indicators table - real-time typing/recording status
class TypingIndicatorsTable extends Table {
  TextColumn get conversationId => text().references(ConversationsTable, #id)();
  TextColumn get userId => text().references(UsersTable, #id)();
  BoolColumn get isTyping => boolean().withDefault(const Constant(false))();
  BoolColumn get isRecording => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {conversationId, userId};
}