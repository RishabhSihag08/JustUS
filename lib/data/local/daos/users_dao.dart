import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

/// DAO for users
@DriftAccessor(tables: [UsersTable])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  /// Upsert a user
  Future<int> upsertUser(UsersTableCompanion user) {
    return into(usersTable).insertOnConflictUpdate(user);
  }

  /// Get user by ID
  Future<UsersTableData?> getById(String id) {
    return (select(usersTable)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Get all users (should be exactly 2)
  Future<List<UsersTableData>> getAllUsers() {
    return select(usersTable).get();
  }

  /// Watch all users
  Stream<List<UsersTableData>> watchAllUsers() {
    return select(usersTable).watch();
  }

  /// Update online status and last seen
  Future<int> updateOnlineStatus(String id, bool isOnline, DateTime lastSeenAt) {
    return (update(usersTable)..where((u) => u.id.equals(id))).write(
      UsersTableCompanion(
        isOnline: Value(isOnline),
        lastSeenAt: Value(lastSeenAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update FCM token
  Future<int> updateFcmToken(String id, String token) {
    return (update(usersTable)..where((u) => u.id.equals(id))).write(
      UsersTableCompanion(
        fcmToken: Value(token),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}