import 'package:drift/drift.dart';

import 'users_table.dart';

/// Conversations table - single conversation between the two users
class ConversationsTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get user1Id => text().references(UsersTable, #id)(); // FK to users
  TextColumn get user2Id => text().references(UsersTable, #id)(); // FK to users
  IntColumn get disappearingTimer => integer().nullable()(); // Duration in seconds, nullable
  BoolColumn get viewOnceEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {user1Id, user2Id},
      ];
}