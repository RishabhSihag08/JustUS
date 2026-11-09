import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database.dart';
import '../data/local/daos/messages_dao.dart';
import '../data/local/daos/conversations_dao.dart';
import '../data/local/daos/users_dao.dart';
import '../data/local/daos/reactions_dao.dart';
import '../data/local/daos/starred_messages_dao.dart';
import '../data/local/daos/typing_indicators_dao.dart';
import '../data/local/daos/media_uploads_dao.dart';

/// Drift database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// DAO providers
final messagesDaoProvider = Provider<MessagesDao>((ref) {
  return ref.read(databaseProvider).messagesDao;
});

final conversationsDaoProvider = Provider<ConversationsDao>((ref) {
  return ref.read(databaseProvider).conversationsDao;
});

final usersDaoProvider = Provider<UsersDao>((ref) {
  return ref.read(databaseProvider).usersDao;
});

final reactionsDaoProvider = Provider<ReactionsDao>((ref) {
  return ref.read(databaseProvider).reactionsDao;
});

final starredMessagesDaoProvider = Provider<StarredMessagesDao>((ref) {
  return ref.read(databaseProvider).starredMessagesDao;
});

final typingIndicatorsDaoProvider = Provider<TypingIndicatorsDao>((ref) {
  return ref.read(databaseProvider).typingIndicatorsDao;
});

final mediaUploadsDaoProvider = Provider<MediaUploadsDao>((ref) {
  return ref.read(databaseProvider).mediaUploadsDao;
});