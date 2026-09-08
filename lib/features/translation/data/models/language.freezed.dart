// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Language {

/// BCP-47-ish language code, e.g. "en", "fr".
 String get code; String get displayName;/// Path to a flag image in `assets/Images/`, or null when one hasn't been
/// drawn yet — the UI then falls back to a lettered badge rather than an
/// emoji, whose rendering varies wildly across platforms and is banned on
/// some of them.
 String? get flagAsset;/// Full locale handed to the offline TTS engine, e.g. "en-US". Platform
/// speech engines match on region, so a bare "en" is not enough.
 String get ttsLocale;/// True for scripts written right-to-left. Arabic text rendered in a
/// left-aligned box sits on the wrong side and reads as broken to anyone
/// who uses the script.
 bool get isRtl; bool get supportsAsr; bool get supportsTts; bool get isEnabled;
/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageCopyWith<Language> get copyWith => _$LanguageCopyWithImpl<Language>(this as Language, _$identity);

  /// Serializes this Language to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Language&&(identical(other.code, code) || other.code == code)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.flagAsset, flagAsset) || other.flagAsset == flagAsset)&&(identical(other.ttsLocale, ttsLocale) || other.ttsLocale == ttsLocale)&&(identical(other.isRtl, isRtl) || other.isRtl == isRtl)&&(identical(other.supportsAsr, supportsAsr) || other.supportsAsr == supportsAsr)&&(identical(other.supportsTts, supportsTts) || other.supportsTts == supportsTts)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,displayName,flagAsset,ttsLocale,isRtl,supportsAsr,supportsTts,isEnabled);

