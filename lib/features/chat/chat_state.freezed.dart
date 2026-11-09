// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {

/// List of messages in the conversation
 List<Message> get messages;/// Whether messages are currently loading
 bool get isLoading;/// Whether there are more messages to load (pagination)
 bool get hasMoreMessages;/// Message being replied to (quoted reply)
 Message? get replyingTo;/// Message being edited
 Message? get editingMessage;/// Reactions grouped by message ID
 Map<String, List<Reaction>> get reactionsByMessageId;/// Set of starred message IDs for current user
 Set<String> get starredMessageIds;/// Current typing/recording indicator from other user
 TypingIndicator? get typingIndicator;/// The other user in the conversation
 User? get otherUser;/// Whether currently recording a voice note
 bool get isRecordingAudio;/// Current recording duration
 Duration get recordingDuration;/// Current search query
 String get searchQuery;/// Error message if any
 String? get error;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChatState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.hasMoreMessages, _this.hasMoreMessages) || other.hasMoreMessages == _this.hasMoreMessages)&&(identical(other.replyingTo, _this.replyingTo) || other.replyingTo == _this.replyingTo)&&(identical(other.editingMessage, _this.editingMessage) || other.editingMessage == _this.editingMessage)&&const DeepCollectionEquality().equals(other.reactionsByMessageId, _this.reactionsByMessageId)&&const DeepCollectionEquality().equals(other.starredMessageIds, _this.starredMessageIds)&&(identical(other.typingIndicator, _this.typingIndicator) || other.typingIndicator == _this.typingIndicator)&&(identical(other.otherUser, _this.otherUser) || other.otherUser == _this.otherUser)&&(identical(other.isRecordingAudio, _this.isRecordingAudio) || other.isRecordingAudio == _this.isRecordingAudio)&&(identical(other.recordingDuration, _this.recordingDuration) || other.recordingDuration == _this.recordingDuration)&&(identical(other.searchQuery, _this.searchQuery) || other.searchQuery == _this.searchQuery)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ChatState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.messages),_this.isLoading,_this.hasMoreMessages,_this.replyingTo,_this.editingMessage,const DeepCollectionEquality().hash(_this.reactionsByMessageId),const DeepCollectionEquality().hash(_this.starredMessageIds),_this.typingIndicator,_this.otherUser,_this.isRecordingAudio,_this.recordingDuration,_this.searchQuery,_this.error);
}

