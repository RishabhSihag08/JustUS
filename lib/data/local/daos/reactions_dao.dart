import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/reactions_table.dart';

part 'reactions_dao.g.dart';

/// DAO for reactions
@DriftAccessor(tables: [ReactionsTable])
class ReactionsDao extends DatabaseAccessor<AppDatabase> with _$ReactionsDaoMixin {
  ReactionsDao(super.db);

  /// Upsert a reaction
  Future<int> upsertReaction(ReactionsTableCompanion reaction) {
    return into(reactionsTable).insertOnConflictUpdate(reaction);
  }

  /// Delete a reaction
  Future<int> deleteReaction(String messageId, String userId, String emoji) {
    return (delete(reactionsTable)
          ..where((r) => r.messageId.equals(messageId) & r.userId.equals(userId) & r.emoji.equals(emoji)))
        .go();
  }

  /// Watch reactions for a message
  Stream<List<ReactionsTableData>> watchReactionsByMessage(String messageId) {
    return (select(reactionsTable)..where((r) => r.messageId.equals(messageId))).watch();
  }

  /// Watch all reactions across messages
  Stream<List<ReactionsTableData>> watchAllReactions() {
    return select(reactionsTable).watch();
  }

  /// Get all reactions
  Future<List<ReactionsTableData>> getAllReactions() {
    return select(reactionsTable).get();
  }

  /// Delete all reactions
  Future<int> deleteAll() {
    return delete(reactionsTable).go();
  }
}