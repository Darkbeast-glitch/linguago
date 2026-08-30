// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModelSetupState {

 ModelSetupStatus get status;/// Download progress, 0–100.
 int get progress; ConnectionKind get connection; String? get errorMessage;
/// Create a copy of ModelSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelSetupStateCopyWith<ModelSetupState> get copyWith => _$ModelSetupStateCopyWithImpl<ModelSetupState>(this as ModelSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelSetupState&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,progress,connection,errorMessage);

@override
String toString() {
  return 'ModelSetupState(status: $status, progress: $progress, connection: $connection, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ModelSetupStateCopyWith<$Res>  {
  factory $ModelSetupStateCopyWith(ModelSetupState value, $Res Function(ModelSetupState) _then) = _$ModelSetupStateCopyWithImpl;
@useResult
$Res call({
 ModelSetupStatus status, int progress, ConnectionKind connection, String? errorMessage
});




}
/// @nodoc
class _$ModelSetupStateCopyWithImpl<$Res>
    implements $ModelSetupStateCopyWith<$Res> {
  _$ModelSetupStateCopyWithImpl(this._self, this._then);

  final ModelSetupState _self;
  final $Res Function(ModelSetupState) _then;

/// Create a copy of ModelSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? progress = null,Object? connection = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ModelSetupStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ConnectionKind,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelSetupState].
extension ModelSetupStatePatterns on ModelSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelSetupState value)  $default,){
final _that = this;
switch (_that) {
case _ModelSetupState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _ModelSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModelSetupStatus status,  int progress,  ConnectionKind connection,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelSetupState() when $default != null:
return $default(_that.status,_that.progress,_that.connection,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModelSetupStatus status,  int progress,  ConnectionKind connection,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ModelSetupState():
return $default(_that.status,_that.progress,_that.connection,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModelSetupStatus status,  int progress,  ConnectionKind connection,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ModelSetupState() when $default != null:
return $default(_that.status,_that.progress,_that.connection,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ModelSetupState extends ModelSetupState {
  const _ModelSetupState({this.status = ModelSetupStatus.checking, this.progress = 0, this.connection = ConnectionKind.unknown, this.errorMessage}): super._();
  

@override@JsonKey() final  ModelSetupStatus status;
/// Download progress, 0–100.
@override@JsonKey() final  int progress;
@override@JsonKey() final  ConnectionKind connection;
@override final  String? errorMessage;

/// Create a copy of ModelSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelSetupStateCopyWith<_ModelSetupState> get copyWith => __$ModelSetupStateCopyWithImpl<_ModelSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelSetupState&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,progress,connection,errorMessage);

@override
String toString() {
  return 'ModelSetupState(status: $status, progress: $progress, connection: $connection, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ModelSetupStateCopyWith<$Res> implements $ModelSetupStateCopyWith<$Res> {
  factory _$ModelSetupStateCopyWith(_ModelSetupState value, $Res Function(_ModelSetupState) _then) = __$ModelSetupStateCopyWithImpl;
@override @useResult
$Res call({
 ModelSetupStatus status, int progress, ConnectionKind connection, String? errorMessage
});




}
/// @nodoc
class __$ModelSetupStateCopyWithImpl<$Res>
    implements _$ModelSetupStateCopyWith<$Res> {
  __$ModelSetupStateCopyWithImpl(this._self, this._then);

  final _ModelSetupState _self;
  final $Res Function(_ModelSetupState) _then;

/// Create a copy of ModelSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? progress = null,Object? connection = null,Object? errorMessage = freezed,}) {
  return _then(_ModelSetupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ModelSetupStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ConnectionKind,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
