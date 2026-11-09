// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_pad_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinPadState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinPadState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PinPadState()';
}


}

/// @nodoc
class $PinPadStateCopyWith<$Res>  {
$PinPadStateCopyWith(PinPadState _, $Res Function(PinPadState) __);
}


/// Adds pattern-matching-related methods to [PinPadState].
extension PinPadStatePatterns on PinPadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinPadIdle value)?  idle,TResult Function( PinPadError value)?  error,TResult Function( PinPadLocked value)?  locked,TResult Function( PinPadSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinPadIdle() when idle != null:
return idle(_that);case PinPadError() when error != null:
return error(_that);case PinPadLocked() when locked != null:
return locked(_that);case PinPadSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinPadIdle value)  idle,required TResult Function( PinPadError value)  error,required TResult Function( PinPadLocked value)  locked,required TResult Function( PinPadSuccess value)  success,}){
final _that = this;
switch (_that) {
case PinPadIdle():
return idle(_that);case PinPadError():
return error(_that);case PinPadLocked():
return locked(_that);case PinPadSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinPadIdle value)?  idle,TResult? Function( PinPadError value)?  error,TResult? Function( PinPadLocked value)?  locked,TResult? Function( PinPadSuccess value)?  success,}){
final _that = this;
switch (_that) {
case PinPadIdle() when idle != null:
return idle(_that);case PinPadError() when error != null:
return error(_that);case PinPadLocked() when locked != null:
return locked(_that);case PinPadSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String enteredPin,  int attemptCount)?  idle,TResult Function( String enteredPin,  int attemptCount,  String message,  bool isShaking)?  error,TResult Function( Duration remaining)?  locked,TResult Function( String userId)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinPadIdle() when idle != null:
return idle(_that.enteredPin,_that.attemptCount);case PinPadError() when error != null:
return error(_that.enteredPin,_that.attemptCount,_that.message,_that.isShaking);case PinPadLocked() when locked != null:
return locked(_that.remaining);case PinPadSuccess() when success != null:
return success(_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String enteredPin,  int attemptCount)  idle,required TResult Function( String enteredPin,  int attemptCount,  String message,  bool isShaking)  error,required TResult Function( Duration remaining)  locked,required TResult Function( String userId)  success,}) {final _that = this;
switch (_that) {
case PinPadIdle():
return idle(_that.enteredPin,_that.attemptCount);case PinPadError():
return error(_that.enteredPin,_that.attemptCount,_that.message,_that.isShaking);case PinPadLocked():
return locked(_that.remaining);case PinPadSuccess():
return success(_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String enteredPin,  int attemptCount)?  idle,TResult? Function( String enteredPin,  int attemptCount,  String message,  bool isShaking)?  error,TResult? Function( Duration remaining)?  locked,TResult? Function( String userId)?  success,}) {final _that = this;
switch (_that) {
case PinPadIdle() when idle != null:
return idle(_that.enteredPin,_that.attemptCount);case PinPadError() when error != null:
return error(_that.enteredPin,_that.attemptCount,_that.message,_that.isShaking);case PinPadLocked() when locked != null:
return locked(_that.remaining);case PinPadSuccess() when success != null:
return success(_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class PinPadIdle implements PinPadState {
  const PinPadIdle({this.enteredPin = '', this.attemptCount = 0});
  

@JsonKey() final  String enteredPin;
@JsonKey() final  int attemptCount;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinPadIdleCopyWith<PinPadIdle> get copyWith => _$PinPadIdleCopyWithImpl<PinPadIdle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinPadIdle&&(identical(other.enteredPin, enteredPin) || other.enteredPin == enteredPin)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,enteredPin,attemptCount);
}

@override
String toString() {
    return 'PinPadState.idle(enteredPin: $enteredPin, attemptCount: $attemptCount)';
}


}

/// @nodoc
abstract mixin class $PinPadIdleCopyWith<$Res> implements $PinPadStateCopyWith<$Res> {
  factory $PinPadIdleCopyWith(PinPadIdle value, $Res Function(PinPadIdle) _then) = _$PinPadIdleCopyWithImpl;
@useResult
$Res call({
 String enteredPin, int attemptCount
});




}
/// @nodoc
class _$PinPadIdleCopyWithImpl<$Res>
    implements $PinPadIdleCopyWith<$Res> {
  _$PinPadIdleCopyWithImpl(this._self, this._then);

  final PinPadIdle _self;
  final $Res Function(PinPadIdle) _then;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredPin = null,Object? attemptCount = null,}) {
  return _then(PinPadIdle(
enteredPin: null == enteredPin ? _self.enteredPin : enteredPin // ignore: cast_nullable_to_non_nullable
as String,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PinPadError implements PinPadState {
  const PinPadError({this.enteredPin = '', this.attemptCount = 0, required this.message, this.isShaking = false});
  

@JsonKey() final  String enteredPin;
@JsonKey() final  int attemptCount;
 final  String message;
@JsonKey() final  bool isShaking;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinPadErrorCopyWith<PinPadError> get copyWith => _$PinPadErrorCopyWithImpl<PinPadError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinPadError&&(identical(other.enteredPin, enteredPin) || other.enteredPin == enteredPin)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.message, message) || other.message == message)&&(identical(other.isShaking, isShaking) || other.isShaking == isShaking));
}


