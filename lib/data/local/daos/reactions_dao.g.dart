// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions_dao.dart';

// ignore_for_file: type=lint
mixin _$ReactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  $ReactionsTableTable get reactionsTable => attachedDatabase.reactionsTable;
  ReactionsDaoManager get managers => ReactionsDaoManager(this);
}

class ReactionsDaoManager {
  final _$ReactionsDaoMixin _db;
  ReactionsDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
  $$ReactionsTableTableTableManager get reactionsTable =>
      $$ReactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.reactionsTable,
      );
}
