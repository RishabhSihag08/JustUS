// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_indicators_dao.dart';

// ignore_for_file: type=lint
mixin _$TypingIndicatorsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $TypingIndicatorsTableTable get typingIndicatorsTable =>
      attachedDatabase.typingIndicatorsTable;
  TypingIndicatorsDaoManager get managers => TypingIndicatorsDaoManager(this);
}

class TypingIndicatorsDaoManager {
  final _$TypingIndicatorsDaoMixin _db;
  TypingIndicatorsDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$TypingIndicatorsTableTableTableManager get typingIndicatorsTable =>
      $$TypingIndicatorsTableTableTableManager(
        _db.attachedDatabase,
        _db.typingIndicatorsTable,
      );
}
