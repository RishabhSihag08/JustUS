import 'package:drift/drift.dart';

import 'messages_table.dart';
import 'users_table.dart';

/// Reactions table - emoji reactions on messages
class ReactionsTable extends Table {
  TextColumn get messageId => text().references(MessagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text().references(UsersTable, #id)();
  TextColumn get emoji => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {messageId, userId, emoji};
}