@override
String toString() {
  final _this = this as ChatState;
  return 'ChatState(messages: ${_this.messages}, isLoading: ${_this.isLoading}, hasMoreMessages: ${_this.hasMoreMessages}, replyingTo: ${_this.replyingTo}, editingMessage: ${_this.editingMessage}, reactionsByMessageId: ${_this.reactionsByMessageId}, starredMessageIds: ${_this.starredMessageIds}, typingIndicator: ${_this.typingIndicator}, otherUser: ${_this.otherUser}, isRecordingAudio: ${_this.isRecordingAudio}, recordingDuration: ${_this.recordingDuration}, searchQuery: ${_this.searchQuery}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 List<Message> messages, bool isLoading, bool hasMoreMessages, Message? replyingTo, Message? editingMessage, Map<String, List<Reaction>> reactionsByMessageId, Set<String> starredMessageIds, TypingIndicator? typingIndicator, User? otherUser, bool isRecordingAudio, Duration recordingDuration, String searchQuery, String? error
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? isLoading = null,Object? hasMoreMessages = null,Object? replyingTo = freezed,Object? editingMessage = freezed,Object? reactionsByMessageId = null,Object? starredMessageIds = null,Object? typingIndicator = freezed,Object? otherUser = freezed,Object? isRecordingAudio = null,Object? recordingDuration = null,Object? searchQuery = null,Object? error = freezed,}) {
  return _then(ChatState(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasMoreMessages: null == hasMoreMessages ? _self.hasMoreMessages : hasMoreMessages // ignore: cast_nullable_to_non_nullable
as bool,replyingTo: freezed == replyingTo ? _self.replyingTo : replyingTo // ignore: cast_nullable_to_non_nullable
as Message?,editingMessage: freezed == editingMessage ? _self.editingMessage : editingMessage // ignore: cast_nullable_to_non_nullable
as Message?,reactionsByMessageId: null == reactionsByMessageId ? _self.reactionsByMessageId : reactionsByMessageId // ignore: cast_nullable_to_non_nullable
as Map<String, List<Reaction>>,starredMessageIds: null == starredMessageIds ? _self.starredMessageIds : starredMessageIds // ignore: cast_nullable_to_non_nullable
as Set<String>,typingIndicator: freezed == typingIndicator ? _self.typingIndicator : typingIndicator // ignore: cast_nullable_to_non_nullable
as TypingIndicator?,otherUser: freezed == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User?,isRecordingAudio: null == isRecordingAudio ? _self.isRecordingAudio : isRecordingAudio // ignore: cast_nullable_to_non_nullable
as bool,recordingDuration: null == recordingDuration ? _self.recordingDuration : recordingDuration // ignore: cast_nullable_to_non_nullable
as Duration,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
final _that = this;
switch (_that) {
case _ChatState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Message> messages,  bool isLoading,  bool hasMoreMessages,  Message? replyingTo,  Message? editingMessage,  Map<String, List<Reaction>> reactionsByMessageId,  Set<String> starredMessageIds,  TypingIndicator? typingIndicator,  User? otherUser,  bool isRecordingAudio,  Duration recordingDuration,  String searchQuery,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.hasMoreMessages,_that.replyingTo,_that.editingMessage,_that.reactionsByMessageId,_that.starredMessageIds,_that.typingIndicator,_that.otherUser,_that.isRecordingAudio,_that.recordingDuration,_that.searchQuery,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Message> messages,  bool isLoading,  bool hasMoreMessages,  Message? replyingTo,  Message? editingMessage,  Map<String, List<Reaction>> reactionsByMessageId,  Set<String> starredMessageIds,  TypingIndicator? typingIndicator,  User? otherUser,  bool isRecordingAudio,  Duration recordingDuration,  String searchQuery,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ChatState():
return $default(_that.messages,_that.isLoading,_that.hasMoreMessages,_that.replyingTo,_that.editingMessage,_that.reactionsByMessageId,_that.starredMessageIds,_that.typingIndicator,_that.otherUser,_that.isRecordingAudio,_that.recordingDuration,_that.searchQuery,_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Message> messages,  bool isLoading,  bool hasMoreMessages,  Message? replyingTo,  Message? editingMessage,  Map<String, List<Reaction>> reactionsByMessageId,  Set<String> starredMessageIds,  TypingIndicator? typingIndicator,  User? otherUser,  bool isRecordingAudio,  Duration recordingDuration,  String searchQuery,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isLoading,_that.hasMoreMessages,_that.replyingTo,_that.editingMessage,_that.reactionsByMessageId,_that.starredMessageIds,_that.typingIndicator,_that.otherUser,_that.isRecordingAudio,_that.recordingDuration,_that.searchQuery,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ChatState implements ChatState {
  const _ChatState({ List<Message> messages = const [], this.isLoading = false, this.hasMoreMessages = true, this.replyingTo, this.editingMessage,  Map<String, List<Reaction>> reactionsByMessageId = const {},  Set<String> starredMessageIds = const {}, this.typingIndicator, this.otherUser, this.isRecordingAudio = false, this.recordingDuration = Duration.zero, this.searchQuery = '', this.error}): _messages = messages,_reactionsByMessageId = reactionsByMessageId,_starredMessageIds = starredMessageIds;
  

/// List of messages in the conversation
 final  List<Message> _messages;
/// List of messages in the conversation
@override@JsonKey() List<Message> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

/// Whether messages are currently loading
@override@JsonKey() final  bool isLoading;
/// Whether there are more messages to load (pagination)
@override@JsonKey() final  bool hasMoreMessages;
/// Message being replied to (quoted reply)
@override final  Message? replyingTo;
/// Message being edited
@override final  Message? editingMessage;
/// Reactions grouped by message ID
 final  Map<String, List<Reaction>> _reactionsByMessageId;
/// Reactions grouped by message ID
@override@JsonKey() Map<String, List<Reaction>> get reactionsByMessageId {
  if (_reactionsByMessageId is EqualUnmodifiableMapView) return _reactionsByMessageId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reactionsByMessageId);
}

/// Set of starred message IDs for current user
 final  Set<String> _starredMessageIds;
/// Set of starred message IDs for current user
@override@JsonKey() Set<String> get starredMessageIds {
  if (_starredMessageIds is EqualUnmodifiableSetView) return _starredMessageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_starredMessageIds);
}

/// Current typing/recording indicator from other user
@override final  TypingIndicator? typingIndicator;
/// The other user in the conversation
@override final  User? otherUser;
/// Whether currently recording a voice note
@override@JsonKey() final  bool isRecordingAudio;
/// Current recording duration
@override@JsonKey() final  Duration recordingDuration;
/// Current search query
@override@JsonKey() final  String searchQuery;
/// Error message if any
@override final  String? error;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasMoreMessages, hasMoreMessages) || other.hasMoreMessages == hasMoreMessages)&&(identical(other.replyingTo, replyingTo) || other.replyingTo == replyingTo)&&(identical(other.editingMessage, editingMessage) || other.editingMessage == editingMessage)&&const DeepCollectionEquality().equals(other.reactionsByMessageId, _reactionsByMessageId)&&const DeepCollectionEquality().equals(other.starredMessageIds, _starredMessageIds)&&(identical(other.typingIndicator, typingIndicator) || other.typingIndicator == typingIndicator)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.isRecordingAudio, isRecordingAudio) || other.isRecordingAudio == isRecordingAudio)&&(identical(other.recordingDuration, recordingDuration) || other.recordingDuration == recordingDuration)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),isLoading,hasMoreMessages,replyingTo,editingMessage,const DeepCollectionEquality().hash(_reactionsByMessageId),const DeepCollectionEquality().hash(_starredMessageIds),typingIndicator,otherUser,isRecordingAudio,recordingDuration,searchQuery,error);
}

