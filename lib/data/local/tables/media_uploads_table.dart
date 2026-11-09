import 'package:drift/drift.dart';

import 'messages_table.dart';
import 'users_table.dart';

/// Media uploads table - tracks pending/failed uploads
class MediaUploadsTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get messageId => text().references(MessagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text().references(UsersTable, #id)();
  TextColumn get bucketPath => text()(); // Storage path
  TextColumn get uploadStatus => textEnum<UploadStatus>().withDefault(const Constant('pending'))(); // pending, uploading, completed, failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Upload status enum
enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
}