import 'package:drift/drift.dart';

import 'messages_table.dart';
import 'users_table.dart';

/// Starred messages table - messages starred by users
class StarredMessagesTable extends Table {
  TextColumn get messageId => text().references(MessagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text().references(UsersTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {messageId, userId};
}