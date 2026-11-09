// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_dao.dart';

// ignore_for_file: type=lint
mixin _$MessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  $MessagesFtsTableTable get messagesFtsTable =>
      attachedDatabase.messagesFtsTable;
  MessagesDaoManager get managers => MessagesDaoManager(this);
}

class MessagesDaoManager {
  final _$MessagesDaoMixin _db;
  MessagesDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
  $$MessagesFtsTableTableTableManager get messagesFtsTable =>
      $$MessagesFtsTableTableTableManager(
        _db.attachedDatabase,
        _db.messagesFtsTable,
      );
}
