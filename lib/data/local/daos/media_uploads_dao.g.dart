// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_uploads_dao.dart';

// ignore_for_file: type=lint
mixin _$MediaUploadsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  $MediaUploadsTableTable get mediaUploadsTable =>
      attachedDatabase.mediaUploadsTable;
  MediaUploadsDaoManager get managers => MediaUploadsDaoManager(this);
}

class MediaUploadsDaoManager {
  final _$MediaUploadsDaoMixin _db;
  MediaUploadsDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
  $$MediaUploadsTableTableTableManager get mediaUploadsTable =>
      $$MediaUploadsTableTableTableManager(
        _db.attachedDatabase,
        _db.mediaUploadsTable,
      );
}
