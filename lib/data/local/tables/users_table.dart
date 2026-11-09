import 'package:drift/drift.dart';

/// Users table for the two-person chat
class UsersTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get role => text()(); // 'user1' | 'user2'
  TextColumn get pinHash => text()(); // bcrypt hash
  TextColumn get displayName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get fcmToken => text().nullable()();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}