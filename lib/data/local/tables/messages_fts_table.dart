import 'package:drift/drift.dart';

/// FTS5 virtual table for full-text search on messages
/// This is a virtual table created via SQL, not a Drift table
/// We define it here for type safety in DAOs
class MessagesFtsTable extends Table {
  @override
  String get tableName => 'messages_fts';

  // These columns mirror the messages table for FTS
  TextColumn get id => text().withLength(min: 1, max: 36)();
  TextColumn get conversationId => text().withLength(min: 1, max: 36)();
  TextColumn get content => text()();

  @override
  Set<Column> get primaryKey => {}; // FTS5 manages its own rowid
}