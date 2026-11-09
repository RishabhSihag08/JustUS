import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'tables/users_table.dart';
import 'tables/conversations_table.dart';
import 'tables/messages_table.dart';
import 'tables/messages_fts_table.dart';
import 'tables/reactions_table.dart';
import 'tables/starred_messages_table.dart';
import 'tables/typing_indicators_table.dart';
import 'tables/media_uploads_table.dart';

import 'daos/messages_dao.dart';
import 'daos/conversations_dao.dart';
import 'daos/users_dao.dart';
import 'daos/reactions_dao.dart';
import 'daos/starred_messages_dao.dart';
import 'daos/typing_indicators_dao.dart';
import 'daos/media_uploads_dao.dart';

part 'database.g.dart';

/// Drift database for JustUS local storage
@DriftDatabase(
  tables: [
    UsersTable,
    ConversationsTable,
    MessagesTable,
    MessagesFtsTable,
    ReactionsTable,
    StarredMessagesTable,
    TypingIndicatorsTable,
    MediaUploadsTable,
  ],
  daos: [
    MessagesDao,
    ConversationsDao,
    UsersDao,
    ReactionsDao,
    StarredMessagesDao,
    TypingIndicatorsDao,
    MediaUploadsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _cleanupLegacyFtsTriggers();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations will go here
        },
        beforeOpen: (details) async {
          // Ensure legacy broken FTS triggers are removed
          await _cleanupLegacyFtsTriggers();
        },
      );

  /// Opens the database connection with FTS5 support
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'justus.sqlite'));

      return NativeDatabase.createInBackground(file);
    });
  }

  /// Safely drops legacy FTS triggers to prevent SQLite statement preparation errors
  Future<void> _cleanupLegacyFtsTriggers() async {
    try {
      await customStatement('DROP TRIGGER IF EXISTS messages_fts_insert;');
      await customStatement('DROP TRIGGER IF EXISTS messages_fts_update;');
      await customStatement('DROP TRIGGER IF EXISTS messages_fts_delete;');
    } catch (e) {
      debugPrint('FTS cleanup note: $e');
    }
  }
}