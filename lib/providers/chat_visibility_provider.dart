import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier to track whether the user is actively viewing and interacting with the ChatScreen.
/// When true, incoming message decoy notifications are suppressed to prevent spam while actively chatting.
class ChatActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setActive(bool value) => state = value;
}

final isChatActiveProvider =
    NotifierProvider<ChatActiveNotifier, bool>(ChatActiveNotifier.new);
