// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranslationState {

 TranslationStatus get status; Language get sourceLanguage; Language get targetLanguage; String? get transcription; String? get translation; bool get isSpeaking; bool get isModelReady; String? get errorMessage;/// True when [errorMessage] describes a missing capability (no offline
/// voice for this language) rather than a failure. The translation is
/// still valid and stays on screen, so this shouldn't be dressed up as an
/// error — PRD §22 asks for an explanation, not an alarm.
 bool get errorIsCapabilityGap;
/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationStateCopyWith<TranslationState> get copyWith => _$TranslationStateCopyWithImpl<TranslationState>(this as TranslationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationState&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.isSpeaking, isSpeaking) || other.isSpeaking == isSpeaking)&&(identical(other.isModelReady, isModelReady) || other.isModelReady == isModelReady)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorIsCapabilityGap, errorIsCapabilityGap) || other.errorIsCapabilityGap == errorIsCapabilityGap));
}


@override
int get hashCode => Object.hash(runtimeType,status,sourceLanguage,targetLanguage,transcription,translation,isSpeaking,isModelReady,errorMessage,errorIsCapabilityGap);

@override
String toString() {
  return 'TranslationState(status: $status, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, transcription: $transcription, translation: $translation, isSpeaking: $isSpeaking, isModelReady: $isModelReady, errorMessage: $errorMessage, errorIsCapabilityGap: $errorIsCapabilityGap)';
}


}

/// @nodoc
abstract mixin class $TranslationStateCopyWith<$Res>  {
  factory $TranslationStateCopyWith(TranslationState value, $Res Function(TranslationState) _then) = _$TranslationStateCopyWithImpl;
@useResult
$Res call({
 TranslationStatus status, Language sourceLanguage, Language targetLanguage, String? transcription, String? translation, bool isSpeaking, bool isModelReady, String? errorMessage, bool errorIsCapabilityGap
});


$LanguageCopyWith<$Res> get sourceLanguage;$LanguageCopyWith<$Res> get targetLanguage;

}
/// @nodoc
class _$TranslationStateCopyWithImpl<$Res>
    implements $TranslationStateCopyWith<$Res> {
  _$TranslationStateCopyWithImpl(this._self, this._then);

  final TranslationState _self;
  final $Res Function(TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? transcription = freezed,Object? translation = freezed,Object? isSpeaking = null,Object? isModelReady = null,Object? errorMessage = freezed,Object? errorIsCapabilityGap = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TranslationStatus,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as Language,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as Language,transcription: freezed == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,isSpeaking: null == isSpeaking ? _self.isSpeaking : isSpeaking // ignore: cast_nullable_to_non_nullable
as bool,isModelReady: null == isModelReady ? _self.isModelReady : isModelReady // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorIsCapabilityGap: null == errorIsCapabilityGap ? _self.errorIsCapabilityGap : errorIsCapabilityGap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanguageCopyWith<$Res> get sourceLanguage {
  
  return $LanguageCopyWith<$Res>(_self.sourceLanguage, (value) {
    return _then(_self.copyWith(sourceLanguage: value));
  });
}/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanguageCopyWith<$Res> get targetLanguage {
  
  return $LanguageCopyWith<$Res>(_self.targetLanguage, (value) {
    return _then(_self.copyWith(targetLanguage: value));
  });
}
}


/// Adds pattern-matching-related methods to [TranslationState].
extension TranslationStatePatterns on TranslationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationState value)  $default,){
final _that = this;
switch (_that) {
case _TranslationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationState value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TranslationStatus status,  Language sourceLanguage,  Language targetLanguage,  String? transcription,  String? translation,  bool isSpeaking,  bool isModelReady,  String? errorMessage,  bool errorIsCapabilityGap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.status,_that.sourceLanguage,_that.targetLanguage,_that.transcription,_that.translation,_that.isSpeaking,_that.isModelReady,_that.errorMessage,_that.errorIsCapabilityGap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TranslationStatus status,  Language sourceLanguage,  Language targetLanguage,  String? transcription,  String? translation,  bool isSpeaking,  bool isModelReady,  String? errorMessage,  bool errorIsCapabilityGap)  $default,) {final _that = this;
switch (_that) {
case _TranslationState():
return $default(_that.status,_that.sourceLanguage,_that.targetLanguage,_that.transcription,_that.translation,_that.isSpeaking,_that.isModelReady,_that.errorMessage,_that.errorIsCapabilityGap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TranslationStatus status,  Language sourceLanguage,  Language targetLanguage,  String? transcription,  String? translation,  bool isSpeaking,  bool isModelReady,  String? errorMessage,  bool errorIsCapabilityGap)?  $default,) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.status,_that.sourceLanguage,_that.targetLanguage,_that.transcription,_that.translation,_that.isSpeaking,_that.isModelReady,_that.errorMessage,_that.errorIsCapabilityGap);case _:
  return null;

}
}

}