@override
int get hashCode {
    return Object.hash(runtimeType,enteredPin,attemptCount,message,isShaking);
}

@override
String toString() {
    return 'PinPadState.error(enteredPin: $enteredPin, attemptCount: $attemptCount, message: $message, isShaking: $isShaking)';
}


}

/// @nodoc
abstract mixin class $PinPadErrorCopyWith<$Res> implements $PinPadStateCopyWith<$Res> {
  factory $PinPadErrorCopyWith(PinPadError value, $Res Function(PinPadError) _then) = _$PinPadErrorCopyWithImpl;
@useResult
$Res call({
 String enteredPin, int attemptCount, String message, bool isShaking
});




}
/// @nodoc
class _$PinPadErrorCopyWithImpl<$Res>
    implements $PinPadErrorCopyWith<$Res> {
  _$PinPadErrorCopyWithImpl(this._self, this._then);

  final PinPadError _self;
  final $Res Function(PinPadError) _then;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enteredPin = null,Object? attemptCount = null,Object? message = null,Object? isShaking = null,}) {
  return _then(PinPadError(
enteredPin: null == enteredPin ? _self.enteredPin : enteredPin // ignore: cast_nullable_to_non_nullable
as String,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isShaking: null == isShaking ? _self.isShaking : isShaking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PinPadLocked implements PinPadState {
  const PinPadLocked({required this.remaining});
  

 final  Duration remaining;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinPadLockedCopyWith<PinPadLocked> get copyWith => _$PinPadLockedCopyWithImpl<PinPadLocked>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinPadLocked&&(identical(other.remaining, remaining) || other.remaining == remaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,remaining);
}

@override
String toString() {
    return 'PinPadState.locked(remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class $PinPadLockedCopyWith<$Res> implements $PinPadStateCopyWith<$Res> {
  factory $PinPadLockedCopyWith(PinPadLocked value, $Res Function(PinPadLocked) _then) = _$PinPadLockedCopyWithImpl;
@useResult
$Res call({
 Duration remaining
});




}
/// @nodoc
class _$PinPadLockedCopyWithImpl<$Res>
    implements $PinPadLockedCopyWith<$Res> {
  _$PinPadLockedCopyWithImpl(this._self, this._then);

  final PinPadLocked _self;
  final $Res Function(PinPadLocked) _then;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remaining = null,}) {
  return _then(PinPadLocked(
remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class PinPadSuccess implements PinPadState {
  const PinPadSuccess({required this.userId});
  

 final  String userId;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinPadSuccessCopyWith<PinPadSuccess> get copyWith => _$PinPadSuccessCopyWithImpl<PinPadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinPadSuccess&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId);
}

@override
String toString() {
    return 'PinPadState.success(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PinPadSuccessCopyWith<$Res> implements $PinPadStateCopyWith<$Res> {
  factory $PinPadSuccessCopyWith(PinPadSuccess value, $Res Function(PinPadSuccess) _then) = _$PinPadSuccessCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$PinPadSuccessCopyWithImpl<$Res>
    implements $PinPadSuccessCopyWith<$Res> {
  _$PinPadSuccessCopyWithImpl(this._self, this._then);

  final PinPadSuccess _self;
  final $Res Function(PinPadSuccess) _then;

/// Create a copy of PinPadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(PinPadSuccess(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