@override
String toString() {
  return 'Language(code: $code, displayName: $displayName, flagAsset: $flagAsset, ttsLocale: $ttsLocale, isRtl: $isRtl, supportsAsr: $supportsAsr, supportsTts: $supportsTts, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $LanguageCopyWith<$Res>  {
  factory $LanguageCopyWith(Language value, $Res Function(Language) _then) = _$LanguageCopyWithImpl;
@useResult
$Res call({
 String code, String displayName, String? flagAsset, String ttsLocale, bool isRtl, bool supportsAsr, bool supportsTts, bool isEnabled
});




}
/// @nodoc
class _$LanguageCopyWithImpl<$Res>
    implements $LanguageCopyWith<$Res> {
  _$LanguageCopyWithImpl(this._self, this._then);

  final Language _self;
  final $Res Function(Language) _then;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? displayName = null,Object? flagAsset = freezed,Object? ttsLocale = null,Object? isRtl = null,Object? supportsAsr = null,Object? supportsTts = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,flagAsset: freezed == flagAsset ? _self.flagAsset : flagAsset // ignore: cast_nullable_to_non_nullable
as String?,ttsLocale: null == ttsLocale ? _self.ttsLocale : ttsLocale // ignore: cast_nullable_to_non_nullable
as String,isRtl: null == isRtl ? _self.isRtl : isRtl // ignore: cast_nullable_to_non_nullable
as bool,supportsAsr: null == supportsAsr ? _self.supportsAsr : supportsAsr // ignore: cast_nullable_to_non_nullable
as bool,supportsTts: null == supportsTts ? _self.supportsTts : supportsTts // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Language].
extension LanguagePatterns on Language {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Language value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Language() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Language value)  $default,){
final _that = this;
switch (_that) {
case _Language():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Language value)?  $default,){
final _that = this;
switch (_that) {
case _Language() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String displayName,  String? flagAsset,  String ttsLocale,  bool isRtl,  bool supportsAsr,  bool supportsTts,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Language() when $default != null:
return $default(_that.code,_that.displayName,_that.flagAsset,_that.ttsLocale,_that.isRtl,_that.supportsAsr,_that.supportsTts,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String displayName,  String? flagAsset,  String ttsLocale,  bool isRtl,  bool supportsAsr,  bool supportsTts,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _Language():
return $default(_that.code,_that.displayName,_that.flagAsset,_that.ttsLocale,_that.isRtl,_that.supportsAsr,_that.supportsTts,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String displayName,  String? flagAsset,  String ttsLocale,  bool isRtl,  bool supportsAsr,  bool supportsTts,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _Language() when $default != null:
return $default(_that.code,_that.displayName,_that.flagAsset,_that.ttsLocale,_that.isRtl,_that.supportsAsr,_that.supportsTts,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Language implements Language {
  const _Language({required this.code, required this.displayName, this.flagAsset, required this.ttsLocale, this.isRtl = false, this.supportsAsr = true, this.supportsTts = true, this.isEnabled = true});
  factory _Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

/// BCP-47-ish language code, e.g. "en", "fr".
@override final  String code;
@override final  String displayName;
/// Path to a flag image in `assets/Images/`, or null when one hasn't been
/// drawn yet — the UI then falls back to a lettered badge rather than an
/// emoji, whose rendering varies wildly across platforms and is banned on
/// some of them.
@override final  String? flagAsset;
/// Full locale handed to the offline TTS engine, e.g. "en-US". Platform
/// speech engines match on region, so a bare "en" is not enough.
@override final  String ttsLocale;
/// True for scripts written right-to-left. Arabic text rendered in a
/// left-aligned box sits on the wrong side and reads as broken to anyone
/// who uses the script.
@override@JsonKey() final  bool isRtl;
@override@JsonKey() final  bool supportsAsr;
@override@JsonKey() final  bool supportsTts;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageCopyWith<_Language> get copyWith => __$LanguageCopyWithImpl<_Language>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Language&&(identical(other.code, code) || other.code == code)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.flagAsset, flagAsset) || other.flagAsset == flagAsset)&&(identical(other.ttsLocale, ttsLocale) || other.ttsLocale == ttsLocale)&&(identical(other.isRtl, isRtl) || other.isRtl == isRtl)&&(identical(other.supportsAsr, supportsAsr) || other.supportsAsr == supportsAsr)&&(identical(other.supportsTts, supportsTts) || other.supportsTts == supportsTts)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,displayName,flagAsset,ttsLocale,isRtl,supportsAsr,supportsTts,isEnabled);

@override
String toString() {
  return 'Language(code: $code, displayName: $displayName, flagAsset: $flagAsset, ttsLocale: $ttsLocale, isRtl: $isRtl, supportsAsr: $supportsAsr, supportsTts: $supportsTts, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$LanguageCopyWith<$Res> implements $LanguageCopyWith<$Res> {
  factory _$LanguageCopyWith(_Language value, $Res Function(_Language) _then) = __$LanguageCopyWithImpl;
@override @useResult
$Res call({
 String code, String displayName, String? flagAsset, String ttsLocale, bool isRtl, bool supportsAsr, bool supportsTts, bool isEnabled
});




}
/// @nodoc
class __$LanguageCopyWithImpl<$Res>
    implements _$LanguageCopyWith<$Res> {
  __$LanguageCopyWithImpl(this._self, this._then);

  final _Language _self;
  final $Res Function(_Language) _then;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? displayName = null,Object? flagAsset = freezed,Object? ttsLocale = null,Object? isRtl = null,Object? supportsAsr = null,Object? supportsTts = null,Object? isEnabled = null,}) {
  return _then(_Language(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,flagAsset: freezed == flagAsset ? _self.flagAsset : flagAsset // ignore: cast_nullable_to_non_nullable
as String?,ttsLocale: null == ttsLocale ? _self.ttsLocale : ttsLocale // ignore: cast_nullable_to_non_nullable
as String,isRtl: null == isRtl ? _self.isRtl : isRtl // ignore: cast_nullable_to_non_nullable
as bool,supportsAsr: null == supportsAsr ? _self.supportsAsr : supportsAsr // ignore: cast_nullable_to_non_nullable
as bool,supportsTts: null == supportsTts ? _self.supportsTts : supportsTts // ignore: cast_nullable_to_non_nullable
as bool,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