/// @nodoc


class _TranslationState implements TranslationState {
  const _TranslationState({this.status = TranslationStatus.idle, required this.sourceLanguage, required this.targetLanguage, this.transcription, this.translation, this.isSpeaking = false, this.isModelReady = false, this.errorMessage, this.errorIsCapabilityGap = false});
  

@override@JsonKey() final  TranslationStatus status;
@override final  Language sourceLanguage;
@override final  Language targetLanguage;
@override final  String? transcription;
@override final  String? translation;
@override@JsonKey() final  bool isSpeaking;
@override@JsonKey() final  bool isModelReady;
@override final  String? errorMessage;
/// True when [errorMessage] describes a missing capability (no offline
/// voice for this language) rather than a failure. The translation is
/// still valid and stays on screen, so this shouldn't be dressed up as an
/// error — PRD §22 asks for an explanation, not an alarm.
@override@JsonKey() final  bool errorIsCapabilityGap;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationStateCopyWith<_TranslationState> get copyWith => __$TranslationStateCopyWithImpl<_TranslationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationState&&(identical(other.status, status) || other.status == status)&&(identical(other.sourceLanguage, sourceLanguage) || other.sourceLanguage == sourceLanguage)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.isSpeaking, isSpeaking) || other.isSpeaking == isSpeaking)&&(identical(other.isModelReady, isModelReady) || other.isModelReady == isModelReady)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.errorIsCapabilityGap, errorIsCapabilityGap) || other.errorIsCapabilityGap == errorIsCapabilityGap));
}


@override
int get hashCode => Object.hash(runtimeType,status,sourceLanguage,targetLanguage,transcription,translation,isSpeaking,isModelReady,errorMessage,errorIsCapabilityGap);

@override
String toString() {
  return 'TranslationState(status: $status, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, transcription: $transcription, translation: $translation, isSpeaking: $isSpeaking, isModelReady: $isModelReady, errorMessage: $errorMessage, errorIsCapabilityGap: $errorIsCapabilityGap)';
}


}

/// @nodoc
abstract mixin class _$TranslationStateCopyWith<$Res> implements $TranslationStateCopyWith<$Res> {
  factory _$TranslationStateCopyWith(_TranslationState value, $Res Function(_TranslationState) _then) = __$TranslationStateCopyWithImpl;
@override @useResult
$Res call({
 TranslationStatus status, Language sourceLanguage, Language targetLanguage, String? transcription, String? translation, bool isSpeaking, bool isModelReady, String? errorMessage, bool errorIsCapabilityGap
});


@override $LanguageCopyWith<$Res> get sourceLanguage;@override $LanguageCopyWith<$Res> get targetLanguage;

}
/// @nodoc
class __$TranslationStateCopyWithImpl<$Res>
    implements _$TranslationStateCopyWith<$Res> {
  __$TranslationStateCopyWithImpl(this._self, this._then);

  final _TranslationState _self;
  final $Res Function(_TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? sourceLanguage = null,Object? targetLanguage = null,Object? transcription = freezed,Object? translation = freezed,Object? isSpeaking = null,Object? isModelReady = null,Object? errorMessage = freezed,Object? errorIsCapabilityGap = null,}) {
  return _then(_TranslationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TranslationStatus,sourceLanguage: null == sourceLanguage ? _self.sourceLanguage : sourceLanguage // ignore: cast_nullable_to_non_nullable
as Language,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as Language,transcription: freezed == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String?,translation: freezed == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String?,isSpeaking: null == isSpeaking ? _self.isSpeaking : isSpeaking // ignore: cast_nullable_to_non_nullable
as bool,isModelReady: null == isModelReady ? _self.isModelReady : isModelReady // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,errorIsCapabilityGap: null == errorIsCapabilityGap ? _self.errorIsCapabilityGap : errorIsCapabilityGap // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanguageCopyWith<$Res> get sourceLanguage {
  
  return $LanguageCopyWith<$Res>(_self.sourceLanguage, (value) {
    return _then(_self.copyWith(sourceLanguage: value));
  });
}/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanguageCopyWith<$Res> get targetLanguage {
  
  return $LanguageCopyWith<$Res>(_self.targetLanguage, (value) {
    return _then(_self.copyWith(targetLanguage: value));
  });
}
}

// dart format on
