// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred_messages_dao.dart';

// ignore_for_file: type=lint
mixin _$StarredMessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  $StarredMessagesTableTable get starredMessagesTable =>
      attachedDatabase.starredMessagesTable;
  StarredMessagesDaoManager get managers => StarredMessagesDaoManager(this);
}

class StarredMessagesDaoManager {
  final _$StarredMessagesDaoMixin _db;
  StarredMessagesDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
  $$StarredMessagesTableTableTableManager get starredMessagesTable =>
      $$StarredMessagesTableTableTableManager(
        _db.attachedDatabase,
        _db.starredMessagesTable,
      );
}