@override
String toString() {
    return 'ChatState(messages: $messages, isLoading: $isLoading, hasMoreMessages: $hasMoreMessages, replyingTo: $replyingTo, editingMessage: $editingMessage, reactionsByMessageId: $reactionsByMessageId, starredMessageIds: $starredMessageIds, typingIndicator: $typingIndicator, otherUser: $otherUser, isRecordingAudio: $isRecordingAudio, recordingDuration: $recordingDuration, searchQuery: $searchQuery, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<Message> messages, bool isLoading, bool hasMoreMessages, Message? replyingTo, Message? editingMessage, Map<String, List<Reaction>> reactionsByMessageId, Set<String> starredMessageIds, TypingIndicator? typingIndicator, User? otherUser, bool isRecordingAudio, Duration recordingDuration, String searchQuery, String? error
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? isLoading = null,Object? hasMoreMessages = null,Object? replyingTo = freezed,Object? editingMessage = freezed,Object? reactionsByMessageId = null,Object? starredMessageIds = null,Object? typingIndicator = freezed,Object? otherUser = freezed,Object? isRecordingAudio = null,Object? recordingDuration = null,Object? searchQuery = null,Object? error = freezed,}) {
  return _then(_ChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasMoreMessages: null == hasMoreMessages ? _self.hasMoreMessages : hasMoreMessages // ignore: cast_nullable_to_non_nullable
as bool,replyingTo: freezed == replyingTo ? _self.replyingTo : replyingTo // ignore: cast_nullable_to_non_nullable
as Message?,editingMessage: freezed == editingMessage ? _self.editingMessage : editingMessage // ignore: cast_nullable_to_non_nullable
as Message?,reactionsByMessageId: null == reactionsByMessageId ? _self._reactionsByMessageId : reactionsByMessageId // ignore: cast_nullable_to_non_nullable
as Map<String, List<Reaction>>,starredMessageIds: null == starredMessageIds ? _self._starredMessageIds : starredMessageIds // ignore: cast_nullable_to_non_nullable
as Set<String>,typingIndicator: freezed == typingIndicator ? _self.typingIndicator : typingIndicator // ignore: cast_nullable_to_non_nullable
as TypingIndicator?,otherUser: freezed == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User?,isRecordingAudio: null == isRecordingAudio ? _self.isRecordingAudio : isRecordingAudio // ignore: cast_nullable_to_non_nullable
as bool,recordingDuration: null == recordingDuration ? _self.recordingDuration : recordingDuration // ignore: cast_nullable_to_non_nullable
as Duration,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
